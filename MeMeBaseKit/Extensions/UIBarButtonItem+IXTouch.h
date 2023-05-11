//
//  UIBarButtonItem+IXTouch.h
//  z1j
//
//  Created by xfb on 2019/6/21.
//  Copyright © 2019 xfb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (IXTouch)
//自定义导航条下的左右按钮，使之可以从左0位置开始布局
+ (instancetype)leftItemWithButton:(UIButton*)button;
+ (instancetype)rightItemWithButton:(UIButton*)button;
@end

NS_ASSUME_NONNULL_END
