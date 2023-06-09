//
//  MMGIFImageView.h
//  UIImageView-PlayGIF
//
//  Created by Yang Fei on 14-3-26.
//  Copyright (c) 2014年 yangfei.me. All rights reserved.
//

/*******************************************************
 *  Dependencies:
 *      - QuartzCore.framework
 *      - ImageIO.framework
 *  Parameters:
 *      Pass value to one of them:
 *      - gifData NSData from a GIF
 *      - gifPath local path of a GIF
 
 *      - unRepeat              Unrepeat playing.
 *      - playingComplete       Invoked after playing done.
 *  Usage:
 *      - startGIF
 *      - stopGIF
 *      - isGIFPlaying
 *******************************************************/

/*******************************************************
 *  依赖:
 *      - QuartzCore.framework
 *      - ImageIO.framework
 *  参数:
 *      以下传参2选1：
 *      - gifData       GIF图片的NSData
 *      - gifPath       GIF图片的本地路径
 
 *      - unRepeat              不重复播放
 *      - playingComplete       播放完成时调用，如果循环播放每次播放完都会调用
 *  调用:
 *      - startGIF      开始播放
 *      - stopGIF       结束播放
 *      - isGIFPlaying  判断是否正在播放
 *******************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MMGIFImageView : UIImageView
@property (nonatomic, strong) NSString          *gifPath;
@property (nonatomic, strong) NSData            *gifData;
@property (nonatomic, assign, readonly) CGSize  gifPixelSize;
@property (nonatomic, assign) BOOL              unRepeat;

@property (nonatomic, strong) NSArray          *gifImages; // gif image 数组
@property (nonatomic,  assign) CGFloat            gifImagesTime; // gif 动画时间

@property (copy, nonatomic) void(^playingComplete)();
- (void)startGIF;
- (void)startGIFWithRunLoopMode:(NSString * const)runLoopMode andImageDidLoad:(void(^)(CGSize imageSize))didLoad;
- (void)stopGIF;
- (BOOL)isGIFPlaying;
@end
