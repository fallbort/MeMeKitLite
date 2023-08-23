//
//  NELocalize.h
//  Sample
//
//  Created by Mingde on 2018/10/18.
//  Copyright © 2018 Roy Marmelstein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Localize.h"

static NSString * _Nonnull const NECurrentLanguageKey = @"NECurrentLanguageKey";
static NSString * _Nonnull const NEDefaultLanguage = @"en";
static NSString * _Nonnull const NEBaseBundle = @"en";
static NSString * _Nonnull const NELanguageChangeNotification = @"NELanguageChangeNotification";


@interface NELocalize : NSObject

// 设置当前语言，覆盖系统设置
+ (BOOL)setCurrentLanguage:(NSString * _Nonnull)language;
// 恢复当前语言，跟随系统设置。
+ (void)resetLanguageToSystemLanguage;

// 所有区，已支持的语言列表。可以设置是否要排除Base包
+ (NSArray * _Nonnull)availableLanguages:(BOOL)excludeBase;
// 印度区，已支持语言列表。
+ (NSArray * _Nonnull)INLanguages;
+ (NSDictionary * _Nonnull)INLanguageDictionary;

// 相应的语言包名
+ (NSString * _Nonnull)displayNameForLanguage:(NSString * _Nonnull)language;
// 系统语言
+ (NSString * _Nonnull)systemDeviceLanguage;
// 设置语言
+ (NSString * _Nonnull)currentSettingLanguage;
// 是否使用了"自定义语言设置"。
+ (BOOL)isUsingCustomSetting;

// 多语言设置接口
+ (NSString * _Nonnull)localizedString:(NSString * _Nonnull)string;

+ (NSString * _Nonnull)localizedString:(NSString * _Nonnull)string
                               comment:(NSString * _Nullable)comment;

+ (NSString * _Nonnull)localizedString:(NSString * _Nonnull)string
                            bundlePath:(NSString * _Nonnull)bundlePath;

+ (NSString * _Nonnull)localizedString:(NSString * _Nonnull)string
                            bundlePath:(NSString * _Nonnull)bundlePath
                               comment:(NSString * _Nullable)comment;

+ (NSString * _Nonnull)localizedString:(NSString * _Nonnull)string
                                 value:(NSString * _Nullable)value
                                 table:(NSString * _Nullable)table
                                 comment:(NSString * _Nullable)comment;

+ (NSString * _Nonnull)localizedString:(NSString * _Nonnull)string
                                bundle:(NSBundle * _Nullable)bundle
                               comment:(NSString * _Nullable)comment;

+ (NSString * _Nonnull)localizedString:(NSString * _Nonnull)string
                                bundle:(NSBundle * _Nullable)bundle
                                 table:(NSString * _Nullable)table
                               comment:(NSString * _Nullable)comment;

+ (NSString * _Nonnull)localizedString:(NSString * _Nonnull)string
                                bundle:(NSBundle * _Nullable)bundle
                                 table:(NSString * _Nullable)table
                               comment:(NSString * _Nullable)comment
                                 value:(NSString * _Nullable)value;
@end
