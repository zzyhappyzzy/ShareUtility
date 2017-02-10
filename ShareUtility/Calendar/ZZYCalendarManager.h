//
//  ZZYCalendarManager.h
//  ShareUtility
//
//  Created by zhenzhaoyang on 2017/2/10.
//  Copyright © 2017年 zhenchy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZYCalendarInfo.h"

@interface ZZYCalendarManager : NSObject

- (ZZYCalendarInfo *)getCalendarInfoWithDate:(NSDate *)date Scope:(ScopeType)type;

/**
 * 返回某一天的零点日期00:00:00
 */
- (NSDate *)convertDateToTheZero:(NSDate *)date;

/**
 * 返回某一天的23:59:59
 */
- (NSDate *)convertDateToTheLast:(NSDate *)date;

/**
 * 返回某一天的零点日期
 */
- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

/**
 *  某日期当月的天数
 */
- (NSInteger)numberOfDatesInMonthOfDate:(NSDate *)date;

/**
 *  某日期当月的第一天
 */
- (NSDate *)beginingOfMonthOfDate:(NSDate *)date;

/**
 * 某日期当月的最后一天
 */
- (NSDate *)endOfMonthOfDate:(NSDate *)date;

@end
