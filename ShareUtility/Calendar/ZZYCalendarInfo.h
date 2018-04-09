//
//  ZZYCalendarInfo.h
//  ShareUtility
//
//  Created by zhenzhaoyang on 2017/2/10.
//  Copyright © 2017年 zhenchy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int,ScopeType) {
    kScopeTypeDay = 0,   //选择具体天数
    kScopeTypeMonth = 1  //选择月份
};

@interface ZZYCalendarItem : NSObject

@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) int year;
@property (nonatomic, assign) int month;

@property (nonatomic, assign) int day;
@property (nonatomic, assign, readonly) int weekday; //1-7,sunday is 1

@end

@interface ZZYCalendarInfo : NSObject

@property (nonatomic, assign) ScopeType scopetype;
@property (nonatomic, strong) NSMutableArray *calendarItems;

@end
