//
//  TTHTTPRequestFactory.m
//  
//
//  Created by liang on 1/7/14.
//
//

#import "TTHTTPRequestFactory.h"
#import "TTHTTPRequest.h"

@implementation TTHTTPRequestFactory

+ (TTHTTPRequest *)GET:(NSString *)URLString
            parameters:(NSDictionary *)parameters {
    NSParameterAssert(URLString);
    
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSParameterAssert(url);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    TTHTTPRequest *httpRequest = [[TTHTTPRequest alloc] initWithRequest:request];
    
    if (parameters) {
        NSError *error;
        [httpRequest setParameters:parameters withStringEncoding:NSUTF8StringEncoding error:&error];
    }
    
    httpRequest.responseSerialization = [[TTJSONResponseSerialization alloc] init];
    return httpRequest;
}

+ (TTHTTPRequest *)POST:(NSString *)URLString
               JSONBody:(id)JSONBody {
    NSParameterAssert(URLString);
    
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSParameterAssert(url);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    TTHTTPRequest *httpRequest = [[TTHTTPRequest alloc] initWithRequest:request];
    httpRequest.hasRequestBody = YES;
    NSError *error;
    [httpRequest setJSONBody:JSONBody withStringEncoding:NSUTF8StringEncoding error:&error];
    httpRequest.responseSerialization = [[TTJSONResponseSerialization alloc] init];
    return httpRequest;
}


@end
