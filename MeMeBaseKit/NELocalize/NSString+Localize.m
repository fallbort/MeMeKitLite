//
//  NSString+Localize.m
//  Sample
//
//  Created by Mingde on 2018/10/18.
//  Copyright © 2018 Roy Marmelstein. All rights reserved.
//

#import "NSString+Localize.h"
#import "NELocalize.h"

@implementation NSString (Localize)

- (NSString *)localizedWithMainBundle {
    return [self localized:nil inBundle:[NSBundle mainBundle]];
}

- (NSString *)localizedWithTableName:(NSString *)usingTableName {
    return [self localized:usingTableName inBundle:nil];
}

- (NSString *)localizedWithBundle:(NSBundle *)bundle {
    return [self localized:nil inBundle:bundle];
}

- (NSString *)localized:(NSString *)usingTableName inBundle:(NSBundle *)bundle {
    return [self localized:usingTableName inBundle:bundle value:nil];
}

- (NSString *)localized:(NSString *)usingTableName inBundle:(NSBundle *)bundle value:(NSString *)value
{
    NSBundle *inBundle = nil;
    
    if (bundle) {
        inBundle = bundle;
    } else {
        inBundle = [NSBundle mainBundle];
    }
    
    if (usingTableName.length == 0) {
        usingTableName = @"";
    }
    
    // 当前语言-"lproj文件"
    NSString *currentBundlePath = [inBundle pathForResource:[NELocalize currentSettingLanguage] ofType:@"lproj"];
    if (currentBundlePath.length > 0) {
        NSBundle *CacheCurrentBundle = [NSBundle bundleWithPath:currentBundlePath];
        NSString* ret = [CacheCurrentBundle localizedStringForKey:self value:value table:usingTableName];
        return ret;
    }
    
    // base语言-"lproj文件"
    NSString *baseBundlePath = [inBundle pathForResource:NEBaseBundle ofType:@"lproj"];
    if (baseBundlePath.length > 0) {
        NSBundle *CacheBaseBundle = [NSBundle bundleWithPath:baseBundlePath];
        return [CacheBaseBundle localizedStringForKey:self value:value table:usingTableName];
    }
    
    return self;
}


@end
