//
//  UINavigationBar+IXTouch.h
//  z1j
//
//  Created by xfb on 2019/6/21.
//  Copyright © 2019 xfb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (IXTouch)
//自定义导航条下的左右按钮，使之可以从左0位置开始布局,配套使用
+ (void)ix_registerCustomTouchViewClass:(Class)viewClass;

@end

NS_ASSUME_NONNULL_END
