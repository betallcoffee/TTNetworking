//
//  JSONRPCResponse.h
//  TTNetworking
//
//  Created by liang on 8/14/14.
//  Copyright (c) 2014 liang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kRPCDomain;

/**
 * @enum RPCErrorCode
 * @brief json rpc define error code
 */
typedef enum : NSUInteger {
    UNKOWN         = 0,
    PARSEERROR     = -32700,
	INVALIDREQUEST = -32600,
	METHODNOTFOUND = -32601,
	INVALIDPARAMS  = -32602,
	INTERNALERROR  = -32603,
} RPCErrorCode;

@interface JSONRPCResponse : NSObject

@property (nonatomic, readonly) id result;
@property (nonatomic, readonly) NSError *error;

- (id)initWithObject:(NSDictionary *)object;
- (id)initWithError:(NSError *)error;
- (id)initWithError:(NSError *)error atID:(NSNumber *)id_;
- (NSNumber *)getID;

@end
