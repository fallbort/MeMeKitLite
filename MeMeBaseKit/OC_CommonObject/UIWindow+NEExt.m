//
//  UIWindow+NEExt.m
//  MeMe
//
//  Created by Chang Liu on 11/23/17.
//  Copyright © 2017 sip. All rights reserved.
//

#import "UIWindow+NEExt.h"

@implementation UIWindow (NEExt)
//- (UIEdgeInsets)safeAreaInsets {
//    if (@available(iOS 11.0, *)) {
//        UIWindow *window = UIApplication.sharedApplication.keyWindow;
//        return window.safeAreaInsets;
//    } else {
//        return UIEdgeInsetsZero;
//    }
//}

+ (UIEdgeInsets)keyWindowSafeAreaInsets {
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        if (!window && UIApplication.sharedApplication.windows.count) {
            window = UIApplication.sharedApplication.windows[0];
        }
        return window.safeAreaInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}

+ (UIEdgeInsets)safeAreaInsetsiOS11 {
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        if (!window && UIApplication.sharedApplication.windows.count) {
            window = UIApplication.sharedApplication.windows[0];
        }
        
        UIEdgeInsets insets = window.safeAreaInsets;
        if (@available(iOS 12.0, *)) {
            insets.top = insets.top - 20;
            return insets;
        }
        
        return insets;
    } else {
        return UIEdgeInsetsZero;
    }
}

@end
