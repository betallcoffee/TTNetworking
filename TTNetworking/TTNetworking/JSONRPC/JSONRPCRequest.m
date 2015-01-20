//
//  JSONRPCRequest.m
//  TTNetworking
//
//  Created by liang on 8/14/14.
//  Copyright (c) 2014 liang. All rights reserved.
//

#import "TTLog.h"
#import "JSONRPCRequest.h"
#import "JSONRPCClient.h"

static NSString *const kLogTag = @"JSONRPCRequest";

@interface JSONRPCRequest ()
{
    NSString *_method;
    NSMutableArray *_params;
    NSNumber *_id;
}

@end

@implementation JSONRPCRequest

- (id)initWithMethod:(NSString *)method params:(NSArray *)params {
    self = [super init];
    if (self) {
        _method = method;
        _params = [[NSMutableArray alloc] initWithCapacity:params.count];
        _id = [NSNumber numberWithInteger:0];
        for (id value in params) {
            if ([value isKindOfClass:[NSMutableString class]]) {
                [_params addObject:value];
            } else if ([value isKindOfClass:[NSNumber class]]) {
                [_params addObject:value];
            } else if ([value conformsToProtocol:@protocol(JSONRPCParam)]){
                NSDictionary *param = [value performSelector:@selector(encode) withObject:nil];
                [_params addObject:param];
            } else {
                TTLogW(@"initWithMethod:%@(param:%@) is invalide.", _method, value);
            }
        }
    }
    return self;
}

- (NSDictionary *)requestBody {
    if (_method == nil || _params.count == 0) {
        return nil;
    }
    return @{@"method": _method, @"params" : _params, @"id" : _id};
}

- (void)setID:(NSInteger)id_ {
    _id = [NSNumber numberWithInteger:id_];
}

- (NSNumber *)getID {
    return _id;
}

@end
