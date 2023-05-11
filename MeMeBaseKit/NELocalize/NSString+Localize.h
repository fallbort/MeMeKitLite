//
//  NSString+Localize.h
//  Sample
//
//  Created by Mingde on 2018/10/18.
//  Copyright © 2018 Roy Marmelstein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Localize)

- (NSString *)localizedWithMainBundle;

- (NSString *)localizedWithTableName:(NSString *)usingTableName;

- (NSString *)localizedWithBundle:(NSBundle *)bundle;

- (NSString *)localized:(NSString *)usingTableName inBundle:(NSBundle *)bundle;

- (NSString *)localized:(NSString *)usingTableName inBundle:(NSBundle *)bundle value:(NSString *)value;

@end
