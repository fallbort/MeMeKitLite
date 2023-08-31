//
//  UIView+ext.m
//  MeMeKit
//
//  Created by xfb on 2023/8/21.
//

#import "UIView+ext.h"
#import <objc/runtime.h>
#if __has_include(<MeMeKit-Swift.h>)
#import <MeMeKit-Swift.h>
#else
#import <MeMeKit/MeMeKit-Swift.h>
#endif

@implementation UIView (translate)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(hitTest:withEvent:) toSelector:@selector(translate_hitTest:withEvent:)];
    });
}

+ (void)swizzleSelector:(SEL)originalSelector toSelector:(SEL)swizzledSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

-(UIView*)translate_hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.hasTranslateHitGesture == YES) {
        UIView* view = [self translate_hitTest:point withEvent:event];
        if (view == self) {
            return nil;
        }else{
            if (self.isHidden == NO && self.alpha > 0.01 && self.isUserInteractionEnabled == YES) {
                NSArray* subs = self.subviews;
                for (UIView* oneView in subs.reverseObjectEnumerator) {
                    if (oneView.isHidden == NO && oneView.alpha > 0.01 && oneView.isUserInteractionEnabled == YES) {
                        CGPoint subPoint = [oneView convertPoint:point fromView:self];
                        if ([oneView pointInside:subPoint withEvent:event]) {
                            UIView* testView = [oneView hitTest:subPoint withEvent:event];
                            if (testView != nil) {
                                return testView;
                            }
                        }else if ([oneView isKindOfClass:[TranslateHitView class]] || oneView.hasTranslateHitGesture == YES) {
                            UIView* testView = [oneView hitTest:subPoint withEvent:event];
                            if (testView != nil) {
                                return testView;
                            }
                        }
                    }
                }
            }
        }
        return view;
    }else{
        return [self translate_hitTest:point withEvent:event];
    }
}

- (void)setHasTranslateHitGesture:(BOOL)hasTranslateHitGesture
{
    objc_setAssociatedObject(self, @selector(hasTranslateHitGesture), @(hasTranslateHitGesture), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)hasTranslateHitGesture
{
    NSNumber* number = objc_getAssociatedObject(self, @selector(hasTranslateHitGesture));
    return number != nil ? [number boolValue] : NO;
}

+ (UIView *)getMuteCaptureView{
    UITextField *bgTextField = [[UITextField alloc] init];
    [bgTextField setSecureTextEntry:true];
    
    UIView *bgView = bgTextField.subviews.firstObject;
    [bgView setUserInteractionEnabled:true];
    return bgView;
}

@end
