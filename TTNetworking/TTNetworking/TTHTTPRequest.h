//
//  TTHTTPRequest.h
//  
//
//  Created by liang on 1/8/14.
//
//

#import "TTURLConnection.h"

@protocol TTHTTPRequestSerialization <NSObject>

- (void)request:(NSMutableURLRequest *)request withParam:(NSDictionary *)parameters error:(NSError *__autoreleasing*)error;

@end

@protocol TTHTTPResponseSerialization <NSObject>

- (id)responseObjectFor:(NSURLResponse *)response withData:(NSData *)data error:(NSError *__autoreleasing*)error;

@end

@interface TTHTTPRequest : NSObject

@property (nonatomic, readonly) NSString *tag;
@property (readonly, nonatomic) NSMutableURLRequest *request;
@property (nonatomic, assign) BOOL hasRequestBody;
@property (nonatomic, readonly) NSString *statusCode;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, readonly) NSMutableData *responseData;
@property (nonatomic, readonly) id responseObject;
@property (nonatomic, readonly) NSString *responseString;
@property (nonatomic, strong) id<TTHTTPRequestSerialization>requestSerialization;
@property (nonatomic, strong) id<TTHTTPResponseSerialization>responseSerialization;

+ (TTHTTPRequest *)GET:(NSString *)URLString
            parameters:(NSDictionary *)parameters;

+ (TTHTTPRequest *)POST:(NSString *)URLString
               JSONBody:(id)JSONBody;

- (id)initWithRequest:(NSMutableURLRequest *)request;

- (void)setParameters:(NSDictionary *)parameters withStringEncoding:(NSStringEncoding)stringEncoding error:(NSError *__autoreleasing*)error;
- (void)setJSONBody:(id)JSONBody withStringEncoding:(NSStringEncoding)stringEncoding error:(NSError *__autoreleasing*)error;
- (void)setPlistBody:(id)plistBody withStringencoding:(NSStringEncoding)stringEncoding error:(NSError *__autoreleasing*)error;

@end


@interface TTJSONResponseSerialization : NSObject<TTHTTPResponseSerialization>

- (id)responseObjectFor:(NSURLResponse *)response withData:(NSData *)data error:(NSError *__autoreleasing*)error;

@end

@interface TTXMLResponseSerialization : NSObject<TTHTTPResponseSerialization>

- (id)responseObjectFor:(NSURLResponse *)response withData:(NSData *)data error:(NSError *__autoreleasing *)error;

@end