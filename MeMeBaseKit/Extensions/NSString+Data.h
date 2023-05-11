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

