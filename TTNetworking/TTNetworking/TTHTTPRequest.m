//
//  TTHTTPRequest.m
//  
//
//  Created by liang on 1/8/14.
//
//

#import "TTHTTPRequest.h"

static NSString * const kCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";

NSString *percentEscapeQueryStringWithStringEncoding(NSString *string, NSStringEncoding stringEncoding) {
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (__bridge CFStringRef)string,
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)kCharactersToBeEscapedInQueryString,
                                                                                 CFStringConvertNSStringEncodingToEncoding(stringEncoding));
}

@implementation TTHTTPRequest

@synthesize response = _response;
@synthesize responseObject = _responseObject;
@synthesize responseString = _responseString;

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
    return httpRequest;
}

- (id)initWithRequest:(NSMutableURLRequest *)request {
    self = [super init];
    if (self) {
        _request = request;
        _hasRequestBody = NO;
        _responseData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)setParameters:(NSDictionary *)parameters withStringEncoding:(NSStringEncoding)stringEncoding error:(NSError *__autoreleasing *)error{
    NSParameterAssert(parameters);
    
    NSMutableArray *queryArray = [[NSMutableArray alloc] init];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [queryArray addObject:[NSString stringWithFormat:@"%@=%@", percentEscapeQueryStringWithStringEncoding(key, stringEncoding),
                               percentEscapeQueryStringWithStringEncoding(obj, stringEncoding)]];
    }];
    NSString *queryString = [queryArray componentsJoinedByString:@"&"];
    if (!_hasRequestBody) {
        NSString *url = [[self.request.URL absoluteString] stringByAppendingFormat:self.request.URL.query ? @"&%@" : @"?%@" , queryString];
        self.request.URL = [[NSURL alloc] initWithString:url];
    } else {
        NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(stringEncoding));
        [self.request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
        [self.request setHTTPBody:[queryString dataUsingEncoding:stringEncoding]];
    }
}

- (void)setJSONBody:(id)JSONBody withStringEncoding:(NSStringEncoding)stringEncoding error:(NSError *__autoreleasing *)error {
    NSParameterAssert(JSONBody);
    
    if (_hasRequestBody) {
        NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(stringEncoding));
        [self.request setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
        [self.request setHTTPBody:[NSJSONSerialization dataWithJSONObject:JSONBody options:NSJSONWritingPrettyPrinted error:error]];
    }
}

- (void)setPlistBody:(id)plistBody withStringencoding:(NSStringEncoding)stringEncoding error:(NSError *__autoreleasing *)error {
    NSParameterAssert(plistBody);
    
    if (_hasRequestBody) {
        NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(stringEncoding));
        [self.request setValue:[NSString stringWithFormat:@"application/x-plist; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
        [self.request setHTTPBody:[NSPropertyListSerialization dataWithPropertyList:plistBody
                                                                             format:NSPropertyListXMLFormat_v1_0
                                                                            options:0
                                                                              error:error]];
    }
}

- (void)setResponse:(NSURLResponse *)response {
    _response = response;
    if ([_response.MIMEType compare:@"text/html"] == NSOrderedSame) {
        self.responseSerialization = [[TTStringSerialization alloc] init];
    } else if ([_response.MIMEType compare:@"application/json"]  == NSOrderedSame) {
        self.responseSerialization = [[TTJSONSerialization alloc] init];
    } else if ([_response.MIMEType compare:@"application/x-plist"]  == NSOrderedSame) {
        self.responseSerialization = [[TTXMLSerialization alloc] init];
    } else {
        self.responseSerialization = nil;
    }
}

- (id)responseObject {
    NSError *error;
    if (self.responseSerialization != nil) {
       _responseObject = [self.responseSerialization responseObjectFor:self.response withData:self.responseData error:&error];
    } else {
        _responseObject = self.responseData;
    }
    return _responseObject;
}

- (NSString *)responseString {
    if (_responseString == nil) {
        NSStringEncoding stringEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)self.response.textEncodingName));
        _responseString = [[NSString alloc] initWithData:self.responseData encoding:stringEncoding];
    }
    return _responseString;
}

@end
                                      
@implementation TTStringSerialization

- (id)responseObjectFor:(NSURLResponse *)response withData:(NSData *)data error:(NSError *__autoreleasing *)error {
    NSParameterAssert(response.textEncodingName);
    NSParameterAssert(data);
    NSStringEncoding stringEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)response.textEncodingName));
    return [[NSString alloc] initWithData:data encoding:stringEncoding];
}

@end

@implementation TTJSONSerialization

- (id)responseObjectFor:(NSURLResponse *)response withData:(NSData *)data error:(NSError *__autoreleasing *)error {
    NSParameterAssert(response.textEncodingName);
    NSParameterAssert(data);
    NSStringEncoding stringEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)response.textEncodingName));
    NSString *responseString = [[NSString alloc] initWithData:data encoding:stringEncoding];
    data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
}

@end

@implementation TTXMLSerialization

- (id)responseObjectFor:(NSURLResponse *)response withData:(NSData *)data error:(NSError *__autoreleasing *)error {
    NSParameterAssert(response.textEncodingName);
    NSParameterAssert(data);
    NSStringEncoding stringEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)response.textEncodingName));
    NSString *responseString = [[NSString alloc] initWithData:data encoding:stringEncoding];
    data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSPropertyListSerialization propertyListWithData:data
                                                     options:0
                                                      format:0
                                                       error:error];
}

@end
