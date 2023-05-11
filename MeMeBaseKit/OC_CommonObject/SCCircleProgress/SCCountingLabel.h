//  NESocialClient
//
//  Created by Chang Liu on 10/20/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SCCountingLabel : UILabel

@property (nonatomic, assign) CGFloat duration;

- (void)countingFrom:(CGFloat)fromValue to:(CGFloat)toValue;
- (void)countingFrom:(CGFloat)fromValue to:(CGFloat)toValue duration:(CGFloat)duration;

@end
