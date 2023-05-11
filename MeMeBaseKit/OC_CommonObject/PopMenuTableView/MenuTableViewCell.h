//
//  MenuTableViewCell.h
//  PopMenuTableView
//
//  Created by 孔繁武 on 16/8/2.
//  Copyright © 2016年 KongPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuModel;

@interface MenuTableViewCell : UITableViewCell

@property (nonatomic, strong) MenuModel *menuModel;
@property (nonatomic, strong) UIImageView *menuImage;
@property (nonatomic, strong) UILabel *menuLabel;

@property (nonatomic, assign) BOOL needHiddenLine;

-(void)showRedPointBadge;
@end
