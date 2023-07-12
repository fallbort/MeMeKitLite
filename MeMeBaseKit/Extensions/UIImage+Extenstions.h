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
@end

NS_ASSUME_NONNULL_END
