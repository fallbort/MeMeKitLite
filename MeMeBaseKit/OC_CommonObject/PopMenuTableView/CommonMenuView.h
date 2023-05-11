//
//  CommonMenuView.h
//  PopMenuTableView
//
//  Created by 孔繁武 on 2016/12/1.
//  Copyright © 2016年 KongPro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemsClickBlock)(NSString *str, NSInteger index);
typedef void(^BackViewTapBlock)(void);

@interface CommonMenuView : UIVisualEffectView

@property (nonatomic, copy) ItemsClickBlock itemsClickBlock;
@property (nonatomic, copy) BackViewTapBlock backViewTapBlock;

+ (void)reloadTable;

+ (CommonMenuView *)createMenuWithDataArray:(NSArray *)dataArray
                            itemsClickBlock:(ItemsClickBlock)itemsClickBlock
                                backViewTap:(BackViewTapBlock)backViewTapBlock;

+ (void)showMenuAtPoint:(CGPoint)point;

+ (void)hidden;

+ (void)clearMenu;

+ (CommonMenuView *)getMenuView;

@end
