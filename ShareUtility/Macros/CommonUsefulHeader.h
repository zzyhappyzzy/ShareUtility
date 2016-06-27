//
//  CommonUsefulHeader.h
//  PhotosDemo
//
//  Created by zhenchy on 16/6/27.
//  Copyright © 2016年 zhenchy. All rights reserved.
//

#ifndef CommonUsefulHeader_h
#define CommonUsefulHeader_h

//system version number(sdk9.0++)(https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/TransitionGuide/SupportingEarlieriOS.html#//apple_ref/doc/uid/TP40013174-CH14-SW1)
#define LESS_THAN_OR_EQUAL_IOS6 ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) ? YES : NO)
#define LESS_THAN_OR_EQUAL_IOS7 ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) ? YES : NO)
#define LESS_THAN_OR_EQUAL_IOS8 ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_8_4) ? YES : NO)
#define GREATER_THAN_IOS8 ((floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_4) ? YES : NO)

/*
 #define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
 #define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
 #define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
 #define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
 #define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//if (SYSTEM_VERSION_LESS_THAN(@"4.0")) {
//    ...
//}

//if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"3.1.1")) {
//    ...
//}

*/

//screen info
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define IS_RETAIN     ([[UIScreen mainScreen] scale] >= 2.0)

//color
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HEXCOLORA(hexValue,a) [UIColor colorWithRed:((hexValue >> 16) & 0xFF) /255.0 green: ((hexValue >> 8) & 0xFF) /255.0 blue:(hexValue & 0xFF) /255.0 alpha:a]

//app info
#define APP_VERSION   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define  APP_IDENTIFIER  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

//log
#ifdef DEBUG
#define   NSLog(...) NSLog(__VA_ARGS__)
#define   MyLog(...) NSLog(@"%s:%d------->%@",__FUNCTION__,__LINE__,__VA_ARGS__)
#else
#define   NSLog(...)
#define   MyLog(...)
#endif


#endif /* CommonUsefulHeader_h */
