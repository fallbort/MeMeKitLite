//  NESocialClient
//
//  Created by Chang Liu on 10/20/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCountingLabel.h"

@interface SCCACircleProgress : UIView
//图形定制
@property (nonatomic, strong) UIColor *pathBackColor;
@property (nonatomic ,strong) UIColor *progressStartColor;
@property (nonatomic ,strong) UIColor *progressEndColor;

//进度
@property (nonatomic, assign) CGFloat progress;/**<进度 0-1 */
@property (assign,nonatomic) CGFloat lineWidth;

- (instancetype)initWithFrame:(CGRect)frame
                    lineWidth:(float)lineWidth;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
@end
