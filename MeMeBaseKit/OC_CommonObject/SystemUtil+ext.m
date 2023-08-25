//
//  SystemUtil.m
//  MeMe
//
//  Created by fabo on 2020/6/19.
//  Copyright © 2020 sip. All rights reserved.
//

#import "SystemUtil+ext.h"
//系统库
#include <CoreTelephony/CTTelephonyNetworkInfo.h> //添加获取客户端运营商 支持
#include <CoreTelephony/CTCarrier.h>

#if __has_include(<MeMeKit-Swift.h>)
#import <MeMeKit-Swift.h>
#else
#import <MeMeKit/MeMeKit-Swift.h>
#endif

@implementation SystemUtil (countrycode)

+ (NSString *)currentSystemCountryCode {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    
    ///1.先读手机SIM卡。ISO国际码
    NSString *countryCode = carrier.isoCountryCode;
    if (countryCode == nil || countryCode.length == 0 || ![[NSLocale ISOCountryCodes] containsObject:countryCode]) {
        ///2.其次读取当前系统设置的。
        NSLocale *currentLocale = [NSLocale currentLocale];
        countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    }
    
    ///3.如果是非法国家码（ISOCountryCodes中不存在），默认上报台湾地区。
    if (countryCode.length == 0 || ![[NSLocale ISOCountryCodes] containsObject:countryCode]) {
        countryCode = [LanguageService findCountryByLanguageCode];
    }
    countryCode = [countryCode uppercaseString];
    NSLog(@"System Country Code is %@", countryCode);
    return countryCode;
}


@end
