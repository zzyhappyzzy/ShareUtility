//
//  NSWeakTimer.m
//  OptProjectDemo
//
//  Created by zhenchy on 16/6/24.
//  Copyright © 2016年 zhenchy. All rights reserved.
//

#import "NSWeakTimer.h"

@interface NSWeakTimerTarget()

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation NSWeakTimerTarget

- (void) fire
{
    if(self.target)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:nil];
#pragma clang diagnostic pop
    }
    else
    {
        [self.timer invalidate];
    }
}

@end


@implementation NSWeakTimer

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)repeat {
    NSWeakTimerTarget *timerTarget = [[NSWeakTimerTarget alloc] init];
    timerTarget.target = aTarget;
    timerTarget.selector = aSelector;
    timerTarget.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:timerTarget selector:@selector(fire) userInfo:userInfo repeats:repeat];
    return timerTarget.timer;
}

@end
