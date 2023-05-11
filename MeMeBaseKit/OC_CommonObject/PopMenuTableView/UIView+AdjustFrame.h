//
//  UIView+AdjustFrame.h
//
//
//  Created by apple on 14-12-7.
//  Copyright (c) 2014年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AdjustFrame)

@property (nonatomic, assign) CGFloat pm_x;
@property (nonatomic, assign) CGFloat pm_y;
@property (nonatomic, assign) CGFloat pm_max_x;
@property (nonatomic, assign) CGFloat pm_max_y;
@property (nonatomic, assign) CGFloat pm_centerX;
@property (nonatomic, assign) CGFloat pm_centerY;
@property (nonatomic, assign) CGFloat pm_width;
@property (nonatomic, assign) CGFloat pm_height;

@property (nonatomic, assign) CGPoint pm_origin;
@property (nonatomic, assign) CGSize pm_size;

@end
