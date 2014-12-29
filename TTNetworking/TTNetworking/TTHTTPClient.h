//
//  TTHTTPClient.h
//  swott4.0
//
//  Created by liang on 8/14/14.
//  Copyright (c) 2014 liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTURLConnection.h"
#import "TTHTTPRequest.h"

@interface TTHTTPClient : NSObject

+ (instancetype)sharedInstanced;

- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(HTTPCompletion)completion;

- (void)POST:(NSString *)URLString JSONBody:(id)JSONBody completion:(HTTPCompletion)completion;

@end
