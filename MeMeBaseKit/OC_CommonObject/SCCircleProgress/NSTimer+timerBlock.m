//  NESocialClient
//
//  Created by Chang Liu on 10/20/17.
//  Copyright © 2017 Chang Liu. All rights reserved.
//


#import "NSTimer+timerBlock.h"

@implementation NSTimer (timerBlock)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(void))block repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)blockInvoke:(NSTimer *)timer {
    void (^ block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}

@end
