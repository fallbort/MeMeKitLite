//
//  JailbrokenDevice.m
//  MeMe
//
//  Created by Mingde on 2018/4/27.
//  Copyright © 2018 sip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JailbrokenDevice.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#define ARRAY_SIZE(a) sizeof(a)/sizeof(a[0])

#define USER_APP_PATH                 @"/User/Applications/"

const char *jailbreak_tool_pathes[] = {
    "/Applications/Cydia.app",
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/etc/apt"
};

char *printEnv(void) {
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    return env;
}

@implementation JailbrokenDevice

+ (BOOL)isJailbroken {
    __block BOOL result = NO;
    for (int i = 0; i < ARRAY_SIZE(jailbreak_tool_pathes); i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_tool_pathes[i]]]) {
            //NSLog(@"The device is jail broken!");
            result = YES;
        }
    }
    
    if ([NSThread isMainThread]) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
            //NSLog(@"The device is jail broken!");
            result = YES;
        }
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
                //NSLog(@"The device is jail broken!");
                result = YES;
            }
        });
        
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:USER_APP_PATH]) {
        //NSLog(@"The device is jail broken!");
        NSArray *applist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:USER_APP_PATH error:nil];
        result = YES;
    }
    
    if (printEnv()) {
        //NSLog(@"The device is jail broken!");
        result = YES;
    }
    
    //NSLog(@"The device is NOT jail broken!");
    return result;
    
}


+ (int)simCardNum {
     CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
     if (@available(iOS 12.0, *)) {
          NSDictionary *ctDict = networkInfo.serviceSubscriberCellularProviders;
          if ([ctDict allKeys].count > 1) {
               NSArray *keys = [ctDict allKeys];
               CTCarrier *carrier1 = [ctDict objectForKey:[keys firstObject]];
               CTCarrier *carrier2 = [ctDict objectForKey:[keys lastObject]];
               if (carrier1.mobileCountryCode.length && carrier2.mobileCountryCode.length) {
                    return 2;
               }else if (!carrier1.mobileCountryCode.length && !carrier2.mobileCountryCode.length) {
                    return 0;
               }else {
                    return 1;
               }
          }else if ([ctDict allKeys].count == 1) {
               NSArray *keys = [ctDict allKeys];
               CTCarrier *carrier1 = [ctDict objectForKey:[keys firstObject]];
               if (carrier1.mobileCountryCode.length) {
                    return 1;
               }else {
                    return 0;
               }
          }else {
               return 0;
          }
     }else {
          CTCarrier *carrier = [networkInfo subscriberCellularProvider];
          NSString *carrier_name = carrier.mobileCountryCode;
          if (carrier_name.length) {
               return 1;
          }else {
               return 0;
          }
     }
}

+ (BOOL)hasIndiaSimCard {
    return [self hasSimCardInCountryCode:@"in"];
}

+ (BOOL)hasSimCardInCountryCode:(NSString*)countryCode {
    if (countryCode != nil && countryCode.length > 0) {
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        if (@available(iOS 12.0, *)) {
             NSDictionary *ctDict = networkInfo.serviceSubscriberCellularProviders;
             if ([ctDict allKeys].count > 1) {
                  NSArray *keys = [ctDict allKeys];
                  CTCarrier *carrier1 = [ctDict objectForKey:[keys firstObject]];
                  CTCarrier *carrier2 = [ctDict objectForKey:[keys lastObject]];
                  NSString *carrier_name1 = carrier1.isoCountryCode;
                  carrier_name1 = [carrier_name1 lowercaseString];
                  NSString *carrier_name2 = carrier2.isoCountryCode;
                  carrier_name2 = [carrier_name2 lowercaseString];
                  if (carrier_name1.length && [carrier_name1 isEqualToString:countryCode] == YES) {
                       return YES;
                  }else if (carrier_name2.length && [carrier_name2 isEqualToString:countryCode] == YES) {
                       return YES;
                  }
             }else if ([ctDict allKeys].count == 1) {
                  NSArray *keys = [ctDict allKeys];
                  CTCarrier *carrier1 = [ctDict objectForKey:[keys firstObject]];
                  NSString *carrier_name1 = carrier1.isoCountryCode;
                  carrier_name1 = [carrier_name1 lowercaseString];
                  if (carrier_name1.length && [carrier_name1 isEqualToString:countryCode] == YES) {
                       return YES;
                  }
             }
        }else {
             CTCarrier *carrier = [networkInfo subscriberCellularProvider];
             NSString *carrier_name = carrier.isoCountryCode;
             carrier_name = [carrier_name lowercaseString];
             if (carrier_name.length && [carrier_name isEqualToString:countryCode] == YES) {
                  return YES;
             }
        }
    }
    return NO;
}

@end
