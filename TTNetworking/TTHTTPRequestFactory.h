//
//  TTHTTPRequestFactory.h
//  
//
//  Created by liang on 1/7/14.
//
//

#import <Foundation/Foundation.h>
#import "TTHTTPRequest.h"

@interface TTHTTPRequestFactory : NSObject

+ (TTHTTPRequestFactory *)sharedInstance;

+ (TTHTTPRequest *)GET:(NSString *)URLString
             parameters:(NSDictionary *)parameters
               success:(HTTPCompleteBlock) success
               failure:(HTTPCompleteBlock)failure;

+ (TTHTTPRequest *)POST:(NSString *)URLString
               JSONBody:(id)JSONBody
                success:(HTTPCompleteBlock)success
                failure:(HTTPCompleteBlock)failure;

@end
