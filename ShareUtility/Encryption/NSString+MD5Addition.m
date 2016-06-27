//
//  NSString+MD5Addition.m
//  demo
//
//  Created by zhenchy on 15/5/11.
//  Copyright (c) 2015年 zhenchy. All rights reserved.
//

#import "NSString+MD5Addition.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString(MD5Addition)

//32位 小写
- (NSString *) stringFromMD5With32LowerCase{
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

//32位  大写
- (NSString *)stringFromMD5With32UpperCase {
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02X",outputBuffer[count]];
    }
    
    return outputString;
}

//16位 小写
- (NSString *)stringFromMD5With16LowerCase {
    if(self == nil || [self length] == 0){
        return nil;
    }
    NSString *str = [self stringFromMD5With32LowerCase];
    
    //default from 8
    str = [str substringWithRange:NSMakeRange(8, 16)];
    
    return str;
}

//16位 大写
- (NSString *)stringFromMD5With16UpperCase {
    if(self == nil || [self length] == 0)
        return nil;
    
    NSString *str = [self stringFromMD5With32UpperCase];
    
    //default from 8
    str = [str substringWithRange:NSMakeRange(8, 16)];
    
    return str;
}

//二进制数据的md5码   32位小写
- (NSString *)stringFromMD5With32LowerCaseAndData:(NSData *)data {
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    const char *buf = [data bytes];
    CC_MD5_Update(&md5, buf, (CC_LONG)data.length);
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSMutableString *result = [[NSMutableString alloc] init];
    for(size_t i=0; i<sizeof(digest); i++) {
        [result appendFormat:@"%02x",digest[i]];
    }
    return result;
}

//本地文件的md5码   32位小写
- (NSString *)stringFromMD5With32LowerCaseAndFilePath:(NSString *)filePath {
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if( handle == nil ) {
        return nil;
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    int a = 0;
    while(!done) {
        a++;
        NSLog(@"%d",a);
        NSData *fileData = [handle readDataOfLength:102400]; //每次读取100K
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if([fileData length] == 0 ) {
            done = YES;
        }
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    
    NSMutableString *result = [[NSMutableString alloc] init];
    for(size_t i=0; i<sizeof(digest); i++) {
        [result appendFormat:@"%02x",digest[i]];
    }
    
    return result;
}

@end
