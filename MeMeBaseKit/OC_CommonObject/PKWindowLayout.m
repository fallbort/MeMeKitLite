//
//  PKWindowLayout.m
//  iRoom
//
//  Created by kim on 2017/9/26.
//  Copyright © 2017年 Powerinfo. All rights reserved.
//

#import "PKWindowLayout.h"
#import "UIWindow+NEExt.h"

@implementation PKWindowLayout

+ (CGRect)leftWindowBaseFrame {
    CGRect screenBounds = UIScreen.mainScreen.bounds;
    if (screenBounds.size.height / screenBounds.size.width > 640.0 / 360.0){
        return CGRectMake(0, (int)PKWindowSpaceTop, (int)PKSingleWindowWidth, (int)PKSingleWindowHeight);
    }else{
        CGFloat extraHeight = (640.0 * screenBounds.size.width / 360.0 - screenBounds.size.height) / 2.0;
        CGFloat top = 130.0 * screenBounds.size.width / 360.0 - extraHeight;
        CGFloat height = PKSingleWindowWidth * 250.0 / 187.0;
        return CGRectMake(0, (int)top, (int)PKSingleWindowWidth, height);
    }
}

+ (CGRect)leftWindowBaseFrameNew {
    CGRect screenBounds = UIScreen.mainScreen.bounds;
    if (screenBounds.size.height / screenBounds.size.width > 640.0 / 360.0){
        return CGRectMake(0, (int)PKWindowSpaceTopNew, (int)PKSingleWindowWidth, (int)PKSingleWindowHeight);
    }else{
        CGFloat extraHeight = (640.0 * screenBounds.size.width / 360.0 - screenBounds.size.height) / 2.0;
        CGFloat top = 100.0 * screenBounds.size.width / 360.0 - extraHeight;
        CGFloat height = PKSingleWindowWidth * 250.0 / 187.0;
        return CGRectMake(0, (int)top, (int)PKSingleWindowWidth, height);
    }
}

+ (CGRect)leftWindowBeautyFrame {
    CGRect screenBounds = UIScreen.mainScreen.bounds;
    if (screenBounds.size.height / screenBounds.size.width > 640.0 / 360.0) {
        return CGRectMake(0, 0, (int)PKSingleWindowWidth, (int)PKSingleWindowHeight);
    }else{
        CGFloat height = PKSingleWindowWidth * 250.0 / 187.0;
        return CGRectMake(0, 0, (int)PKSingleWindowWidth, (int)height);
    }
}

+ (CGRect)fullScreenFrame {
    return CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
}

@end

