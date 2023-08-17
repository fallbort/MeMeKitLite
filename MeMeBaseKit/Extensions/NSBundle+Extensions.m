//
//  NSBundle+Extensions.m
//  MeMeKit
//
//  Created by xfb on 2023/8/17.
//

#import "NSBundle+Extensions.h"

@interface BundleInternel : NSObject

@end

@implementation BundleInternel

@end

@implementation NSBundle (extra)
+(NSBundle* _Nullable)bundleWithPathBundle:(NSString*)path {
    return [self bundleWithPathBundle:path cla:[BundleInternel class]];
}
+(NSBundle* _Nullable)bundleWithPathBundle:(NSString*)path cla:(Class)cla {
    NSBundle *mainBundle = [NSBundle bundleForClass:cla];
    NSBundle *bundle = [NSBundle bundleWithPath:[mainBundle pathForResource:path ofType:@"bundle"]];
    return bundle;
}

@end
