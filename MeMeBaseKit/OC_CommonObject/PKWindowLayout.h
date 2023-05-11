//
//  PKWindowLayout.h
//  iRoom
//
//  Created by kim on 2017/9/26.
//  Copyright © 2017年 Powerinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

// 拉流尺寸默认368*640
#define PKWindowSpaceTop 130.0 * [UIScreen mainScreen].bounds.size.height / 640.0
#define PKWindowSpaceTopNew 100.0 * [UIScreen mainScreen].bounds.size.height / 640.0
#define PKSingleWindowWidth [UIScreen mainScreen].bounds.size.width / 2
#define PKSingleWindowHeight 250.0 * [UIScreen mainScreen].bounds.size.height / 667.0

#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height


@interface PKWindowLayout : NSObject

+ (CGRect)leftWindowBaseFrame;
+ (CGRect)leftWindowBaseFrameNew;
+ (CGRect)leftWindowBeautyFrame;
+ (CGRect)fullScreenFrame;

@end
