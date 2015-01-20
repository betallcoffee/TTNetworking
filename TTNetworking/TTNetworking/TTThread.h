//
//  TTThread.h
//  TTNetworking
//
//  Created by liang on 1/20/15.
//  Copyright (c) 2015 liangliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSRunLoop (TTThread)

+ (NSRunLoop *)runLoop;

@end

@interface TTThread : NSThread

@property (nonatomic, readonly) NSRunLoop *runLoop;

@end
