//
//  TTHTTPRequest.h
//  
//
//  Created by liang on 1/8/14.
//
//

#import "TTURLConnectionRequest.h"

@protocol TTHTTPRequestSerialization <NSObject>

- (void)request:(NSMutableURLRequest *)request withParam:(NSDictionary *)parameters error:(NSError *__autoreleasing*)error;

@end

@protocol TTHTTPResponseSerialization <NSObject>

- (id)responseObjectFor:(NSURLResponse *)response withData:(NSData *)data error:(NSError *__autoreleasing*)error;

@end

@interface TTHTTPRequest : TTURLConnectionRequest

typedef void (^HTTPCompleteBlock)(TTHTTPRequest *);

@property (nonatomic, assign) BOOL hasRequestBody;
@property (nonatomic, readonly) NSString *statusCode;
@property (nonatomic, readonly) id responseObject;
@property (nonatomic, strong) id<TTHTTPRequestSerialization>requestSerialization;
@property (nonatomic, strong) id<TTHTTPResponseSerialization>responseSerialization;

- (id)initWithRequest:(NSMutableURLRequest *)request withSuccess:(HTTPCompleteBlock)success andFailure:(HTTPCompleteBlock)failure;
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