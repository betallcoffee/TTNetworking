//
//  TTURLConnection.h
//  
//
//  Created by liang on 1/7/14.
//
//

#import <Foundation/Foundation.h>

@class TTHTTPRequest;

typedef void (^HTTPCompletion) (TTHTTPRequest *request, NSError *error, BOOL isSuccess);

@interface TTURLConnection : NSObject<NSURLConnectionDataDelegate>

@property (readonly, nonatomic) TTHTTPRequest *request;

- (id)initWithRequest:(TTHTTPRequest *)request completion:(HTTPCompletion)completion;

- (void)start;

- (void)startOnNetworkThread:(NSThread *)networkThread;

- (void)cancel;

@end
