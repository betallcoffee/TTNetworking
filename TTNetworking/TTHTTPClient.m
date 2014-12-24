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

- (id)init {
    self = [super init];
    if (self) {
        _connections = [[NSMutableDictionary alloc] init];
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
    @autoreleasepool {
        do {
            @try {
                [currentRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            } @catch (NSException *e) {
                TTHTTPLogE(@"TTHTTPRequestThread : %@", [e callStackSymbols]);
            }
        }while (true);
    }
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
