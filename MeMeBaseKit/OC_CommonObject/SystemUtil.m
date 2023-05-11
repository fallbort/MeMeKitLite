//
//  DeviceInfoUtil.m
//  MeMe
//
//  Created by FengMengtao on 2017/2/17.
//  Copyright © 2017年 sip. All rights reserved.
//

#import "SystemUtil.h"

//系统库
#include <CoreTelephony/CTTelephonyNetworkInfo.h> //添加获取客户端运营商 支持
#include <CoreTelephony/CTCarrier.h>
#include <mach/mach.h> // 内存
#include <SystemConfiguration/SystemConfiguration.h>
#include <sys/sysctl.h>
#include <netinet/in.h>
#include <resolv.h>
#include <dns.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <dlfcn.h>

@interface SystemUtil ()
@property(atomic,assign) float oldCpuUsage;
@property(atomic,assign) CFAbsoluteTime oldCpuUsageTime;

@property(atomic,assign) float oldUsedMemory;
@property(atomic,assign) CFAbsoluteTime oldUsedMemoryTime;



+ (instancetype)sharedInstance;
@end

@implementation SystemUtil

+ (instancetype)sharedInstance {
    static SystemUtil *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [SystemUtil new];
        sharedInstance.oldCpuUsage = 0;
        sharedInstance.oldCpuUsageTime = 0;
        sharedInstance.oldUsedMemory = 0;
        sharedInstance.oldUsedMemoryTime = 0;
    });
    return sharedInstance;
}

#pragma mark - CPU

+ (float)cpuUsage {
    CFAbsoluteTime curTime = CFAbsoluteTimeGetCurrent();
    if (SystemUtil.sharedInstance.oldCpuUsage > 0 && curTime - SystemUtil.sharedInstance.oldCpuUsageTime < 0.5) {
        return SystemUtil.sharedInstance.oldCpuUsage;
    }
    
    kern_return_t kern;
    
    thread_array_t threadList;
    mach_msg_type_number_t threadCount;
    
    thread_info_data_t threadInfo;
    mach_msg_type_number_t threadInfoCount;
    
    thread_basic_info_t threadBasicInfo;
    uint32_t threadStatistic = 0;
    
    kern = task_threads(mach_task_self(), &threadList, &threadCount);
    if (kern != KERN_SUCCESS) {
        return -1;
    }
    if (threadCount > 0) {
        threadStatistic += threadCount;
    }
    
    float totalUsageOfCPU = 0;
    
    for (int i = 0; i < threadCount; i++) {
        threadInfoCount = THREAD_INFO_MAX;
        kern = thread_info(threadList[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount);
        if (kern != KERN_SUCCESS) {
            return -1;
        }
        
        threadBasicInfo = (thread_basic_info_t)threadInfo;
        
        if (!(threadBasicInfo -> flags & TH_FLAGS_IDLE)) {
            totalUsageOfCPU = totalUsageOfCPU + threadBasicInfo -> cpu_usage / (float)TH_USAGE_SCALE * 100.0f;
        }
    }
    
    kern = vm_deallocate(mach_task_self(), (vm_offset_t)threadList, threadCount * sizeof(thread_t));
    
    if (totalUsageOfCPU > 0) {
        SystemUtil.sharedInstance.oldCpuUsage = totalUsageOfCPU;
        SystemUtil.sharedInstance.oldCpuUsageTime = curTime;
    }

    return totalUsageOfCPU;
}

#pragma mark - memory

+ (float)memoryUsage {
    return (float) [SystemUtil usedMemory] / (float) [NSProcessInfo processInfo].physicalMemory;
}

+ (uint64_t)usedMemory {
    CFAbsoluteTime curTime = CFAbsoluteTimeGetCurrent();
    if (SystemUtil.sharedInstance.oldUsedMemory > 0 && curTime - SystemUtil.sharedInstance.oldUsedMemoryTime < 0.5) {
        return SystemUtil.sharedInstance.oldUsedMemory;
    }
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        NSLog(@"Memory in use (in bytes): %lld", memoryUsageInByte);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kernelReturn));
    }
    if (memoryUsageInByte > 0) {
        SystemUtil.sharedInstance.oldUsedMemory = memoryUsageInByte;
        SystemUtil.sharedInstance.oldUsedMemoryTime = curTime;
    }
    return memoryUsageInByte;
}

+ (uint64_t)freeMemory {
    size_t length = 0;
    int mib[6] = {0};
    
    int pagesize = 0;
    mib[0] = CTL_HW;
    mib[1] = HW_PAGESIZE;
    length = sizeof(pagesize);
    if (sysctl(mib, 2, &pagesize, &length, NULL, 0) < 0) {
        return 0;
    }
    
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    
    vm_statistics_data_t vmstat;
    
    if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmstat, &count) != KERN_SUCCESS) {
        return 0;
    }
    
    int freeMem = vmstat.free_count * pagesize;
    int inactiveMem = vmstat.inactive_count * pagesize;
    return freeMem + inactiveMem;
}

+ (NSString *)carrierName {
    CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc] init];
    return networkStatus.subscriberCellularProvider.carrierName;
}



#pragma mark -- 获取当前流量

+ (uint64_t)netTrafficd {
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) {
        return 0;
    }
    
    uint32_t iBytes = 0, oBytes = 0;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if ((AF_LINK != ifa->ifa_addr->sa_family)
            || (ifa->ifa_data == 0)
            || ((!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))) ) {
            continue;
        }
        
        /* Not a loopback device. */
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
        }
    }
    freeifaddrs(ifa_list);
    NSLog(@"\n[netSpeed-Total]%d, %d", iBytes, oBytes);
    return iBytes + oBytes;
}

+ (NSString *)ipAddress {
    NSString *address = @"";
    struct ifaddrs *interfaces = nil;
    struct ifaddrs *temp_addr = nil;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs( &interfaces );
    if ( success == 0 )
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while ( temp_addr != nil )
        {
            if( temp_addr->ifa_addr->sa_family == AF_INET )
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ( [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"] )
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
            
        } // end while
    } // end if
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

+ (NSTimeInterval)timeIntervalSince1970 {
    struct  timeval    tv;
    struct  timezone   tz;
    gettimeofday(&tv,&tz);
    return (tv.tv_sec + tv.tv_usec/1000000.0);
}

///获取 解析DNSIP地址
+ (NSArray *)getIPAddressWithHostname:(NSString *)hostName {
    const char *hostN= [hostName UTF8String];
    struct hostent* phot;
    
    @try {
        phot = gethostbyname(hostN);
    }
    @catch (NSException *exception) {
        return nil;
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    int j = 0;
    
    while (phot && phot->h_addr_list && phot->h_addr_list[j]) {
        struct in_addr ip_addr;
        memcpy(&ip_addr, phot->h_addr_list[j], 4);
        char ip[20] = {0};
        inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
        
        NSString *strIPAddress = [NSString stringWithUTF8String:ip];
        
        [result addObject:strIPAddress];
        j++;
    }
    
    return [NSArray arrayWithArray:result];
}

///获取 本机DNSIP地址
+ (NSArray *)getLocalDNSIPAddress {
    res_state res = malloc(sizeof(struct __res_state));
    
    int result = res_ninit(res);
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    if ( result == 0 )
    {
        for ( int i = 0; i < res->nscount; i++ )
        {
            NSString *s = [NSString stringWithUTF8String :  inet_ntoa(res->nsaddr_list[i].sin_addr)];
            
            [resultArray addObject:s];
        }
    }
    
    return resultArray;
}

#pragma mark - QNNet Helper

///开始 请求HTTP域名
+ (QNNHttp *)startToRequestHttp:(NSString *)hostname
                        isHttps:(BOOL)isHttps
                         output:(id<QNNOutputDelegate>)output
                     completion:(ULCompletionStringBlock)completion {
    
    NSString *urlString = hostname;
    NSRange range = [urlString rangeOfString:@"://" options:NSCaseInsensitiveSearch];
    BOOL contain = (range.length > 0) ? YES : NO;
    if(!contain) {
        if (isHttps) {
            urlString = [@"http://" stringByAppendingString:urlString];
        }else{
            urlString = [@"https://" stringByAppendingString:urlString];
        }
    }
    
    NSMutableString *appendingString = [[NSMutableString alloc] init];
    
    return [QNNHttp start:urlString
                   output:output
                 complete:^(QNNHttpResult* r)
            {
                [appendingString appendFormat:@"%@ | ",urlString];
                [appendingString appendFormat:@"Code：%ld | ",(long)r.code];
                [appendingString appendFormat:@"Duration：%f | ",r.duration];
                [appendingString appendFormat:@"Headers：%@ | ",r.headers];
                
                NSString *resultStr = [NSString stringWithFormat:@"Http result：%@",appendingString];
                if (completion) {
                    completion(resultStr);
                }
                
                //NSLog(@"Start To Request：%@",appendingString);
            }];
}

///开始路由跟踪
+ (QNNTraceRoute *)startTraceRoute:(NSString *)hostname
                            output:(id<QNNOutputDelegate>)output
                        completion:(ULCompletionStringBlock)completion {
    if (hostname.length == 0) {
        return nil;
    }
    
    return [QNNTraceRoute start:hostname
                         output:output
                       complete:^(QNNTraceRouteResult* r)
            {
                NSString *resultStr = [NSString stringWithFormat:@"%@",r.content];
                if (completion) {
                    completion(resultStr);
                }
                //NSLog(@"Start Trace Route：%@",r.content);
            }];
}

///开始Ping这个域名
+ (NSMutableArray<QNNPing *> *)startToNormalPing:(NSString *)hostname
                                          output:(id<QNNOutputDelegate>)output
                                      completion:(ULCompletionStringBlock)completion {
    if (hostname.length == 0) {
        return nil;
    }
    
    NSArray *IpArray = [[NSArray alloc] initWithObjects:[self getIPAddressWithHostname:hostname][0], nil];
    if (IpArray.count == 0) {
        return nil;
    }
    NSMutableArray *pingsArray = [NSMutableArray new];
    
    for (NSString *ipAddress in IpArray) {
        NSMutableString *appendingString = [[NSMutableString alloc] init];
        
        QNNPing *norPing = [QNNPing start:ipAddress
                                     size:64
                                   output:output
                                 complete:^(QNNPingResult * r)
                            {
                                [appendingString appendFormat:@"%@ | ",ipAddress];
                                [appendingString appendFormat:@"MaxRtt：%f | ",r.maxRtt];
                                [appendingString appendFormat:@"MinRtt：%f | ",r.minRtt];
                                [appendingString appendFormat:@"AvgRtt：%f | ",r.avgRtt];
                                [appendingString appendFormat:@"Loss：%ld  | ",(long)r.loss];
                                [appendingString appendFormat:@"Count：%ld | ",(long)r.count];
                                [appendingString appendFormat:@"TotalTime：%f | ",r.totalTime];
                                [appendingString appendFormat:@"Stddev：%f | ",r.stddev];
                                [appendingString appendFormat:@"Description：%@",[r description]];
                                NSString *resultStr = [NSString stringWithFormat:@"Normal ping result：%@",appendingString];
                                if (completion) {
                                    completion(resultStr);
                                }
                                
                                //NSLog(@"Start To Normal Ping：%@",appendingString);
                            }
                                 interval:200
                                    count:5];
        
        [pingsArray addObject:norPing];
    }
    
    return pingsArray;
}

///开始TCP Ping这个域名
+ (NSMutableArray<QNNTcpPing *> *)startToTcpPing:(NSString *)hostname
                                         isHttps:(BOOL)isHttps
                                          output:(id<QNNOutputDelegate>)output
                                      completion:(ULCompletionStringBlock)completion {
    if (hostname.length == 0) {
        return nil;
    }
    
    NSArray *IpArray = [[NSArray alloc] initWithObjects:[self getIPAddressWithHostname:hostname][0], nil];
    if (IpArray.count == 0) {
        return nil;
    }
    
    int port = 80;
    if (isHttps) {
        port = 443;
    }
    NSMutableArray *pingsArray = [NSMutableArray new];
    
    for (NSString *ipAddress in IpArray) {
        NSMutableString *appendingString = [[NSMutableString alloc] init];
        
        QNNTcpPing *tcpPing = [QNNTcpPing start:ipAddress
                                           port:port
                                          count:5
                                         output:output
                                       complete:^(QNNTcpPingResult* r)
                               {
                                   [appendingString appendFormat:@"%@ | ",ipAddress];
                                   [appendingString appendFormat:@"MaxTime：%f | ",r.maxTime];
                                   [appendingString appendFormat:@"MinTime：%f | ",r.minTime];
                                   [appendingString appendFormat:@"AvgTime：%f | ",r.avgTime];
                                   [appendingString appendFormat:@"Loss：%ld  | ",(long)r.loss];
                                   [appendingString appendFormat:@"Count：%ld | ",(long)r.count];
                                   [appendingString appendFormat:@"TotalTime：%f | ",r.totalTime];
                                   [appendingString appendFormat:@"Stddev：%f",r.stddev];
                                   [appendingString appendFormat:@"Description：%@",[r description]];
                                   
                                   NSString *resultStr = [NSString stringWithFormat:@"Tcp ping result：%@",appendingString];
                                   if (completion) {
                                       completion(resultStr);
                                   }
                                   
                                   //NSLog(@"Start To TCP Ping：%@",appendingString);
                               }];
        
        [pingsArray addObject:tcpPing];
    }
    
    return pingsArray;
}

+ (CGSize)getTextSize:(NSString *)str font:(UIFont *)font constrainedSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return NETextSize(str, font, constrainedSize, lineBreakMode);
}

+ (CGSize)ceilForSize:(CGSize)value {
    return CGSizeMake(ceilf(value.width), ceilf(value.height));
}


static inline CGSize NETextSize(NSString *text,
                                UIFont *font,
                                CGSize constrainedSize,
                                NSLineBreakMode lineBreakMode)
{
    if (!text) {
        return CGSizeZero;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{
                                 NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName: paragraphStyle,
                                 };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    CGSize size = [SystemUtil ceilForSize:[attributedString boundingRectWithSize:constrainedSize
                                                                               options:(NSStringDrawingUsesDeviceMetrics |
                                                                                        NSStringDrawingUsesLineFragmentOrigin |
                                                                                        NSStringDrawingUsesFontLeading)
                                                                               context:NULL].size];
    return [SystemUtil ceilForSize:size];
}


+ (CGSize)getAttributedTextSize:(NSAttributedString *)attrString constrainedSize:(CGSize)constrainedSize {
    return NEAttributedTextSize(attrString, constrainedSize);
}

static inline CGSize NEAttributedTextSize(NSAttributedString *attrString, CGSize constrainedSize) {
    if (!attrString) {
        return CGSizeZero;
    }
    
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithAttributedString:attrString];
    CGSize size = [SystemUtil ceilForSize:[attributedString boundingRectWithSize:constrainedSize
                                                                         options:(NSStringDrawingUsesDeviceMetrics |
                                                                                  NSStringDrawingUsesLineFragmentOrigin |
                                                                                  NSStringDrawingUsesFontLeading)
                                                                         context:NULL].size];
    return [SystemUtil ceilForSize:size];
}

+ (UIStatusBarStyle) StatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

@end
