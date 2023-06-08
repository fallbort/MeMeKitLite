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

@implementation NSString (Locale)
-(NSComparisonResult)compare:(NSString *)string locale:(NSLocale*)locale {
    NSRange stringRange1 = NSMakeRange(0, self.length);
    return [self compare:string options:0 range:stringRange1 locale:locale];
}
@end
