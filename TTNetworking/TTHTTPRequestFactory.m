//
//  TTHTTPRequestFactory.m
//  
//
//  Created by liang on 1/7/14.
//
//

#import "TTHTTPRequestFactory.h"
#import "TTHTTPRequest.h"

@interface TTHTTPRequestFactory() {
    NSThread *_networkRequestThread;
}

@property (nonatomic, readonly) NSThread *networkRequestThread;

@end

@implementation TTHTTPRequestFactory

+ (TTHTTPRequestFactory *)sharedInstance {
    static TTHTTPRequestFactory *pSharedInstance;
    static dispatch_once_t onceNetwork;
    dispatch_once(&onceNetwork, ^{
        pSharedInstance = [[TTHTTPRequestFactory alloc] init];
    });
    return pSharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _networkRequestThread = [[NSThread alloc] initWithTarget:self
                                                        selector:@selector(networkRequestThreadEntry:)
                                                          object:nil];
        [_networkRequestThread start];
        return self;
    }
    return nil;
}

- (void)networkRequestThreadEntry:(id)__unused object {
    NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
    [currentRunLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    do {
        @autoreleasepool {
            @try {
                [currentRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            } @catch (NSException *e) {
                NSLog(@"TTHTTPRequestThread : %@", [e callStackSymbols]);
            }
        }
    } while (true);
}

+ (TTHTTPRequest *)GET:(NSString *)URLString
            parameters:(NSDictionary *)parameters
               success:(HTTPCompleteBlock)success
               failure:(HTTPCompleteBlock)failure {
    NSParameterAssert(failure);
    NSParameterAssert(success);
    NSParameterAssert(URLString);
    
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSParameterAssert(url);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    TTHTTPRequest *httpRequest = [[TTHTTPRequest alloc] initWithRequest:request
                                                            withSuccess:success
                                                             andFailure:failure];
    httpRequest.networkThread = [TTHTTPRequestFactory sharedInstance].networkRequestThread;
    
    if (parameters) {
        NSError *error;
        [httpRequest setParameters:parameters withStringEncoding:NSUTF8StringEncoding error:&error];
    }
    
    httpRequest.responseSerialization = [[TTJSONResponseSerialization alloc] init];
    return httpRequest;
}

+ (TTHTTPRequest *)POST:(NSString *)URLString
               JSONBody:(id)JSONBody
                success:(HTTPCompleteBlock)success
                failure:(HTTPCompleteBlock)failure {
    NSParameterAssert(failure);
    NSParameterAssert(success);
    NSParameterAssert(URLString);
    
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSParameterAssert(url);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    TTHTTPRequest *httpRequest = [[TTHTTPRequest alloc] initWithRequest:request
                                                            withSuccess:success
                                                             andFailure:failure];
    httpRequest.networkThread = [TTHTTPRequestFactory sharedInstance].networkRequestThread;
    httpRequest.hasRequestBody = YES;
    NSError *error;
    [httpRequest setJSONBody:JSONBody withStringEncoding:NSUTF8StringEncoding error:&error];
    httpRequest.responseSerialization = [[TTJSONResponseSerialization alloc] init];
    return httpRequest;
}


@end
