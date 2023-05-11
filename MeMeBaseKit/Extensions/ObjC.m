//
//  ObjC.m
//  LiveStream
//
//  Created by LuanMa on 16/7/4.
//  Copyright © 2016年 sip. All rights reserved.
//

#import "ObjC.h"

@implementation ObjC

+ (BOOL)catchException:(void(^)())tryBlock error:(__autoreleasing NSError **)error {
	@try {
		tryBlock();
		return YES;
	}
	@catch (NSException *exception) {
		NSMutableDictionary * userInfo = [[NSMutableDictionary alloc] initWithDictionary:exception.userInfo];
		if (exception.reason) {
			[userInfo setObject: exception.reason forKey:NSLocalizedFailureReasonErrorKey];
		}
		*error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo: userInfo];
	}
}

@end
