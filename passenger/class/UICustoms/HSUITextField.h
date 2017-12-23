//
//  HSUITextField.h
//  
//
//  Created by apple on 11-11-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CALayerLine.h"

@class HSUITextField;

@protocol HSUITextFieldDelegate <UITextFieldDelegate>

@optional

- (void)textFieldValueDidChange:(HSUITextField *)textField;

@end

@interface HSUITextFieldObject : UIView
<HSUITextFieldDelegate>

//判断字符，是否含Emoji字符
+ (BOOL)stringContainsEmoji:(NSString *)substring;

//九宫格输入法判断
+ (NSInteger)textInput:(id<UITextInput>)textInput
                maxLen:(NSUInteger) maxLen
                 range:(NSRange)range
     replacementString:(NSString *)string
    preMarkedTextRange:(UITextRange *)preMarkedTextRange
      checkMarkedRange:(NSRange *)checkMarkedRange
             tickCount:(int64_t *)tickCount;

//九宫格输入法，录入英文字母验证
+ (void)textInput:(id<UITextInput>)textField
preMarkedTextRange:(UITextRange *)preMarkedTextRange
 checkMarkedRange:(NSRange *)checkMarkedRange
        tickCount:(int64_t *)tickCount
     changedBlock:(dispatch_block_t)changedBlock
           MaxLen:(NSUInteger)maxLen
       NumberOnly:(BOOL)numberOnly
          Decimal:(Byte)decimal
         PassWord:(BOOL)passWord
       InputEmoji:(BOOL)inputEmoji
  inputCharacters:(NSString *)inputCharacters
deleteBackwarding:(BOOL *)deleteBackwarding;


+ (BOOL)textInput:(id<UITextInput>)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
           MaxLen:(NSUInteger)maxLen
       NumberOnly:(BOOL)numberOnly
          Decimal:(Byte)decimal
         PassWord:(BOOL)passWord
       InputEmoji:(BOOL)inputEmoji
  inputCharacters:(NSString *)inputCharacters
deleteBackwarding:(BOOL *)deleteBackwarding;

+ (UITextRange *)textInput:(id<UITextInput>)textInput range:(NSRange)range;

+ (NSRange)textInput:(id<UITextInput>)textInput textRange:(UITextRange *)textRange;

@property (nonatomic) NSUInteger maxLen;
@property (nonatomic) BOOL numberOnly;
@property (nonatomic) Byte decimal;
@property (nonatomic) BOOL passWord;
@property (nonatomic) BOOL inputEmoji;
//限定可录入字符。 默认为nil，设置此项后 numberOnly passWord inputEmoji 选项无效
@property (nonatomic, copy) NSString *inputCharacters;

@end

@interface HSUITextField : UITextField

- (BOOL)textFieldShouldChangeCharactersInRange:(NSRange)range
                             replacementString:(NSString *)string;

//最大可录入长度 默认400
@property (nonatomic, assign) IBInspectable NSUInteger maxLen;

//只录入 数字 与 .   默认为No
@property (nonatomic, assign) IBInspectable BOOL numberOnly;

//数字 小数位数 默认2
@property (nonatomic, assign) IBInspectable Byte decimal;

//录入的是密码 密码框 不认录入中文 默认为 No
@property (nonatomic, assign) IBInspectable BOOL passWord;

//是否允许录入表情符 默认为 NO
@property (nonatomic, assign) IBInspectable BOOL inputEmoji;

//<= 0时，不显示， >= 1 <= width时会当前View宽，
@property (nonatomic, assign) CGFloat focusLineWidth;

@property (nonatomic, assign) id<HSUITextFieldDelegate> delegate;

//限定可录入字符。 默认为nil，设置此项后 numberOnly passWord inputEmoji 选项无效
@property (nonatomic, copy) NSString *inputCharacters;

@end

//inputCharacters 扩展
@interface HSUITextField (InputCharacters)

//设置只录入数字与字母 inputCharacters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
- (void)setAlphaNumberInputCharacters;

//设置身份证号 inputCharacters = @"0123456789Xx"
- (void)setCardNumberInputCharacters;

@end

@interface UITextField (Empty)

//判断文本框是否为空
- (BOOL)isEmpty;

@end

@interface UITextField (PlaceholderColor)

//占位文字颜色
@property (nonatomic, strong) UIColor *placeholderColor;

//设置光标颜色
@property (nonatomic, strong) UIColor *pointColor;

@end
