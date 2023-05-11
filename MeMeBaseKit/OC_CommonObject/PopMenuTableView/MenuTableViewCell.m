//
//  MenuTableViewCell.m
//  PopMenuTableView
//
//  Created by 孔繁武 on 16/8/2.
//  Copyright © 2016年 KongPro. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "MenuModel.h"
#import "UIView+Banner.h"

@interface MenuTableViewCell ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *badgeView;
@end

@implementation MenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.menuImage];
    [self addSubview:self.menuLabel];
    [self addSubview:self.lineView];

    self.menuImage.frame = CGRectMake(8, 12, 24, 24);
    self.menuLabel.frame = CGRectMake(self.menuImage.right + 8, 12, 60, 24);
    self.lineView.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
}

- (void)setMenuModel:(MenuModel *)menuModel {
    _menuModel = menuModel;
    
    self.menuImage.image = [UIImage imageNamed:menuModel.menuImageName];
    self.menuLabel.text = menuModel.menuName;
    
    if (self.needHiddenLine) {
        self.lineView.hidden = YES;
    }
    
    if (menuModel.isDisabled) {
        _menuLabel.textColor = [UIColor grayColor];
    } else {
        _menuLabel.textColor = [UIColor whiteColor];
    }
}

-(void)prepareForReuse {
    [super prepareForReuse];
    [_badgeView removeFromSuperview];
}

#pragma mark - Getter
- (UILabel *)menuLabel {
    if (nil == _menuLabel) {
        _menuLabel = [[UILabel alloc] init];
        _menuLabel.textColor = [UIColor whiteColor];
        _menuLabel.font = [UIFont systemFontOfSize:14];
        _menuLabel.textAlignment = NSTextAlignmentLeft;
        _menuLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _menuLabel;
}

- (UIImageView *)menuImage {
    if (nil == _menuImage) {
        _menuImage = [[UIImageView alloc] init];
        _menuImage.backgroundColor = [UIColor clearColor];
    }
    
    return _menuImage;
}

- (UIView *)lineView {
    if (nil == _lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.4];
    }
    
    return _lineView;
}

-(void)showRedPointBadge {
    if (_badgeView == nil) {
        _badgeView = [[UILabel alloc] initWithFrame: CGRectMake(4, 6, 8, 8)];
        _badgeView.backgroundColor = UIColor.redColor;
        _badgeView.layer.cornerRadius = 4;
        _badgeView.layer.masksToBounds = true;
        _badgeView.text = nil;
        [self addSubview:_badgeView];
        [self bringSubviewToFront:_badgeView];
    }
}

@end
