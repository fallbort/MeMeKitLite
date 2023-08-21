//
//  UIScrollView+ext.m
//  MeMeKit
//
//  Created by xfb on 2023/8/21.
//

#import "UIScrollView+ext.h"
#import <objc/runtime.h>
#if __has_include(<MeMeKit-Swift.h>)
#import <MeMeKit-Swift.h>
#else
#import <MeMeKit/MeMeKit-Swift.h>
#endif
//
//@implementation UIScrollView (translate)
//
//+ (void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self swizzleSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:) toSelector:@selector(traslate_gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)];
//        [self swizzleSelector:@selector(gestureRecognizerShouldBegin:) toSelector:@selector(traslate_gestureRecognizerShouldBegin:)];
//    });
//}
//
//+ (void)swizzleSelector:(SEL)originalSelector toSelector:(SEL)swizzledSelector
//{
//    Class class = [self class];
//    
//    Method originalMethod = class_getInstanceMethod(class, originalSelector);
//    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//    method_exchangeImplementations(originalMethod, swizzledMethod);
//}
//
//- (BOOL)traslate_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//   
//    if ([self isKindOfClass:[UIScrollView class]] && self.hasTranslateSwapGesture == YES && [self isPanBackAction:gestureRecognizer]) {
//        return YES;
//    }
//    return [self traslate_gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
//    
//}
//
//- (BOOL)traslate_gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
// 
//    if ([self isKindOfClass:[UIScrollView class]] && self.hasTranslateSwapGesture == YES && [self isPanBackAction:gestureRecognizer]) {
//        return NO;
//    }
//    return [self traslate_gestureRecognizerShouldBegin:gestureRecognizer];
// 
//}
//
///// 判断是否是全屏的返回手势
//- (BOOL)isPanBackAction:(UIGestureRecognizer *)gestureRecognizer {
//    
//    // 是pan手势 && 手势往右拖
//    if (gestureRecognizer == self.panGestureRecognizer) {
//        CGPoint location = [self.panGestureRecognizer locationInView:self.superview];
//        if (location.x < 35) {
//            // 根据速度获取拖动方向
//            CGPoint velocity = [self.panGestureRecognizer velocityInView:self.panGestureRecognizer.view];
//            if(velocity.x>0){
//                return YES;
//            }
//        }
//    }
//    return NO;
//}
//
//- (void)setHasTranslateSwapGesture:(BOOL)hasTranslateSwapGesture
//{
//    objc_setAssociatedObject(self, @selector(hasTranslateSwapGesture), @(hasTranslateSwapGesture), OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
//
//- (BOOL)hasTranslateSwapGesture
//{
//    NSNumber* number = objc_getAssociatedObject(self, @selector(hasTranslateSwapGesture));
//    return number != nil ? [number boolValue] : NO;
//}
//
//@end
