//
//  JSONRPCLog.h
//  TTNetworking
//
//  Created by liang on 8/15/14.
//  Copyright (c) 2014 liang. All rights reserved.
//

#define  JSONRPCLOG 4
#ifdef JSONRPCLOG

#define JSONRPCLog(l, s) NSLog(@"JSONRPC:%@(%s/%d)%s%@", l, __FILE__, __LINE__, __func__, (s))

#if JSONRPCLOG == 4
#define JSONRPCLogV(f, s...) JSONRPCLog(@"LOGV:", ([NSString stringWithFormat:f, ##s]))
#define JSONRPCLogD(f, s...) JSONRPCLog(@"LOGD:", ([NSString stringWithFormat:f, ##s]))
#define JSONRPCLogE(f, s...) JSONRPCLog(@"LOGE:", ([NSString stringWithFormat:f, ##s]))
#define JSONRPCLogW(f, s...) JSONRPCLog(@"LOGW:", ([NSString stringWithFormat:f, ##s]))
#endif

#if JSONRPCLOG == 3
#define JSONRPCLogV(f, s...)
#define JSONRPCLogD(f, s...) JSONRPCLog(@"LOGD:", ([NSString stringWithFormat:f, ##s]))
#define JSONRPCLogE(f, s...) JSONRPCLog(@"LOGE:", ([NSString stringWithFormat:f, ##s]))
#define JSONRPCLogW(f, s...) JSONRPCLog(@"LOGW:", ([NSString stringWithFormat:f, ##s]))
#endif

#if JSONRPCLOG == 2
#define JSONRPCLogV(f, s...)
#define JSONRPCLogD(f, s...)
#define JSONRPCLogE(f, s...) JSONRPCLog(@"LOGE:", ([NSString stringWithFormat:f, ##s]))
#define JSONRPCLogW(f, s...) JSONRPCLog(@"LOGW:", ([NSString stringWithFormat:f, ##s]))
#endif

#if JSONRPCLOG == 1
#define JSONRPCLogV(f, s...)
#define JSONRPCLogD(f, s...)
#define JSONRPCLogE(f, s...)
#define JSONRPCLogW(f, s...) JSONRPCLog(@"LOGW:", ([NSString stringWithFormat:f, ##s]))
#endif

#if JSONRPCLOG == 0
#define JSONRPCLogV(f, s...)
#define JSONRPCLogD(f, s...)
#define JSONRPCLogE(f, s...)
#define JSONRPCLogW(f, s...)
#endif

#endif
