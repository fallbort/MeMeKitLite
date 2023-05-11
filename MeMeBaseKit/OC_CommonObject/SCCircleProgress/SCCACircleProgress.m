//  NESocialClient
//
//  Created by Chang Liu on 10/20/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//


#import "SCCACircleProgress.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

static CGFloat endPointMargin = 1.0f;

@interface SCCACircleProgress ()
@property (nonatomic ,strong) CAShapeLayer    *progressLayer;
@property (nonatomic ,strong) CAShapeLayer    *backLayer;
@property (nonatomic ,strong) CAGradientLayer *gradientLayer;
@end

@implementation SCCACircleProgress

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth {
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = lineWidth;
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    float centerX = self.bounds.size.width / 2.0;
    float centerY = self.bounds.size.height / 2.0;
    //半径
    float radius = (self.bounds.size.width - _lineWidth) / 2.0;
    
    //创建贝塞尔路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(1.5f * M_PI) endAngle:3.5f * M_PI clockwise:YES];
    [self.progressLayer setPath:[path CGPath]];
    //添加背景圆环
    [self.backLayer setPath:[path CGPath]];
    
    //设置渐变颜色
    [self.gradientLayer setMask:self.progressLayer]; //用progressLayer来截取渐变层
    [self.gradientLayer setColors:[NSArray arrayWithObjects:(id)[self.progressStartColor CGColor],(id)[self.progressEndColor CGColor], nil]];
    self.backLayer.strokeColor  = self.pathBackColor.CGColor;
    
    if (!self.backLayer.superlayer || !self.gradientLayer.superlayer) {
        [self.layer addSublayer:self.backLayer];
        [self.layer addSublayer:self.gradientLayer];
    }
}
#pragma mark -- setter
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    _progressLayer.strokeEnd = progress;
    [_progressLayer removeAllAnimations];
}

- (void)setProgressStartColor:(UIColor *)progressStartColor {
    _progressStartColor = progressStartColor;
    [self buildLayout];
}

- (void)setProgressEndColor:(UIColor *)progressEndColor {
    _progressEndColor = progressEndColor;
    [self buildLayout];
}
- (void)setPathBackColor:(UIColor *)pathBackColor {
    _pathBackColor = pathBackColor;
    [self buildLayout];
}

#pragma mark -- getter
- (CGFloat)lineWidth {
    if (!_lineWidth) {
        _lineWidth = 3;
    }
    return _lineWidth;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        //创建进度layer
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        _progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.lineWidth = _lineWidth;
        
        _progressLayer.strokeEnd = 0;
    }
    return _progressLayer;
}

- (CAShapeLayer *)backLayer {
    if (!_backLayer) {
        _backLayer = [CAShapeLayer layer];
        _backLayer.frame = self.bounds;
        _backLayer.fillColor =  [[UIColor clearColor] CGColor];
        _backLayer.lineWidth = _lineWidth;
        _backLayer.strokeEnd = 1;
    }
    return _backLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer =  [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
    }
    return _gradientLayer;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    if (animated) {
        CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnima.duration = 1;
        pathAnima.fromValue = [NSNumber numberWithFloat:self.progress];
        pathAnima.toValue = [NSNumber numberWithFloat:progress];
        pathAnima.removedOnCompletion = NO;
        pathAnima.autoreverses = NO;
        pathAnima.fillMode = kCAFillModeForwards;
        pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        pathAnima.removedOnCompletion = NO;
        [self.progressLayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
        _progress = progress;
        
    } else {
        [self setProgress:progress];
    }
}
@end
