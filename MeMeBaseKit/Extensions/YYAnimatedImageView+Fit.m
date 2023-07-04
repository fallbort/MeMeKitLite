//
//  YYAnimatedImageView+Fit.m
//  MeMe
//
//  Created by yue on 2020/11/19.
//  Copyright © 2020 sip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "YYAnimatedImageView.h"

@implementation YYAnimatedImageView (Fit)

- (void)displayLayer:(CALayer *)layer {
    Ivar curFrameName = class_getInstanceVariable([YYAnimatedImageView class], "_curFrame");
    UIImage *currentCurFrame = (UIImage *)object_getIvar(self, curFrameName);
    if (currentCurFrame) {
        layer.contents = (__bridge id)currentCurFrame.CGImage;
    } else {
        if (@available(iOS 14.0, *)) {
            [super displayLayer:layer];
        }
    }
}


@end
