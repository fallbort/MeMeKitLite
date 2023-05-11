//
//  NSObject+JRSwizzle.h
//  z1j
//
//  Created by xfb on 2019/6/21.
//  Copyright © 2019 xfb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (JRSwizzle)
//objc下的魔法互换方法
+ (BOOL)jr_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_;
+ (BOOL)jr_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_;


/**
 ```
 __block NSInvocation *invocation = nil;
 invocation = [self jr_swizzleMethod:@selector(initWithCoder:) withBlock:^(id obj, NSCoder *coder) {
 NSLog(@"before %@, coder %@", obj, coder);
 [invocation setArgument:&coder atIndex:2];
 [invocation invokeWithTarget:obj];
 id ret = nil;
 [invocation getReturnValue:&ret];
 NSLog(@"after %@, coder %@", obj, coder);
 return ret;
 } error:nil];
 ```
 */
+ (NSInvocation*)jr_swizzleMethod:(SEL)origSel withBlock:(id)block error:(NSError**)error;

/**
 ```
 __block NSInvocation *classInvocation = nil;
 classInvocation = [self jr_swizzleClassMethod:@selector(test) withBlock:^() {
 NSLog(@"before");
 [classInvocation invoke];
 NSLog(@"after");
 } error:nil];
 ```
 */
+ (NSInvocation*)jr_swizzleClassMethod:(SEL)origSel withBlock:(id)block error:(NSError**)error;
@end

NS_ASSUME_NONNULL_END
