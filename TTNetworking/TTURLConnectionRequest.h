//
//  TTURLConnectionRequest.h
//  
//
//  Created by liang on 1/7/14.
//
//

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)(void);

@interface TTURLConnectionRequest : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSThread *networkThread;
@property (readonly, nonatomic) NSMutableURLRequest *request;
@property (nonatomic, assign) NSStringEncoding *requestStringEncoding;
@property (readonly, nonatomic) NSURLResponse *response;
@property (readonly, nonatomic) NSString *responseString;
@property (readonly, nonatomic) NSMutableData *responseData;
@property (readonly, nonatomic) NSStringEncoding responseStringEncoding;
@property (readonly, nonatomic) NSError *error;

- (id)initWithRequest:(NSURLRequest *)request;

- (void)setCompletionBlockWithSuccess:(CompletionBlock)success
                              failure:(CompletionBlock)failure;


- (void)start;

- (void)cancel;

@end
