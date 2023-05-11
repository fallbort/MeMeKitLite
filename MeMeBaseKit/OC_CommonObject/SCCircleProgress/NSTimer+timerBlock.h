//  NESocialClient
//
//  Created by Chang Liu on 10/20/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSTimer (timerBlock)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(void(^)(void))block
                                       repeats:(BOOL)repeats;

@end
