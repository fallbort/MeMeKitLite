//
//  UIBarButtonItem+IXTouch.m
//  z1j
//
//  Created by xfb on 2019/6/21.
//  Copyright © 2019 xfb. All rights reserved.
//

#import "UIBarButtonItem+IXTouch.h"
#import "UINavigationBar+IXTouch.h"
#import "NSObject+JRSwizzle.h"
#import "UIButton+EnlargeTouchArea.h"

@interface IXOutsideTouchView : UIView

@end

@implementation IXOutsideTouchView

// allow touches outside view

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    for(UIView *aSubview in self.subviews) {
        UIView *view = [aSubview hitTest:[self convertPoint:point toView:aSubview] withEvent:event];
        if(view) return view;
    }
    return [super hitTest:point withEvent:event];
}

@end

@implementation UIBarButtonItem (IXTouch)

+ (instancetype)leftItemWithButton:(UIButton*)button {
    
    // 包装 button 的容器 view，这个 view 的位置和大小被限制死了，所以还需要把触摸事件传给 button
    IXOutsideTouchView *containerView = [[IXOutsideTouchView alloc] initWithFrame:CGRectMake(0, 0, button.bounds.size.width, 44)];
    containerView.backgroundColor = [UIColor clearColor];
    CGRect frame = button.frame;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    if (screenWidth > 400) {
        frame.origin.x = frame.origin.x - 20;
    }else{
        frame.origin.x = frame.origin.x - 16;
    }
    button.frame = frame;
    [containerView addSubview:button];

    
    // iOS 11 下的适配，将 UINavigationBar 上的触摸事件传到最上面的自定义控件，防止被系统的 _UINavigationBarContentView 拦截掉
    [UINavigationBar ix_registerCustomTouchViewClass:[IXOutsideTouchView class]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    return item;
}

+ (instancetype)rightItemWithButton:(UIButton*)button {
    
    // 包装 button 的容器 view，这个 view 的位置和大小被限制死了，所以还需要把触摸事件传给 button
    IXOutsideTouchView *containerView = [[IXOutsideTouchView alloc] initWithFrame:CGRectMake(0, 0, button.bounds.size.width, 44)];
    containerView.backgroundColor = [UIColor clearColor];
    CGRect frame = button.frame;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    if (screenWidth > 400) {
        frame.origin.x = frame.origin.x + 20;
    }else{
        frame.origin.x = frame.origin.x + 16;
    }
    button.frame = frame;
    [containerView addSubview:button];
    
    
    // iOS 11 下的适配，将 UINavigationBar 上的触摸事件传到最上面的自定义控件，防止被系统的 _UINavigationBarContentView 拦截掉
    [UINavigationBar ix_registerCustomTouchViewClass:[IXOutsideTouchView class]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    return item;
}


@end
