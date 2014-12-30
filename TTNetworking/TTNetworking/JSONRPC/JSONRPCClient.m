//
//  JSONRPCClient.m
//  TTNetworking
//
//  Created by liang on 8/14/14.
//  Copyright (c) 2014 liang. All rights reserved.
//

#import "JSONRPCLog.h"
#import "JSONRPCClient.h"
#import "JSONRPCHTTPWriter.h"
#import "JSONRPCRequest.h"

@interface JSONRPCClient ()
{
    NSString *_url;
}

@end

@implementation JSONRPCClient

- (instancetype)init {
    self = [super init];
    if (self) {
        _writer = [[JSONRPCHTTPWriter alloc] init];
    }
    return self;
}

- (void)callMethod:(NSString *)method params:(NSArray *)params toURL:(NSString *)url completion:(Completion)completion {
    JSONRPCRequest *request = [[JSONRPCRequest alloc] initWithMethod:method params:params];
    if (url != nil) request.url = url;
    else request.url = self.defaulURL;
    
    NSDictionary *requestBody = request.requestBody;
    if (requestBody == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                JSONRPCResponse *response = [[JSONRPCResponse alloc] initWithError:[[NSError alloc] initWithDomain:kRPCDomain
                                                                                                              code:INVALIDPARAMS
                                                                                                          userInfo:@{NSLocalizedDescriptionKey:@"params is invalide"}]];
                completion(response);
            }
        });
        return;
    }
    
    if (self.writer != nil) {
        [self.writer write:request completion:completion];
    }
}

@end
