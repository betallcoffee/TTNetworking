//
//  JSONRPCClient.h
//  TTNetworking
//
//  Created by liang on 8/14/14.
//  Copyright (c) 2014 liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONRPCResponse.h"

@class JSONRPCRequest;

typedef void (^Completion)(JSONRPCResponse *response);

/**
 * @protocol JSONRPCParam JSONRPCClient.h "JSONRPCClient.h"
 * @brief JSONRPCClient::callMethod:params:competion 方法中第二个参数数组中的元素需实现 JSONRPCParam 协议
 * @details JSONRPCClient 打包请求时，将调用用参数的 encode 方法生成 JSON 格式的数据。
 */
@protocol JSONRPCParam <NSObject>

- (NSDictionary *)encode;
- (void)decode:(NSDictionary *)data;

@end

@protocol JSONRPCWriter <NSObject>

- (void)write:(JSONRPCRequest *)request completion:(Completion)completion;

@end

@protocol JSONRPCClientDelegate <NSObject>

- (void)notification:(JSONRPCResponse *)response;

@end

@interface JSONRPCClient : NSObject

@property (nonatomic, assign) id<JSONRPCClientDelegate> delegate;
@property (nonatomic, strong) id<JSONRPCWriter> writer;
@property (nonatomic, strong) NSString *defaulURL;

- (void)callMethod:(NSString *)method params:(NSArray *)params toURL:(NSString *)url completion:(Completion)completion;

@end
