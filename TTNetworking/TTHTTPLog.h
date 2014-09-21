//
//  TTHTTPLog.h
//
//
//  Created by liang on 8/15/14.
//  Copyright (c) 2014 liang. All rights reserved.
//

#define  TTHTTPLOG 4
#ifdef TTHTTPLOG

#define TTHTTPLog(l, s) NSLog(@"TTHTTP:%@(%s/%d)%s%@", l, __FILE__, __LINE__, __func__, (s))

#if TTHTTPLOG == 4
#define TTHTTPLogV(f, s...) TTHTTPLog(@"LOGV:", ([NSString stringWithFormat:f, ##s]))
#define TTHTTPLogD(f, s...) TTHTTPLog(@"LOGD:", ([NSString stringWithFormat:f, ##s]))
#define TTHTTPLogE(f, s...) TTHTTPLog(@"LOGE:", ([NSString stringWithFormat:f, ##s]))
#define TTHTTPLogW(f, s...) TTHTTPLog(@"LOGW:", ([NSString stringWithFormat:f, ##s]))
#endif

#if TTHTTPLOG == 3
#define TTHTTPLogV(f, s...)
#define TTHTTPLogD(f, s...) TTHTTPLog(@"LOGD:", ([NSString stringWithFormat:f, ##s]))
#define TTHTTPLogE(f, s...) TTHTTPLog(@"LOGE:", ([NSString stringWithFormat:f, ##s]))
#define TTHTTPLogW(f, s...) TTHTTPLog(@"LOGW:", ([NSString stringWithFormat:f, ##s]))
#endif

#if TTHTTPLOG == 2
#define TTHTTPLogV(f, s...) 
#define TTHTTPLogD(f, s...)
#define TTHTTPLogE(f, s...) TTHTTPLog(@"LOGE:", ([NSString stringWithFormat:f, ##s]))
#define TTHTTPLogW(f, s...) TTHTTPLog(@"LOGW:", ([NSString stringWithFormat:f, ##s]))
#endif

#if TTHTTPLOG == 1
#define TTHTTPLogV(f, s...) 
#define TTHTTPLogD(f, s...) 
#define TTHTTPLogE(f, s...)
#define TTHTTPLogW(f, s...) TTHTTPLog(@"LOGW:", ([NSString stringWithFormat:f, ##s]))
#endif

#if TTHTTPLOG == 0
#define TTHTTPLogV(f, s...) 
#define TTHTTPLogD(f, s...) 
#define TTHTTPLogE(f, s...) 
#define TTHTTPLogW(f, s...)
#endif

#endif
