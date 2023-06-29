//
//  NSString+Data.h
//  MeMe
//
//  Created by admin on 2019/11/19.
//  Copyright © 2019 sip. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (DataCreash)

+ (instancetype)getStringFromNoCrashData:(NSData *)data encoding:(NSStringEncoding)encoding;

@end


@interface NSString (Locale)
-(NSComparisonResult)compare:(NSString *)string locale:(NSLocale*)locale;

@end

@interface NSString (data)
-(NSString*)urlEncode;

@end

@interface NSString (number)
-(NSString*)subStringWithContent:(NSString*)content;

@end
