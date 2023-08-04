//
//  UIButton+Extenstions.m
//  MeMeKit
//
//  Created by xfb on 2023/8/4.
//

#import "UIButton+Extenstions.h"
#import <objc/runtime.h>
#if __has_include(<MeMeKit-Swift.h>)
#import <MeMeKit-Swift.h>
#else
#import <MeMeKit/MeMeKit-Swift.h>
#endif

@implementation UIButton (safe)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(setSelected:) toSelector:@selector(meme_fakeSetSelected:)];
    });
}

+ (void)swizzleSelector:(SEL)originalSelector toSelector:(SEL)swizzledSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)meme_fakeSetSelected:(BOOL)selected
{
    if (self.useFakeSelectMode == false) {
        [self meme_fakeSetSelected:selected];
    }else{
        [self setIsSelectedFake:selected];
    }
    
}

@end
