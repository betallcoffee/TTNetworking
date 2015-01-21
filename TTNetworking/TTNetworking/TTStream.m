//
//  TTStream.m
//  TTNetworking
//
//  Created by liang on 1/20/15.
//  Copyright (c) 2015 liangliang. All rights reserved.
//

#import "TTStream.h"
#import "TTThread.h"

static NSString *const kDomain = @"com.tina.TTStream";

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
    
    ScannerBlock _scanner;
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

- (void)setNextScanner:(ScannerBlock)scanner {
    _scanner = scanner;
}

// Calls block on delegate queue
- (void)performDelegateBlock:(dispatch_block_t)block;
{
    assert(_delegateDispatchQueue);
    dispatch_async(_delegateDispatchQueue, block);
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
    dispatch_async(_workQueue, ^{
        [self _close];
    });
}

- (void)_close {
    [self write];
    if (_status != eStatusInit) {
        [self clean];
        _status = eStatusInit;
        [self performDelegateBlock:^{
            if (self.delegate != nil) {
                [self.delegate onClose];
            }
        }];
    }
}

- (void)failWithError:(NSError *)error {
    [self clean];
    _status = eStatusInit;
    [self performDelegateBlock:^{
        [self.delegate onFailedCode:error.code message:error.localizedFailureReason];
    }];
}

- (void)clean {
    [_outputStream close];
    [_inputStream close];
    [_outputStream removeFromRunLoop:[NSRunLoop runLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream removeFromRunLoop:[NSRunLoop runLoop] forMode:NSDefaultRunLoopMode];
    
}

- (void)scan {
    NSUInteger size = 0;
    if (_scanner) {
        NSData *data = [NSData dataWithBytesNoCopy:(char *)_readBuffer.bytes + _readBufferOffset
                                            length:_readBuffer.length - _readBufferOffset
                                      freeWhenDone:NO];
        size = _scanner(self, data);
    }
    _readBufferOffset += size;
    if (_readBufferOffset > 4096 && _readBufferOffset > (_readBuffer.length >> 1)) {
        _readBuffer = [[NSMutableData alloc] initWithBytes:(char *)_readBuffer.bytes + _readBufferOffset
                                                    length:_readBuffer.length - _readBufferOffset];
        _readBufferOffset = 0;
    }

}

- (void)read{
    const size_t bufferSize = 2048;
    uint8_t buffer[bufferSize];
    
    while (_inputStream.hasBytesAvailable) {
        NSInteger bytesRead = [_inputStream read:buffer maxLength:bufferSize];
        
        if (bytesRead > 0) {
            [_readBuffer appendBytes:buffer length:bytesRead];
        } else if (bytesRead < 0) {
            [self failWithError:_inputStream.streamError];
        }
        
        if (bytesRead != bufferSize) {
            break;
        }
    };
}

- (void)write {
    NSUInteger dataLength = _writeBuffer.length;
    if (dataLength - _writeBufferOffset > 0 && _outputStream.hasSpaceAvailable) {
        NSInteger bytesWritten = [_outputStream write:_writeBuffer.bytes + _writeBufferOffset maxLength:dataLength - _writeBufferOffset];
        if (bytesWritten == -1) {
            [self failWithError:[NSError errorWithDomain:kDomain
                                                     code:2145
                                                 userInfo:[NSDictionary dictionaryWithObject:@"Error writing to stream"
                                                                                      forKey:NSLocalizedDescriptionKey]]];
            return;
        }
        
        _writeBufferOffset += bytesWritten;
        
        if (_writeBufferOffset > 4096 && _writeBufferOffset > (_writeBuffer.length >> 1)) {
            _writeBuffer = [[NSMutableData alloc] initWithBytes:(char *)_writeBuffer.bytes + _writeBufferOffset
                                                         length:_writeBuffer.length - _writeBufferOffset];
            _writeBufferOffset = 0;
        }
    }
}

#pragma mark NSStreamDelegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    dispatch_async(_workQueue, ^{
        switch (eventCode) {
            case NSStreamEventOpenCompleted: {
                if (_status == eStatusConnecting) {
                    _status = eStatusOpen;
                    [self scan];
                }
                break;
            }
                
            case NSStreamEventErrorOccurred: {
                _status = eStatusClosing;
                [self failWithError:aStream.streamError];
                break;
            }
                
            case NSStreamEventEndEncountered: {
                _status = eStatusClosing;
                if (aStream.streamError != nil) {
                    [self failWithError:aStream.streamError];
                } else {
                    [self _close];
                }
                break;
            }
                
            case NSStreamEventHasBytesAvailable: {
                if (_status == eStatusOpen) {
                    [self read];
                    [self scan];
                }
                break;
            }
                
            case NSStreamEventHasSpaceAvailable: {
                if (_status == eStatusOpen) {
                    [self write];
                }
                break;
            }
                
            default:
                break;
        }
    });
}

@end
