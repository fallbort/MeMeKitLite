//
//  DeviceInfoUtil.h
//  MeMe
//
//  Created by FengMengtao on 2017/2/17.
//  Copyright © 2017年 sip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QNNetDiag/QNNetDiag.h>

///string
typedef void (^ULCompletionStringBlock)(NSString *resultString);

/************************ObjC宏*************************/
#define M_GT_KB 1024.0
#define M_GT_MB (1024.0 * M_GT_KB)
#define M_GT_GB (1024.0 * M_GT_MB)
/********************************************************/

@interface SystemUtil : NSObject

+ (float)cpuUsage;

+ (float)memoryUsage;

+ (NSString *)carrierName;

+ (uint64_t)usedMemory;

+ (uint64_t)freeMemory;

+ (uint64_t)netTrafficd;

+ (NSString *)ipAddress;

+ (NSTimeInterval)timeIntervalSince1970;

///获取 解析DNSIP地址
+ (NSArray *)getIPAddressWithHostname:(NSString *)hostName;

#pragma mark - QNNet Helper
///开始 请求HTTP域名
+ (QNNHttp *)startToRequestHttp:(NSString *)hostname
                        isHttps:(BOOL)isHttps
                         output:(id<QNNOutputDelegate>)output
                     completion:(ULCompletionStringBlock)completion;
///开始Ping这个域名
+ (NSMutableArray<QNNPing *> *)startToNormalPing:(NSString *)hostname
                                          output:(id<QNNOutputDelegate>)output
                                      completion:(ULCompletionStringBlock)completion;
///开始TCP Ping这个域名
+ (NSMutableArray<QNNTcpPing *> *)startToTcpPing:(NSString *)hostname
                                         isHttps:(BOOL)isHttps
                                          output:(id<QNNOutputDelegate>)output
                                      completion:(ULCompletionStringBlock)completion;
///开始路由跟踪
+ (QNNTraceRoute *)startTraceRoute:(NSString *)hostname
                            output:(id<QNNOutputDelegate>)output
                        completion:(ULCompletionStringBlock)completion;

+ (CGSize)getTextSize:(NSString *)str font:(UIFont *)font constrainedSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode;
+ (CGSize)getAttributedTextSize:(NSAttributedString *)attrString constrainedSize:(CGSize)constrainedSize;
+ (CGSize)ceilForSize:(CGSize)value;

+ (UIStatusBarStyle) StatusBarStyle;
@end
