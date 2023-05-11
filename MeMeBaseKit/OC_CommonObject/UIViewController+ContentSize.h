//
//  UIViewController+ContentSize.h
//  xfb
//
//  Created by Kevin Lin on 13/9/15.
//  Copyright (c) 2015 Sth4Me. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CloseViewBlock)(BOOL animate);

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ContentSize)

/**
 Content size of popup in portrait orientation.
 */
@property (nonatomic, assign) IBInspectable CGSize contentSizeInPopup;

/**
 Content size of popup in landscape orientation.
 */
@property (nonatomic, assign) IBInspectable CGSize landscapeContentSizeInPopup;


@property (nonatomic, copy) CloseViewBlock meme_closeBlock;


@end

NS_ASSUME_NONNULL_END
