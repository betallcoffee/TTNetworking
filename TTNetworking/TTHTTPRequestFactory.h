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

+ (TTHTTPRequest *)GET:(NSString *)URLString
            parameters:(NSDictionary *)parameters;

+ (TTHTTPRequest *)POST:(NSString *)URLString
               JSONBody:(id)JSONBody;

@end
