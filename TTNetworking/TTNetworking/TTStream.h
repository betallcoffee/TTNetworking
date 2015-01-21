//
//  TTStream.h
//  TTNetworking
//
//  Created by liang on 1/20/15.
//  Copyright (c) 2015 liangliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTStream;

typedef NSUInteger(^ScannerBlock)(TTStream * stream, NSData *data);

@protocol TTStreamDelegate <NSObject>

- (void)onOpen;
- (void)onClose;
- (void)onFailedCode:(NSInteger)code message:(NSString *)message;

@end

@interface TTStream : NSObject<NSStreamDelegate>

@property (nonatomic, assign) id<TTStreamDelegate> delegate;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, assign) UInt32 port;

- (instancetype)initWithHost:(NSString *)host AndPort:(UInt32)port;
- (void)setNextScanner:(ScannerBlock)scanner;
- (void)open;
- (void)close;
- (void)send;

@end
