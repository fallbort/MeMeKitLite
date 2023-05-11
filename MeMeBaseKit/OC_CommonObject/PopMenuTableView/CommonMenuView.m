//
//  CommonMenuView.m
//  PopMenuTableView
//
//  Created by 孔繁武 on 2016/12/1.
//  Copyright © 2016年 KongPro. All rights reserved.
//

#import "CommonMenuView.h"
#import "UIView+AdjustFrame.h"
#import "MenuModel.h"
#import "MenuTableViewCell.h"
#import "UIView+Banner.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMenuTag 201712
#define kCoverViewTag 201722
#define kMargin 8
#define kTriangleHeight 0 // 三角形的高
#define kRadius 8 // 圆角半径

@interface CommonMenuView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *contentTableView;;
@property (nonatomic, strong) NSMutableArray *menuDataArray;
@end

@implementation CommonMenuView {
    UIView *_backView;
    CGFloat _arrowPointX;
}

- (void)setMenuDataArray:(NSMutableArray *)menuDataArray {
    if (!_menuDataArray) {
        _menuDataArray = [NSMutableArray array];
    }
    [menuDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[MenuModel class]]) {
            MenuModel *model = [MenuModel MenuModelWithDict:(NSDictionary *)obj];
            [_menuDataArray addObject:model];
        }
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithEffect: [UIBlurEffect effectWithStyle: UIBlurEffectStyleDark]]) {
        self.alpha = 0;
        self.frame = frame;
        
        self.pm_width = 112;
        self.pm_height = self.size.height;
        _arrowPointX = self.pm_width * 0.5;

        [self setUpUI];
    }
    return self;
}
- (void)setUpUI {

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTriangleHeight, self.pm_width, self.pm_height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[MenuTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MenuTableViewCell class])];
    if (@available(iOS 15.0, *)) {
        tableView.sectionHeaderTopPadding = 0;
    } else {
        // Fallback on earlier versions
    }
    self.contentTableView = tableView;
  
    UIView *fullScreenBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    fullScreenBackView.backgroundColor = [UIColor clearColor];
    [fullScreenBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    fullScreenBackView.alpha = 0;
    fullScreenBackView.tag = kCoverViewTag;
    _backView = fullScreenBackView;
    
    [[UIApplication sharedApplication].keyWindow addSubview:fullScreenBackView];

    CAShapeLayer *lay = [self getBorderLayer];
    self.layer.mask = lay;
    [self.contentView addSubview:tableView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

#pragma mark --- TableView DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MenuTableViewCell class]) forIndexPath:indexPath];
    
    cell.needHiddenLine = [self isTopCellForRowIndex:indexPath.row dataArray:self.menuDataArray];
    MenuModel *model = self.menuDataArray[indexPath.row];
    cell.menuModel = model;
    if (model.userDefaultsKey) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL showedBadge = [defaults objectForKey: model.userDefaultsKey];
        if (!showedBadge) {
            [cell showRedPointBadge];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MenuModel *model = self.menuDataArray[indexPath.row];
    if (model.isDisabled == true) {
        return;
    }
    
    if (self.itemsClickBlock) {
        self.itemsClickBlock(model.menuName,indexPath.row);
    }
    if (model.userDefaultsKey) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:model.userDefaultsKey];
    }
}

///是否是顶部的cell-row
- (BOOL)isTopCellForRowIndex:(NSUInteger)rowIndex dataArray:(NSArray *_Nullable)dataArray {
    if (dataArray.count == 0) {
        return NO;
    }
    
    NSUInteger topRowIndex = 0;
    if (topRowIndex == rowIndex) {
        return YES;
    }
    
    return NO;
}

#pragma mark --- 关于菜单展示
- (void)displayAtPoint:(CGPoint)point {
    
    point = [self.superview convertPoint:point toView:self.window];
    self.layer.affineTransform = CGAffineTransformIdentity;
    [self adjustPosition:point]; // 调整展示的位置 - frame
    
    // 调整箭头位置
    if (point.x <= kMargin + kRadius + kTriangleHeight * 0.7) {
        _arrowPointX = kMargin + kRadius;
    }else if (point.x >= kScreenWidth - kMargin - kRadius - kTriangleHeight * 0.7){
        _arrowPointX = self.pm_width - kMargin - kRadius;
    }else{
        _arrowPointX = point.x - self.pm_x;
    }
    
    // 调整anchorPoint
    CGPoint aPoint = CGPointMake(0.5, 0.5);
    if (CGRectGetMaxY(self.frame) > kScreenHeight) {
        aPoint = CGPointMake(_arrowPointX / self.pm_width, 1);
    }else{
        aPoint = CGPointMake(_arrowPointX / self.pm_width, 0);
    }
    
    // 调整layer
    CAShapeLayer *layer = [self getBorderLayer];
    if (self.pm_max_y> kScreenHeight) {
        layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        layer.transform = CATransform3DRotate(layer.transform, M_PI, 0, 0, 1);
        self.pm_y = point.y - self.pm_height;
    }
    
    // 调整frame
    CGRect rect = self.frame;
    self.layer.anchorPoint = aPoint;
    self.frame = rect;
    
    self.layer.mask = layer;
    self.layer.affineTransform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        _backView.alpha = 0.3;
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)adjustPosition:(CGPoint)point {
    self.pm_x = point.x - self.pm_width * 0.5;
    self.pm_y = point.y + kMargin;
    if (self.pm_x < kMargin) {
        self.pm_x = kMargin;
    }else if (self.pm_x > kScreenWidth - kMargin - self.pm_width){
        self.pm_x = kScreenWidth - kMargin - self.pm_width;
    }
    self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
}

- (void)updateFrameForMenu {
    CommonMenuView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:kMenuTag];
    menuView.transform = CGAffineTransformMakeScale(1.0, 1.0);;
    menuView.layer.mask = [menuView getBorderLayer];
    menuView.transform = CGAffineTransformMakeScale(0.01, 0.01);
}

- (void)hiddenMenu {
    self.contentTableView.contentOffset = CGPointMake(0, 0);
    [UIView animateWithDuration:0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.01, 0.01);
        self.alpha = 0;
        _backView.alpha = 0;
    }];
}

- (void)tap:(UITapGestureRecognizer *)sender {
    if (self.backViewTapBlock) {
        self.backViewTapBlock();
    }
    [self hiddenMenu];
    
}
- (CAShapeLayer *)getBorderLayer {
    // 上下左右的圆角中心点
    CGPoint upperLeftCornerCenter = CGPointMake(kRadius, kTriangleHeight + kRadius);
    CGPoint upperRightCornerCenter = CGPointMake(self.pm_width - kRadius, kTriangleHeight + kRadius);
    CGPoint bottomLeftCornerCenter = CGPointMake(kRadius, self.pm_height - kTriangleHeight - kRadius);
    CGPoint bottomRightCornerCenter = CGPointMake(self.pm_width - kRadius, self.pm_height - kTriangleHeight - kRadius);
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = self.bounds;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, kTriangleHeight + kRadius)];
    [bezierPath addArcWithCenter:upperLeftCornerCenter radius:kRadius startAngle:M_PI endAngle:M_PI * 3 * 0.5 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(_arrowPointX - kTriangleHeight * 0.7, kTriangleHeight)];
    [bezierPath addLineToPoint:CGPointMake(_arrowPointX, 0)];
    [bezierPath addLineToPoint:CGPointMake(_arrowPointX + kTriangleHeight * 0.7, kTriangleHeight)];
    [bezierPath addLineToPoint:CGPointMake(self.pm_width - kRadius, kTriangleHeight)];
    [bezierPath addArcWithCenter:upperRightCornerCenter radius:kRadius startAngle:M_PI * 3 * 0.5 endAngle:0 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(self.pm_width, self.pm_height - kTriangleHeight - kRadius)];
    [bezierPath addArcWithCenter:bottomRightCornerCenter radius:kRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(kRadius, self.pm_height - kTriangleHeight)];
    [bezierPath addArcWithCenter:bottomLeftCornerCenter radius:kRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(0, kTriangleHeight + kRadius)];
    [bezierPath closePath];
    borderLayer.path = bezierPath.CGPath;
    return borderLayer;
}

#pragma mark --- 类方法封装
+ (CommonMenuView *)createMenuWithDataArray:(NSArray *)dataArray
                            itemsClickBlock:(ItemsClickBlock)itemsClickBlock
                                backViewTap:(BackViewTapBlock)backViewTapBlock {
    [self clearMenu];
    
    CommonMenuView *menuView = [[CommonMenuView alloc] initWithFrame:CGRectMake(0, 0, 112, 48 * dataArray.count)];
    menuView.itemsClickBlock = itemsClickBlock;
    menuView.backViewTapBlock = backViewTapBlock;
    menuView.menuDataArray = [NSMutableArray arrayWithArray:dataArray];
    menuView.tag = kMenuTag;
    
    return menuView;
}

+ (void)reloadTable {
    CommonMenuView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:kMenuTag];
    if (menuView) {
        [menuView.contentTableView reloadData];
    }
}

+ (void)showMenuAtPoint:(CGPoint)point {
    CommonMenuView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:kMenuTag];
    [menuView displayAtPoint:point];
}

+ (CommonMenuView *)getMenuView {
    CommonMenuView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:kMenuTag];
    return menuView;
}

+ (void)hidden {
    CommonMenuView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:kMenuTag];
    if (menuView) {
        [menuView hiddenMenu];
    }
}

+ (void)clearMenu {
    [CommonMenuView hidden];
    
    CommonMenuView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:kMenuTag];
    UIView *coverView = [[UIApplication sharedApplication].keyWindow viewWithTag:kCoverViewTag];
    
    if (menuView && coverView) {
        [menuView removeFromSuperview];
        [coverView removeFromSuperview];
       
        menuView = nil;
        coverView = nil;
    }
}

@end
