//
//  ZZYMaxInputNumManager.m
//  ShareUtility
//
//  Created by zhenzhaoyang on 2017/2/10.
//  Copyright © 2017年 zhenchy. All rights reserved.
//

#import "ZZYMaxInputNumManager.h"

@interface ZZYMaxInputNumManager()<UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSString *theInputText;
@property (nonatomic, assign) int maxStringLength;
@property (nonatomic, assign) BOOL validateInput;
@property (nonatomic, weak) id<ZZYMaxInputNumManagerDelegate>delegate;
@property (nonatomic, weak) UIView<UITextInput> *target;

@end

@implementation ZZYMaxInputNumManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.enableInputNewline = NO;
        self.maxStringLength = 999;
    }
    return self;
}

- (void)addMaxInputTarget:(UIView<UITextInput>*)target limitStringLength:(int)maxLength delegate:(id<ZZYMaxInputNumManagerDelegate>)delegate {
    if (target == nil) return;
    if (maxLength > 0) {
        _maxStringLength = maxLength;
    }
    _delegate = delegate;
    _target = target;
    if ([target isKindOfClass:[UITextField class]]) {
        ((UITextField *)target).delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }else if ([target isKindOfClass:[UITextView class]]) {
        ((UITextView *)target).delegate = self;
    }else {
        //unknow
    }
}

/**
 *  计算转换后字符的个数
 */
- (NSUInteger)lenghtWithString:(NSString *)string {
    NSUInteger len = string.length;
    // 汉字字符集
    NSString *pattern  = @"[\u4e00-\u9fa5]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    return len + numMatch;
}

- (void)remindUserInputReachMax:(BOOL)max {
    if ([self.delegate respondsToSelector:@selector(inputManager:inputReachLimitCnt:)]) {
        [self.delegate inputManager:self inputReachLimitCnt:max];
    }
}

- (BOOL)validateInput {
    return [self validateUserInputCharacter];
}

- (void)checkPlaceHodler:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(inputManager:textViewPlaceHoldHidden:)] && [_target isKindOfClass:[UITextView class]]) {
        [self.delegate inputManager:self textViewPlaceHoldHidden:text.length ? YES : NO];
    }
}

//检查用户输入是否为无效字符串
- (BOOL)validateUserInputCharacter {
    if (_theInputText.length == 0) return YES;
    NSString *trimmingStr = [_theInputText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimmingStr.length == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)configInputTarget:(UIView<UITextInput>*)target text:(NSString *)text range:(NSRange)range fullText:(NSString *)fullText{
    if ([self.delegate respondsToSelector:@selector(inputManager:textViewPlaceHoldHidden:)] && [target isKindOfClass:[UITextView class]]) {
        if (text.length + fullText.length == 0) {
            [self.delegate inputManager:self textViewPlaceHoldHidden:NO];
        }else {
            [self.delegate inputManager:self textViewPlaceHoldHidden:YES];
        }
    }
    //对于退格删除键开放限制
    if (text.length == 0) {
        return YES;
    }
    
    UITextRange *selectedRange = [target markedTextRange];
    //获取高亮部分(中文待输入区)
    UITextPosition *pos = [target positionFromPosition:selectedRange.start offset:0];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [target offsetFromPosition:target.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [target offsetFromPosition:target.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < _maxStringLength) {
            return YES;
        }
        else {
            return NO;
        }
    }
    
    NSString *comcatstr = [fullText stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = _maxStringLength - comcatstr.length;
    
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
            if ([self.delegate respondsToSelector:@selector(inputManager:textDidChange:)]) {
                [self.delegate inputManager:self textDidChange:finalText];
            }
        }
        [self remindUserInputReachMax:YES];
        return NO;
    }
}

#pragma mark--------UITextView delegate---
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"] && !self.enableInputNewline) {
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
    
    if (existTextNum > _maxStringLength) {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:_maxStringLength];
        [textView setText:s];
        [self remindUserInputReachMax:YES];
    }else {
        [self remindUserInputReachMax:NO];
    }
    
    if ([self.delegate respondsToSelector:@selector(inputManager:textDidChange:)]) {
        [self.delegate inputManager:self textDidChange:textView.text];
    }
    [self checkPlaceHodler:textView.text];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.theInputText = textView.text;
}

#pragma mark----UITextField delegate---

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _theInputText = textField.text;
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
    
    if (existTextNum > _maxStringLength) {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:_maxStringLength];
        [textField setText:s];
        [self remindUserInputReachMax:YES];
    }else {
        [self remindUserInputReachMax:NO];
    }
    
    if ([self.delegate respondsToSelector:@selector(inputManager:textDidChange:)]) {
        [self.delegate inputManager:self textDidChange:textField.text];
    }
}

- (void)dealloc {
    if ([_target isKindOfClass:[UITextField class]]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

@end
