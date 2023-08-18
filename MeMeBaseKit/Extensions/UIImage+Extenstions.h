//
//  UIImage+Extenstions.h
//  MeMeKit
//
//  Created by xfb on 2023/7/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (scale)
//等比例缩放
- (UIImage*)scaleToSize:(CGSize)size;
//图片压缩到指定大小
+(UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength;

- (UIImage *)mmImageByResizeToSize:(CGSize)size;
- (UIImage *)mmImageByCropToRect:(CGRect)rect;

+(UIImage *)imageNamed:(NSString *)name inBundlePath:(NSString*)path;
@end

NS_ASSUME_NONNULL_END
