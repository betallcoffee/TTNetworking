//
//  TTLog.h
//
//
//  Created by liang on 8/15/14.
//  Copyright (c) 2014 liang. All rights reserved.
//

#define  TTLOG 4
#ifdef TTLOG

#define TTLog(l, s) NSLog(@"TTLog %@ : %@(%d)%s%@", kLogTag, l, __LINE__, __func__, (s))

#if TTLOG == 4
#define TTLogV(f, s...) TTLog(@"LOGV:", ([NSString stringWithFormat:f, ##s]))
#define TTLogD(f, s...) TTLog(@"LOGD:", ([NSString stringWithFormat:f, ##s]))
#define TTLogE(f, s...) TTLog(@"LOGE:", ([NSString stringWithFormat:f, ##s]))
#define TTLogW(f, s...) TTLog(@"LOGW:", ([NSString stringWithFormat:f, ##s]))
#endif

#if TTLOG == 3
#define TTLogV(f, s...)
#define TTLogD(f, s...) TTLog(@"LOGD:", ([NSString stringWithFormat:f, ##s]))
#define TTLogE(f, s...) TTLog(@"LOGE:", ([NSString stringWithFormat:f, ##s]))
#define TTLogW(f, s...) TTLog(@"LOGW:", ([NSString stringWithFormat:f, ##s]))
#endif

#if TTLOG == 2
#define TTLogV(f, s...) 
#define TTLogD(f, s...)
#define TTLogE(f, s...) TTLog(@"LOGE:", ([NSString stringWithFormat:f, ##s]))
#define TTLogW(f, s...) TTLog(@"LOGW:", ([NSString stringWithFormat:f, ##s]))
#endif

#if TTLOG == 1
#define TTLogV(f, s...) 
#define TTLogD(f, s...) 
#define TTLogE(f, s...)
#define TTLogW(f, s...) TTLog(@"LOGW:", ([NSString stringWithFormat:f, ##s]))
#endif

#if TTLOG == 0
#define TTLogV(f, s...) 
#define TTLogD(f, s...) 
#define TTLogE(f, s...) 
#define TTLogW(f, s...)
#endif

#endif
