//
//  TTURLConnection.m
//  
//
//  Created by liang on 1/7/14.
//
//

#import "TTURLConnection.h"
#import "TTHTTPRequest.h"

@interface TTURLConnection() {
    NSLock *_lock;
    BOOL _isCanceled;
    NSURLConnection *_connection;
    HTTPCompletion _completion;
}

@end

@implementation TTURLConnection

- (id)initWithRequest:(TTHTTPRequest *)request completion:(HTTPCompletion)completion {
    self = [super init];
    if (self) {
        _isCanceled = NO;
        _request = request;
        _completion = completion;
        return self;
    }
    return nil;
}

- (void)start {
    NSRunLoop *currentLoop = [NSRunLoop currentRunLoop];
    [_lock lock];
    do {
        _connection = [[NSURLConnection alloc] initWithRequest:_request.request delegate:self startImmediately:NO];
        [_connection scheduleInRunLoop:currentLoop forMode:NSDefaultRunLoopMode];
        [_connection start];
    } while (NO);
    [_lock unlock];
    
}

- (void)startOnNetworkThread:(NSThread *)networkThread {
    [_lock lock];
    do {
        if (_isCanceled) break;
        [self performSelector:@selector(start)
                     onThread:networkThread
                   withObject:nil
                waitUntilDone:NO];
        
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

#pragma mark NSURLConnectionDataDelegate

//- (NSURLRequest *)connection:(NSURLConnection *)connection
//             willSendRequest:(NSURLRequest *)request
//            redirectResponse:(NSURLResponse *)response {
//    return request;
//}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _request.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_request.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [_lock lock];
    do {
        if (_isCanceled) break;
        if (_completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _completion(_request, nil, YES);
            });
        }
    } while (NO);
    [_lock unlock];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [_lock lock];
    do {
        if (_isCanceled) break;
        if (_completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _completion(_request, error, NO);
            });
        }
    } while (NO);
    [_lock unlock];
}

@end
