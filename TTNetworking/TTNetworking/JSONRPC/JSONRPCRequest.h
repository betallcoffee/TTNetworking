//
//  JSONRPCRequest.h
//  TTNetworking
//
//  Created by liang on 8/14/14.
//  Copyright (c) 2014 liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONRPCRequest : NSObject

@property (nonatomic, strong) NSString *url;

- (id)initWithMethod:(NSString *)method params:(NSArray *)param;
- (NSDictionary *)requestBody;
- (void)setID:(NSInteger)id_;
- (NSNumber *)getID;

@end
