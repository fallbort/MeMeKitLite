//
//  UIButton+EnlargeTouchArea.h
//  z1j
//
//  Created by xfb on 2019/6/21.
//  Copyright © 2019 xfb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (EnlargeTouchArea)
//设置有效点击区域
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
//设置有效点击区域四边同步扩大
- (void)setEnlargeEdge:(CGFloat) size;

@end

NS_ASSUME_NONNULL_END
