//
//  ZZYCalendarInfo.m
//  ShareUtility
//
//  Created by zhenzhaoyang on 2017/2/10.
//  Copyright © 2017年 zhenchy. All rights reserved.
//

#import "ZZYCalendarInfo.h"

@interface ZZYCalendarItem()

@property (nonatomic, assign) int weekday; //1-n,sunday is 1

@end

@implementation ZZYCalendarItem

- (instancetype)init {
    self = [super init];
    if (self) {
        self.year = 1970;
        self.month = 1;
        self.day = 1;
        self.enable = NO;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%d-%d-%d week:%d enable:%d",self.year,self.month,self.day,self.weekday,self.enable];
}

- (int)weekday {
    NSDate *date = [self dateWithYear:self.year month:self.month day:self.day];
    NSDateComponents *com = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    return (int)com.weekday;
}

- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = 0;
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
    components.year = NSIntegerMax;
    components.month = NSIntegerMax;
    components.day = NSIntegerMax;
    components.hour = NSIntegerMax;
    return date;
}

@end


@implementation ZZYCalendarInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        self.calendarItems = [NSMutableArray array];
    }
    return self;
}

@end
