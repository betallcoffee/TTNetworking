//
//  TTURLConnectionRequest.m
//  
//
//  Created by liang on 1/7/14.
//
//

#import "TTURLConnectionRequest.h"

@interface TTURLConnectionRequest() {
    NSLock *_lock;
    NSURLConnection *_connection;
    CompletionBlock _success;
    CompletionBlock _failure;
    BOOL _isCanceled;
}

@end

@implementation TTURLConnectionRequest

@synthesize responseString = _responseString;

- (id)initWithRequest:(NSMutableURLRequest *)request {
    self = [super init];
    if (self) {
        _isCanceled = NO;
        _request = request;
        _responseData = [[NSMutableData alloc] init];
        return self;
    }
    return nil;
}

- (void)setCompletionBlockWithSuccess:(CompletionBlock)success failure:(CompletionBlock)failure {
    NSParameterAssert(failure);
    NSParameterAssert(success);
    _success = success;
    _failure = failure;
}

- (void)start {
    [_lock lock];
    do {
        if (_isCanceled) break;
        [self performSelector:@selector(startOnNetworkThread)
                     onThread:_networkThread
                   withObject:nil
                waitUntilDone:NO];
        
    } while (NO);
    [_lock unlock];
}

- (void)startOnNetworkThread {
    NSRunLoop *currentLoop = [NSRunLoop currentRunLoop];
    [_lock lock];
    do {
        _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO];
        [_connection scheduleInRunLoop:currentLoop forMode:NSDefaultRunLoopMode];
        [_connection start];
    } while (NO);
    [_lock unlock];
}

- (void)cancel {
    [_lock lock];
    do {
        if (_isCanceled) break;
        _isCanceled = YES;
        if (_connection) {
            [_connection cancel];
        }
    } while (NO);
    [_lock unlock];
}

- (void)connectionSuccess {
    if (_success) {
        _success();
    }
}

- (void)connectionFailure {
    if (_failure) {
        _failure();
    }
}

- (NSString *)responseString {
    if (!_responseString) {
        _responseString = [[NSString alloc] initWithData:_responseData encoding:_responseStringEncoding];
    }
    return _responseString;
}

#pragma mark NSURLConnectionDataDelegate

//- (NSURLRequest *)connection:(NSURLConnection *)connection
//             willSendRequest:(NSURLRequest *)request
//            redirectResponse:(NSURLResponse *)response {
//    return request;
//}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _response = response;
    if (_response.textEncodingName) {
        _responseStringEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)_response.textEncodingName));
    } else {
        _responseStringEncoding = NSUTF8StringEncoding;
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [_lock lock];
    do {
        if (_isCanceled) break;
        _responseString = nil;
        if (_success) {
            [self performSelectorOnMainThread:@selector(connectionSuccess) withObject:nil waitUntilDone:NO];
        }
    } while (NO);
    [_lock unlock];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [_lock lock];
    do {
        if (_isCanceled) break;
        _responseString = nil;
        _error = error;
        if (_failure) {
            [self performSelectorOnMainThread:@selector(connectionFailure) withObject:nil waitUntilDone:NO];
        }
    } while (NO);
    [_lock unlock];
}

@end
