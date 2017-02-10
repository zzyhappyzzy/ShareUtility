//
//  ZZYMaxInputNumManager.m
//  ShareUtility
//
//  Created by zhenzhaoyang on 2017/2/10.
//  Copyright © 2017年 zhenchy. All rights reserved.
//

#import "ZZYMaxInputNumManager.h"

static int maxInputNum = 9999;

@interface ZZYMaxInputNumManager()<UITextViewDelegate,UITextFieldDelegate>

@end

@implementation ZZYMaxInputNumManager

- (void)addMaxInputTarget:(UIView<UITextInput>*)target maxCnt:(int)maxCnt {
    if (target == nil) return;
    if (maxCnt > 0) {
        maxInputNum = maxCnt;
    }
    if ([target isKindOfClass:[UITextField class]]) {
        ((UITextField *)target).delegate = self;
    }else if ([target isKindOfClass:[UITextView class]]) {
        ((UITextView *)target).delegate = self;
    }else {
        //unknow
    }
}

/**
 *  计算转换后字符的个数
 */
- (NSUInteger)lenghtWithString:(NSString *)string
{
    NSUInteger len = string.length;
    // 汉字字符集
    NSString *pattern  = @"[\u4e00-\u9fa5]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    return len + numMatch;
}

- (NSString *)checkUserInputText:(NSString *)text {
    if (text.length == 0) return @"";
    NSString *finalStr = [text stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return finalStr;
}

- (void)remindUserInputReachMax:(BOOL)max {
    if ([self.delegate respondsToSelector:@selector(userInputReachMaxCnt:)]) {
        [self.delegate userInputReachMaxCnt:max];
    }
}

- (BOOL)configInputTarget:(UIView<UITextInput>*)target text:(NSString *)text range:(NSRange)range fullText:(NSString *)fullText{
    if ([self.delegate respondsToSelector:@selector(textViewPlaceHoldHidden:)] && [target isKindOfClass:[UITextView class]]) {
        if (fullText.length == 0) {
            [self.delegate textViewPlaceHoldHidden:NO];
        }else {
            [self.delegate textViewPlaceHoldHidden:YES];
        }
    }
    //对于退格删除键开放限制
    if (text.length == 0) {
        return YES;
    }
    
    UITextRange *selectedRange = [target markedTextRange];
    //获取高亮部分(中文待输入区)
    UITextPosition *pos = [target positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [target offsetFromPosition:target.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [target offsetFromPosition:target.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < maxInputNum) {
            return YES;
        }
        else {
            return NO;
        }
    }
    
    NSString *comcatstr = [fullText stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = maxInputNum - comcatstr.length;
    
    if (caninputlen >= 0) {
        return YES;
    }
    else {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0) {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          NSInteger steplen = substring.length;
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx = idx + steplen;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            NSString *finalText = [fullText stringByReplacingCharactersInRange:range withString:s];
            if ([target isKindOfClass:[UITextField class]]) {
                [(UITextField *)target setText:finalText];
            }else if ([target isKindOfClass:[UITextView class]]) {
                [(UITextView *)target setText:finalText];
            }else{
                //unknow
            }
            if ([self.delegate respondsToSelector:@selector(userInputTextDidChange:)]) {
                [self.delegate userInputTextDidChange:finalText];
            }
        }
        [self remindUserInputReachMax:YES];
        return NO;
    }
}

#pragma mark--------UITextView delegate---
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(keyboardReturnBtnClicked)]) {
            [self.delegate keyboardReturnBtnClicked];
        }
        
        NSString *text = [textView.text stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (text.length > 0) {
            return NO;
        }
    }
    return [self configInputTarget:textView text:text range:range fullText:textView.text];
}

- (void)textViewDidChange:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分(中文联想直接选取)
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > maxInputNum) {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:maxInputNum];
        [textView setText:s];
        [self remindUserInputReachMax:YES];
    }else {
        [self remindUserInputReachMax:NO];
    }
    
    if ([self.delegate respondsToSelector:@selector(userInputTextDidChange:)]) {
        [self.delegate userInputTextDidChange:[self checkUserInputText:textView.text]];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(didEndEditText:)]) {
        [self.delegate didEndEditText:[self checkUserInputText:textView.text]];
    }
}

#pragma mark----UITextField delegate---

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(keyboardReturnBtnClicked)]) {
        [self.delegate keyboardReturnBtnClicked];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(didEndEditText:)]) {
        [self.delegate didEndEditText:[self checkUserInputText:textField.text]];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self configInputTarget:textField text:string range:range fullText:textField.text];
}

- (void)textfieldDidChange:(NSNotification *)noti {
    UITextField *textField = noti.object;
    if (!textField) return;
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分(中文联想直接选取)
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textField.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > maxInputNum) {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:maxInputNum];
        [textField setText:s];
        [self remindUserInputReachMax:YES];
    }else {
        [self remindUserInputReachMax:NO];
    }
    
    if ([self.delegate respondsToSelector:@selector(userInputTextDidChange:)]) {
        [self.delegate userInputTextDidChange:[self checkUserInputText:textField.text]];
    }
}


@end
