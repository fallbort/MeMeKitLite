//
//  ObjC.h
//  LiveStream
//
//  Created by LuanMa on 16/7/4.
//  Copyright © 2016年 sip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjC : NSObject

+ (BOOL)catchException:(void(^)())tryBlock error:(__autoreleasing NSError **)error;

@end
