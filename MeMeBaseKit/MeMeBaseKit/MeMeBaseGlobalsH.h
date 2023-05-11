//
//  MeMeBaseGlobalsH.h
//  Pods
//
//  Created by fabo on 2022/4/12.
//

#ifndef MeMeBaseGlobalsH_h
#define MeMeBaseGlobalsH_h

#import <Foundation/Foundation.h>
#import <YYImage/YYImage.h>
#import <YYWebImage/YYWebImage.h>


// 判断iPhoneX，Xs
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// iPhoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE_Xr2 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1624), [[UIScreen mainScreen] currentMode].size) : NO)

// iPhoneXsMax
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

// iPhone pro max
#define IS_IPHONE_pro_max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1284, 2778), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE_pro ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1170, 2532), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE_mini ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 2340), [[UIScreen mainScreen] currentMode].size) : NO)

// iPhoneX所有系列
#define IS_PhoneXAll (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs_Max || IS_IPHONE_Xr2 || IS_IPHONE_pro_max || IS_IPHONE_pro || IS_IPHONE_mini)


#endif /* MeMeBaseGlobalsH_h */
