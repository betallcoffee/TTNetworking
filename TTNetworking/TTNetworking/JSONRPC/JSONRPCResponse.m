//
//  JSONRPCResponse.m
//  TTNetworking
//
//  Created by liang on 8/14/14.
//  Copyright (c) 2014 liang. All rights reserved.
//

#import "JSONRPCResponse.h"

NSString * const kRPCDomain = @"JSONRPCClient";

@interface JSONRPCResponse ()
{
    NSNumber *_id;
}
@end

@implementation JSONRPCResponse

- (id)initWithObject:(NSDictionary *)object {
    self = [super init];
    if (self) {
        _result = [object objectForKey:@"result"];
        _id = [object objectForKey:@"id"];
        NSDictionary *error = [object objectForKey:@"error"];
        if ([error isKindOfClass:[NSNull class]]) {
            _error = nil;
        } else {
            NSString *message = [error objectForKey:@"message"];
            if (message == nil) {
                _error = [[NSError alloc] initWithDomain:kRPCDomain
                                                    code:PARSEERROR
                                                userInfo:@{NSLocalizedDescriptionKey:@"parse error message error"}];
            } else {
                NSNumber *code = [error objectForKey:@"code"];
                if (code == nil) {
                    _error = [[NSError alloc] initWithDomain:kRPCDomain
                                                        code:PARSEERROR
                                                    userInfo:@{NSLocalizedDescriptionKey:@"parse error code error"}];
                } else {
                    _error = [[NSError alloc] initWithDomain:kRPCDomain
                                                        code:[code integerValue]
                                                    userInfo:@{NSLocalizedDescriptionKey:message}];
                }
            }
        }
    }
    return self;
}

- (id)initWithError:(NSError *)error {
    self = [super init];
    if (self) {
        _result = nil;
        _id = nil;
        _error = error;
    }
    return self;
}

- (id)initWithError:(NSError *)error atID:(NSNumber *)id_ {
    self = [super init];
    if (self) {
        _result = nil;
        _id = id_;
        _error = error;
    }
    return self;
}

- (NSNumber *)getID {
    return _id;
}

@end
