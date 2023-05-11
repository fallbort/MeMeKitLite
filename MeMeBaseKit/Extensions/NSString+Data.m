//
//  NSString+Data.m
//  MeMe
//
//  Created by admin on 2019/11/19.
//  Copyright © 2019 sip. All rights reserved.
//

#import "NSString+Data.h"

@implementation NSString (DataCreash)

+ (instancetype)getStringFromNoCrashData:(NSData *)data encoding:(NSStringEncoding)encoding {
    if (nil == data || [data isKindOfClass:[NSNull class]] || data.length <= 0) {
        // 如果data为nil或者为NSNullclass就认为是无效数据
        return nil;
    }
    @try {
        NSString* str = [[self alloc] initWithData:data encoding:encoding];
        return str;
    }
    @catch (NSException *exception) {
        return nil;
    }
    
}

@end
