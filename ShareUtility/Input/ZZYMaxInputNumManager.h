//
//  ZZYMaxInputNumManager.h
//  ShareUtility
//
//  Created by zhenzhaoyang on 2017/2/10.
//  Copyright © 2017年 zhenchy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZZYMaxInputNumManager;

@protocol ZZYMaxInputNumManagerDelegate <NSObject>
@optional
//当前已输入的文字（实时变化，可用于计算剩余字数）
- (void)inputManager:(ZZYMaxInputNumManager *)manager textDidChange:(NSString *)str;

//是否显示textView的自定义placeHolder
- (void)inputManager:(ZZYMaxInputNumManager *)manager textViewPlaceHoldHidden:(BOOL)hidden;

//输入字符是否达到最大数
- (void)inputManager:(ZZYMaxInputNumManager *)manager inputReachLimitCnt:(BOOL)reachMax;

@end

@interface ZZYMaxInputNumManager : NSObject

/**
 用户的输入字符串
 */
@property (nonatomic, strong, readonly) NSString *theInputText;

/**
 检查用户的输入 (只有当输入全为空格、换行符组成的字符串时，该值为NO)
 */
@property (nonatomic, assign, readonly) BOOL validateInput;

/**
 是否允许输入换行(UITextView)，默认为NO
 */
@property (nonatomic, assign) BOOL enableInputNewline;

/**
 输入控件的参数配置

 @param target textField/textView
 @param maxLength 最大输入字符数，默认为999字符
 @param delegate 代理。可以为nil
 */
- (void)addMaxInputTarget:(UIView<UITextInput>*)target limitStringLength:(int)maxLength delegate:(id<ZZYMaxInputNumManagerDelegate>)delegate;

@end
