//
//  ZZYCalendarManager.m
//  ShareUtility
//
//  Created by zhenzhaoyang on 2017/2/10.
//  Copyright © 2017年 zhenchy. All rights reserved.
//

#import "ZZYCalendarManager.h"

@interface ZZYCalendarManager()

@property (nonatomic, strong) NSCalendar *calendar;

@end

@implementation ZZYCalendarManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.calendar = [NSCalendar currentCalendar];
    }
    return self;
}

- (ZZYCalendarInfo *)getCalendarInfoWithDate:(NSDate *)date Scope:(ScopeType)type{
    if (date == nil) return nil;
    NSDateComponents *com = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    ZZYCalendarInfo *info = [ZZYCalendarInfo new];
    info.scopetype = type;
    
    if (type == kScopeTypeDay) {
        NSDate *monthFirstDay = [self dateWithYear:com.year month:com.month day:1];
        NSDate *monthEndDay = [self endOfMonthOfDate:monthFirstDay];
        NSDateComponents *tmpCom = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:monthEndDay];
        NSInteger endDay = tmpCom.day;
        
        for (int i = 1; i <= endDay; i++) {
            ZZYCalendarItem *item = [ZZYCalendarItem new];
            item.year = (int)com.year;
            item.month = (int)com.month;
            item.day = i;
            [info.calendarItems addObject:item];
        }
    }else if (type == kScopeTypeMonth) {
        for (int i = 1; i <= 12; i++) {
            ZZYCalendarItem *item = [ZZYCalendarItem new];
            item.year = (int)com.year;
            item.month = i;
            [info.calendarItems addObject:item];
        }
    }else {
        
    }
    return info;
}

- (NSDate *)convertDateToTheZero:(NSDate *)date {
    if (date == nil) return nil;
    NSDateComponents *com = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    return [self dateWithYear:com.year month:com.month day:com.day];
}

- (NSDate *)convertDateToTheLast:(NSDate *)date {
    if (date == nil) return nil;
    NSDateComponents *com = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    com.hour = 23;
    com.minute = 59;
    com.second = 59;
    NSDate *finalDate = [_calendar dateFromComponents:com];
    return finalDate;
}

- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = 0;
    NSDate *date = [_calendar dateFromComponents:components];
    components.year = NSIntegerMax;
    components.month = NSIntegerMax;
    components.day = NSIntegerMax;
    components.hour = NSIntegerMax;
    return date;
}

- (NSInteger)numberOfDatesInMonthOfDate:(NSDate *)date {
    NSRange days = [_calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return days.length;
}

- (NSDate *)beginingOfMonthOfDate:(NSDate *)date {
    NSDateComponents *components = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:date];
    components.day = 1;
    components.hour = 0;
    return [_calendar dateFromComponents:components];
}

- (NSDate *)endOfMonthOfDate:(NSDate *)date {
    NSDateComponents *components = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:date];
    components.month++;
    components.day = 0;
    components.hour = 0;
    return [_calendar dateFromComponents:components];
}

@end
