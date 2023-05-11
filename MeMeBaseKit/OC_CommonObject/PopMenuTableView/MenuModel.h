//
//  MenuModel.h
//  PopMenuTableView
//
//  Created by 孔繁武 on 16/8/2.
//  Copyright © 2016年 KongPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuModel : NSObject

@property (nonatomic, copy) NSString *menuImageName;
@property (nonatomic, copy) NSString *menuName;
@property (nonatomic, copy) NSString *userDefaultsKey;
@property (nonatomic, assign) BOOL isDisabled;

+ (instancetype)MenuModelWithDict:(NSDictionary *)dict;

@end
