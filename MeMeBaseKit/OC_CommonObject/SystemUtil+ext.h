//
//  SystemUtil.h
//  MeMe
//
//  Created by fabo on 2020/6/19.
//  Copyright © 2020 sip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MeMeKit/SystemUtil.h>

NS_ASSUME_NONNULL_BEGIN

@interface SystemUtil (countrycode)
///获取当前系统的国家码
+ (NSString *)currentSystemCountryCode;
@end

NS_ASSUME_NONNULL_END
