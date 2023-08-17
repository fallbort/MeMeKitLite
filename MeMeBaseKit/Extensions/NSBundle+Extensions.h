//
//  NSBundle+Extensions.h
//  MeMeKit
//
//  Created by xfb on 2023/8/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (extra)

+(NSBundle* _Nullable)bundleWithPathBundle:(NSString*)path;

+(NSBundle* _Nullable)bundleWithPathBundle:(NSString*)path cla:(Class)cla;

@end

NS_ASSUME_NONNULL_END
