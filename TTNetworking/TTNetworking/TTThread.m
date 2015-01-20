//
//  TTThread.m
//  TTNetworking
//
//  Created by liang on 1/20/15.
//  Copyright (c) 2015 liangliang. All rights reserved.
//

#import "TTThread.h"

static TTThread *thread = nil;
static NSRunLoop *runLoop = nil;

@implementation NSRunLoop (TTThread)

+ (NSRunLoop *)runLoop {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thread = [[TTThread alloc] init];
        thread.name = @"com.tina.TTThread";
        [thread start];
        runLoop = thread.runLoop;
    });
    
    return runLoop;
}

@end

@implementation TTThread {
    dispatch_group_t _waitGroup;
}

@synthesize runLoop = _runLoop;

- (id)init
{
    self = [super init];
    if (self) {
        _waitGroup = dispatch_group_create();
        dispatch_group_enter(_waitGroup);
    }
    return self;
}

- (void)main;
{
    _runLoop = [NSRunLoop currentRunLoop];
    dispatch_group_leave(_waitGroup);
    [_runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    do {
        @autoreleasepool {
            @try {
                [_runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            } @catch (NSException *e) {
                NSLog(@"TTThread : %@", [e callStackSymbols]);
            }
        }
    } while (true);
    assert(NO);
}

- (NSRunLoop *)runLoop;
{
    dispatch_group_wait(_waitGroup, DISPATCH_TIME_FOREVER);
    return _runLoop;
}

@end
