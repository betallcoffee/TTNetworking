//
//  TTHTTPClient.m
//  swott4.0
//
//  Created by liang on 8/14/14.
//  Copyright (c) 2014 liang. All rights reserved.
//

#import "TTHTTPClient.h"
#import "TTHTTPLog.h"

@interface TTHTTPClient() {
    NSThread *_networkRequestThread;
    NSMutableDictionary *_connections;
}

@end

@implementation TTHTTPClient

+ (instancetype)sharedInstanced {
    static TTHTTPClient *sharedInstanced;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (sharedInstanced == nil) {
            sharedInstanced = [[TTHTTPClient alloc] init];
        }
    });
    return sharedInstanced;
}

- (id)init {
    self = [super init];
    if (self) {
        _connections = [[NSMutableDictionary alloc] init];
        _networkRequestThread = [[NSThread alloc] initWithTarget:self
                                                        selector:@selector(networkRequestThreadEntry:)
                                                          object:nil];
        [_networkRequestThread start];
    }
    return self;
}

- (void)networkRequestThreadEntry:(id)__unused object {
    NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
    [currentRunLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    do {
        @autoreleasepool {
            @try {
                [currentRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            } @catch (NSException *e) {
                TTHTTPLogE(@"TTHTTPRequestThread : %@", [e callStackSymbols]);
            }
        }
    } while (true);
}

- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(HTTPCompletion)completion {
    TTHTTPRequest *request = [TTHTTPRequest GET:URLString parameters:parameters];
    [self execute:request completion:completion];
}

- (void)POST:(NSString *)URLString JSONBody:(id)JSONBody completion:(HTTPCompletion)completion {
    TTHTTPRequest *request = [TTHTTPRequest POST:URLString JSONBody:JSONBody];
    [self execute:request completion:completion];
}

- (void)execute:(TTHTTPRequest *)request completion:(HTTPCompletion)completion {
    NSString *key = [NSString stringWithFormat:@"%p", request];
    TTURLConnection *connection = [[TTURLConnection alloc] initWithRequest:request completion:^(TTHTTPRequest *request, NSError *error, BOOL isSuccess) {
        [_connections removeObjectForKey:key];
        TTHTTPLogD(@"TTHTTPClient execute:%@(method:%@/body:%@)", request.request.URL,
              request.request.HTTPMethod,
              [[NSString alloc] initWithData:request.request.HTTPBody encoding:NSUTF8StringEncoding]);
        if(isSuccess) TTHTTPLogD(@"TTHTTPClient response:%@", request.responseObject);
        if (completion) {
            completion(request, error, isSuccess);
        }
    }];
    [_connections setValue:connection forKey:key];
    [connection startOnNetworkThread:_networkRequestThread];
}

@end
