//
//  NELocalize.m
//  Sample
//
//  Created by Mingde on 2018/10/18.
//  Copyright © 2018 Roy Marmelstein. All rights reserved.
//

#import "NELocalize.h"
#import "NSString+Localize.h"
#import "NSBundle+Extensions.h"

@implementation NELocalize

// 获取当前App使用的多语言
+ (NSString * _Nonnull)currentSettingLanguage {
    NSString *returnLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:NECurrentLanguageKey];
    
    if (returnLanguage.length == 0) {
        return [self systemDeviceLanguage];
    }

    return returnLanguage;
}

// 设置当前App使用的多语言
+ (BOOL)setCurrentLanguage:(NSString * _Nonnull)language {
    if (language.length == 0) {
        return NO;
    }
    
    NSArray *languageArray = [self availableLanguages:NO];
    if (languageArray.count == 0 ) {
        return NO;
    }
    
    NSString *selectedLanguage = [self systemDeviceLanguage];
    
    BOOL isContains = [languageArray containsObject:language];
    if (isContains) {
        selectedLanguage = [language copy];
    }
    
    if (![selectedLanguage isEqualToString: [self currentSettingLanguage]]) {
        [[NSUserDefaults standardUserDefaults] setValue:selectedLanguage forKey:NECurrentLanguageKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:NELanguageChangeNotification object:nil];
        return YES;
    }
    
    return NO;
}

// 本地化支持的语言:可以设置是否要排除Base包
+ (NSArray * _Nonnull)availableLanguages:(BOOL)excludeBase {
    NSArray *localizatitons = [[NSBundle mainBundle] localizations];
    NSMutableArray *availableLanguages = [NSMutableArray arrayWithArray:localizatitons];
    
    if (localizatitons == 0) {
        return availableLanguages;
    }
    
    if (excludeBase) {
        NSUInteger indexOfBase = [availableLanguages indexOfObject:@"Base"];
        [availableLanguages removeObjectAtIndex:indexOfBase];
    }
    
    return availableLanguages;
}

+ (NSString * _Nonnull)systemDeviceLanguage {
    NSString *returnLanguage = @"";
    
    NSString *preferredLanguage = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
    if (preferredLanguage.length == 0) {
        return NEDefaultLanguage;
    }
    
    NSArray *availableLanguages = [self availableLanguages:NO];
   
    if ([availableLanguages containsObject:preferredLanguage]) {
        returnLanguage = preferredLanguage;
    } else {
        returnLanguage = NEDefaultLanguage;
    }

    return returnLanguage;
}

// 是否使用了自定义设置。
+ (BOOL)isUsingCustomSetting {
    NSString *returnLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:NECurrentLanguageKey];
    if (returnLanguage.length == 0) {
        return NO;
    }
    
    return YES;
}

// 重置当前App使用的多语言：->默认语言
+ (void)resetLanguageToSystemLanguage {
    [self setCurrentLanguage:[self systemDeviceLanguage]];
}

// 获取当前的语言名称
+ (NSString * _Nonnull)displayNameForLanguage:(NSString * _Nonnull)language {
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:language];
    NSString *displayName = [locale localizedStringForLocaleIdentifier:locale.localeIdentifier];
    
    if (displayName.length == 0) {
        return @"";
    }
    
    return displayName;
}



+ (NSString * _Nonnull)localizedString:(NSString * _Nonnull)string {
    return [self localizedString:string bundle:nil comment:nil];
}

+ (NSString * _Nonnull)localizedString:(NSString * _Nonnull)string
                               comment:(NSString * _Nullable)comment {
    
    return [self localizedString:string bundle:nil comment:comment ];
}

+ (NSString * _Nonnull)localizedString:(NSString * _Nonnull)string
                            bundlePath:(NSString * _Nonnull)bundlePath {
    NSBundle* inBundle = [NSBundle bundleWithPathBundle:bundlePath];
    return [self localizedString:string bundle:inBundle comment:@"" ];
}

+ (NSString * _Nonnull)localizedString:(NSString * _Nonnull)string
                            bundlePath:(NSString * _Nonnull)bundlePath
                               comment:(NSString * _Nullable)comment {
    NSBundle* inBundle = [NSBundle bundleWithPathBundle:bundlePath];
    return [self localizedString:string bundle:inBundle comment:comment ];
}

+ (NSString * _Nonnull)localizedString:(NSString * _Nonnull)string
                                 value:(NSString * _Nullable)value
                                 table:(NSString * _Nullable)table
                                 comment:(NSString * _Nullable)comment {
    
    return [self localizedString:string bundle:nil table:table comment:comment value:value ];
}


+ (NSString * _Nonnull)localizedString:(NSString * _Nonnull)string
                                bundle:(NSBundle * _Nullable)bundle
                               comment:(NSString * _Nullable)comment {
   return [self localizedString:string bundle:bundle table:nil comment:comment];
}

+ (NSString * _Nonnull)localizedString:(NSString * _Nonnull)string
                                bundle:(NSBundle * _Nullable)bundle
                                 table:(NSString * _Nullable)table
                               comment:(NSString * _Nullable)comment {
    return [self localizedString:string bundle:bundle table:table comment:comment value:nil];
}

+ (NSString * _Nonnull)localizedString:(NSString * _Nonnull)string
                                bundle:(NSBundle * _Nullable)bundle
                                 table:(NSString * _Nullable)table
                               comment:(NSString * _Nullable)comment
                                 value:(NSString * _Nullable)value
{
    if (comment == nil) {
        comment = @"";
    }
    
    if (bundle == nil) {
        bundle = [NSBundle mainBundle];
    }
    
    if (table == nil) {
        table = @"";
    }
    
    return [string localized:table inBundle:bundle value:value];
}


@end
