//
//  UIView+AdjustFrame.m
//
//
//  Created by apple on 14-12-7.
//  Copyright (c) 2014年. All rights reserved.
//

#import "UIView+AdjustFrame.h"

@implementation UIView (AdjustFrame)

- (void)setPm_x:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)pm_x {
    return self.frame.origin.x;
}

- (void)setPm_y:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)pm_y {
    return self.frame.origin.y;
}

- (void)setPm_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)pm_width {
    return self.frame.size.width;
}

- (CGFloat)pm_max_x {
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)pm_max_y {
    return CGRectGetMaxY(self.frame);
}

- (void)setPm_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)pm_height {
    return self.frame.size.height;
}

- (void)setPm_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)pm_size {
    return self.frame.size;
}

- (void)setPm_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)pm_origin {
    return self.frame.origin;
}

- (void)setPm_centerX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)pm_centerX {
    return self.center.x;
}

- (void)setPm_centerY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)pm_centerY {
    return self.center.y;
}

@end
