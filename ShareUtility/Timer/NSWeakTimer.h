//
//  NSWeakTimer.h
//  OptProjectDemo
//
//  Created by zhenchy on 16/6/24.
//  Copyright © 2016年 zhenchy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSWeakTimerTarget : NSObject

@end

@interface NSWeakTimer : NSObject

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)repeat;

@end
