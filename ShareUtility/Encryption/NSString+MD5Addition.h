//
//  NSString+MD5Addition.h
//  Demo
//
//  Created by zhenchy on 15/5/11.
//  Copyright (c) 2015年 zhenchy. All rights reserved.
//


/*
 16位和32位MD加密的区别
 只是长度的区别而已！
 16位加密就是从32位MD5散列中把中间16位提取出来！(可以自己设定怎么从32位的md5中提取出16位作为16位md5)
 就好比破解16位MD5散列不见得比破解32位MD5散列快~
 因为他多了一个步骤就是加密后再把中间16位提取出来~ 然后再进行对比
 而破解32位的则不需要~ 加密后直接对比~
 */

#import <Foundation/Foundation.h>

@interface NSString(MD5Addition)

//16 字符串
- (NSString *)stringFromMD5With16LowerCase;
- (NSString *)stringFromMD5With16UpperCase;

//32 字符串
- (NSString *)stringFromMD5With32LowerCase;
- (NSString *)stringFromMD5With32UpperCase;

//32 文件(其他类型参考字符串)
- (NSString *)stringFromMD5With32LowerCaseAndData:(NSData *)data;
- (NSString *)stringFromMD5With32LowerCaseAndFilePath:(NSString *)filePath;

@end
