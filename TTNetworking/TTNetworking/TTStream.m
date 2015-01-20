//
//  TTStream.m
//  TTNetworking
//
//  Created by liang on 1/20/15.
//  Copyright (c) 2015 liangliang. All rights reserved.
//

#import "TTStream.h"
#import "TTThread.h"

typedef enum : NSUInteger {
    eStatusInit,
    eStatusConnecting,
    eStatusOpen,
    eStatusClosing,
} eStreamStatus;

@interface TTStream ()
{
    eStreamStatus _status;
    dispatch_queue_t _delegateDispatchQueue;
    dispatch_queue_t _workQueue;
    
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
    
    NSMutableData *_readBuffer;
    NSUInteger _readBufferOffset;
    
    NSMutableData *_writeBuffer;
    NSUInteger _writeBufferOffset;
}

@end

@implementation TTStream

- (instancetype)initWithHost:(NSString *)host AndPort:(UInt32)port {
    self = [super init];
    if (self) {
        _status = eStatusInit;
        _host = host;
        _port= port;
        _workQueue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
        
        // Going to set a specific on the queue so we can validate we're on the work queue
        dispatch_queue_set_specific(_workQueue, (__bridge void *)self, (__bridge void *)_workQueue, NULL);
        
        _delegateDispatchQueue = dispatch_get_main_queue();
        
        _readBuffer = [[NSMutableData alloc] init];
        _writeBuffer = [[NSMutableData alloc] init];
        
        _readBufferOffset = _writeBufferOffset = 0;
        
    }
    return self;
}

- (void)open {
    if (_status != eStatusInit) {
        return;
    }
    _status = eStatusConnecting;
    
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)_host, _port, &readStream, &writeStream);
    
    _outputStream = CFBridgingRelease(writeStream);
    _inputStream = CFBridgingRelease(readStream);
    
    _outputStream.delegate = self;
    _inputStream.delegate = self;
    
    [_outputStream scheduleInRunLoop:[NSRunLoop runLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream scheduleInRunLoop:[NSRunLoop runLoop] forMode:NSDefaultRunLoopMode];
}

- (void)close {
    
}

- (void)setNextScanner:(scannerBlock)scanner {
    
}

#pragma mark NSStreamDelegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    dispatch_async(_workQueue, ^{
        switch (eventCode) {
            case NSStreamEventOpenCompleted: {
                break;
            }
                
            case NSStreamEventErrorOccurred: {
                break;
            }
                
            case NSStreamEventEndEncountered: {
                break;
            }
                
            case NSStreamEventHasBytesAvailable: {
                break;
            }
                
            case NSStreamEventHasSpaceAvailable: {
                break;
            }
                
            default:
                break;
        }
    });
}

@end