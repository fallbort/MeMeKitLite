//
//  JailbrokenDevice.h
//  MeMe
//
//  Created by Mingde on 2018/4/27.
//  Copyright © 2018 sip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JailbrokenDevice : NSObject

+ (BOOL)isJailbroken;

+ (int)simCardNum;
+ (BOOL)hasSimCardInCountryCode:(NSString*)countryCode;
+ (BOOL)hasIndiaSimCard;

@end
