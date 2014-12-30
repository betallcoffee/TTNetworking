//
//  JSONRPCHTTPWriter.m
//  TTNetworking
//
//  Created by liang on 12/30/14.
//  Copyright (c) 2014 liangliang. All rights reserved.
//

#import "TTHTTPClient.h"
#import "TTHTTPRequest.h"
#import "JSONRPCHTTPWriter.h"
#import "JSONRPCRequest.h"

@implementation JSONRPCHTTPWriter

- (void)write:(JSONRPCRequest *)request completion:(Completion)completion {
    [[TTHTTPClient sharedInstanced] POST:request.url
                                JSONBody:request.requestBody
                              completion:^(TTHTTPRequest *httpRequest, NSError *error, BOOL isSuccess) {
        JSONRPCResponse *response;
        if (isSuccess && httpRequest.responseObject) {
            response = [[JSONRPCResponse alloc] initWithObject:httpRequest.responseObject];
        } else {
            response = [[JSONRPCResponse alloc] initWithError:[[NSError alloc] initWithDomain:kRPCDomain
                                                                                         code:INTERNALERROR
                                                                                     userInfo:@{NSLocalizedDescriptionKey:[error localizedDescription]}]];
        }
        
        if (completion) {
            completion(response);
        }
    }];
}

@end
