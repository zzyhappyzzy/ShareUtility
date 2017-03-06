//
//  ZZYMaxInputNumManager.h
//  ShareUtility
//
//  Created by zhenzhaoyang on 2017/2/10.
//  Copyright © 2017年 zhenchy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ZZYMaxInputNumManagerDelegate <NSObject>
@optional
- (void)keyboardReturnBtnClicked; //点击键盘的return按钮
- (void)userInputTextDidChange:(NSString *)str; //当前已输入的文字（实时变化，可用于计算剩余字数）
- (void)didEndEditText:(NSString *)str;  //最终输入的文字
- (void)textViewPlaceHoldHidden:(BOOL)hidden; //是否显示textview的placehold
- (void)userInputReachMaxCnt:(BOOL)reachMax; //输入字符是否达到最大数

@end

@interface ZZYMaxInputNumManager : NSObject

@property (nonatomic, weak) id<ZZYMaxInputNumManagerDelegate>delegate;

- (void)addMaxInputTarget:(UIView<UITextInput>*)target maxCnt:(int)maxCnt;

@end
