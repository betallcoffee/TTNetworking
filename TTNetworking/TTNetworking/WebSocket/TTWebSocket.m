//
//  TTWebSocket.m
//  TTNetworking
//
//  Created by liang on 1/20/15.
//  Copyright (c) 2015 liangliang. All rights reserved.
//

#import "TTWebSocket.h"

typedef enum : NSInteger {
    eCloseCodeNormal = 1000,
    eCloseCodeGoingAway = 1001,
    eCloseCodeProtocolError = 1002,
    eCloseCodeUnhandledType = 1003,
    // 1004 reserved.
    eCloseNoStatusReceived = 1005,
    // 1004-1006 reserved.
    eCloseCodeInvalidUTF8 = 1007,
    eCloseCodePolicyViolated = 1008,
    eCloseCodeMessageTooBig = 1009,
} eCloseCode;

@interface TTWebSocket ()
{
    NSInteger _closeCode;
    NSString *_closeMessage;
}

@end

@implementation TTWebSocket

@end
