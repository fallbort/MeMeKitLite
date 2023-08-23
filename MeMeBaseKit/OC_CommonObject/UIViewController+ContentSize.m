//
//  UIViewController+ContentSize.m
//  xfb
//
//  Created by Kevin Lin on 13/9/15.
//  Copyright (c) 2015 Sth4Me. All rights reserved.
//

#import "UIViewController+ContentSize.h"
#import <objc/runtime.h>
#if __has_include(<MeMeKit-Swift.h>)
#import <MeMeKit-Swift.h>
#else
#import <MeMeKit/MeMeKit-Swift.h>
#endif

@interface UIViewController (contentSize_internal)
@property (nonatomic, assign) BOOL isViewAppearLoaded;
@end

@implementation UIViewController (contentSize_internal)
- (void)setIsViewAppearLoaded:(BOOL)isViewAppearLoaded
{
    objc_setAssociatedObject(self, @selector(isViewAppearLoaded), @(isViewAppearLoaded), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isViewAppearLoaded
{
    NSNumber* num = objc_getAssociatedObject(self, @selector(isViewAppearLoaded));
    return num != nil ? [num boolValue] : NO;
}


@end

@implementation UIViewController (ContentSize)

@dynamic contentSizeInPopup;
@dynamic landscapeContentSizeInPopup;

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(viewDidLoad) toSelector:@selector(st_viewDidLoad)];
        [self swizzleSelector:@selector(viewDidAppear:) toSelector:@selector(st_viewDidAppear:)];
    });
}

+ (void)swizzleSelector:(SEL)originalSelector toSelector:(SEL)swizzledSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)st_viewDidLoad
{
    CGSize contentSize = CGSizeZero;
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            contentSize = self.landscapeContentSizeInPopup;
            if (CGSizeEqualToSize(contentSize, CGSizeZero)) {
                contentSize = self.contentSizeInPopup;
            }
        }
            break;
        default: {
            contentSize = self.contentSizeInPopup;
        }
            break;
    }
    
    if (!CGSizeEqualToSize(contentSize, CGSizeZero)) {
        self.view.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    }
    [self st_viewDidLoad];
}

-(void)st_viewDidAppear:(BOOL)animated {
    if (self.isViewAppearLoaded == false) {
        self.isViewFirstAppeared = true;
    }else{
        self.isViewFirstAppeared = false;
    }
    if (self.isViewAppearLoaded == false) {
        self.isViewAppearLoaded == true;
    }
    [self st_viewDidAppear:animated];
}

- (void)setContentSizeInPopup:(CGSize)contentSizeInPopup
{
    if (!CGSizeEqualToSize(CGSizeZero, contentSizeInPopup) && contentSizeInPopup.width == 0) {
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight: {
                contentSizeInPopup.width = [UIScreen mainScreen].bounds.size.height;
            }
                break;
            default: {
                contentSizeInPopup.width = [UIScreen mainScreen].bounds.size.width;
            }
                break;
        }
    }
    objc_setAssociatedObject(self, @selector(contentSizeInPopup), [NSValue valueWithCGSize:contentSizeInPopup], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)contentSizeInPopup
{
    return [objc_getAssociatedObject(self, @selector(contentSizeInPopup)) CGSizeValue];
}

- (void)setLandscapeContentSizeInPopup:(CGSize)landscapeContentSizeInPopup
{
    if (!CGSizeEqualToSize(CGSizeZero, landscapeContentSizeInPopup) && landscapeContentSizeInPopup.width == 0) {
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight: {
                landscapeContentSizeInPopup.width = [UIScreen mainScreen].bounds.size.width;
            }
                break;
            default: {
                landscapeContentSizeInPopup.width = [UIScreen mainScreen].bounds.size.height;
            }
                break;
        }
    }
    objc_setAssociatedObject(self, @selector(landscapeContentSizeInPopup), [NSValue valueWithCGSize:landscapeContentSizeInPopup], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)landscapeContentSizeInPopup
{
    return [objc_getAssociatedObject(self, @selector(landscapeContentSizeInPopup)) CGSizeValue];
}

- (void)setMeme_closeBlock:(CloseViewBlock)meme_closeBlock
{
    objc_setAssociatedObject(self, @selector(meme_closeBlock), meme_closeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CloseViewBlock)meme_closeBlock
{
    return objc_getAssociatedObject(self, @selector(meme_closeBlock));
}

- (void)setIsViewFirstAppeared:(BOOL)isViewFirstAppeared
{
    objc_setAssociatedObject(self, @selector(isViewFirstAppeared), @(isViewFirstAppeared), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isViewFirstAppeared
{
    NSNumber* num = objc_getAssociatedObject(self, @selector(isViewFirstAppeared));
    return num != nil ? [num boolValue] : NO;
}


@end

@implementation UIViewController (navbar)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(viewDidLayoutSubviews) toSelector:@selector(st_viewDidLayoutSubviews)];
    });
}

- (void)st_viewDidLayoutSubviews
{
    __block UIView* foundView = nil;
    __block NSInteger foundIndex = NSNotFound;
    
    [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView* oneView = obj;
        if ([oneView isKindOfClass:[MeMeNavigationBar class]] == YES) {
            foundView = oneView;
            foundIndex = idx;
            // stop the enumeration
            *stop = YES;
        }
    }];
    if (foundView != nil && foundIndex != self.view.subviews.count - 1) {
        int i = 0;
        UIView* foundBackView = nil;
        for (UIView* oneView in self.view.subviews.reverseObjectEnumerator) {
            NSInteger index = self.view.subviews.count - 1 - i;
            UIViewController* superController = oneView.superController;
            if ((superController != self && superController.contentSizeInPopup.height > 0) || oneView.isCoverMeMeNavAndTabBar == YES) {
                continue;
            }else{
                foundBackView = oneView;
                break;
            }
            
            i++;
        }
        if (foundBackView != nil) {
            [self.view insertSubview:foundView aboveSubview:foundBackView];
        }else{
            [self.view bringSubviewToFront:foundView];
        }
        
    }
    [self st_viewDidLayoutSubviews];
}

@end
