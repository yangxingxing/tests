//
//  HSUITextField.m
//  
//
//  Created by apple on 11-11-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "HSUITextField.h"
#import "UIView+Category.h"
#import "wComm.h"
#import "RYNumberKeyboard.h"
//#import "wViewController.h"

@interface HSUITextFieldObject()
{
    BOOL _deleteBackwarding;
}

@property (nonatomic, copy)UITextRange *preMarkedTextRange;
//记录中文输入法 九宫格录入英文字母A-z的区间
@property (nonatomic, assign) NSRange checkMarkedRange;

@property (nonatomic, assign) int64_t tickCount;

@end

@implementation HSUITextFieldObject

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _maxLen     = 400;
        _numberOnly = NO;
        _decimal    = 2;
        _passWord   = NO;
        self.hidden = YES;
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    self.inputCharacters = nil;
    self.preMarkedTextRange = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

+ (BOOL)stringContainsEmoji:(NSString *)substring
{
    BOOL returnValue = NO;
    if (!substring || substring.length == 0)
        return returnValue;
    
    const unichar hs = [substring characterAtIndex:0];
    // surrogate pair
    if (0xd800) {
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const NSInteger uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f + 1000) {  //qiujj IOS9 增加很多表情，需要用 + 1000
                    returnValue = YES;
                }
            }
        }else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls >= 0x20e3) { //qiujj IOS9 增加很多表情，需要用 >=
                returnValue = YES;
            }
        }else {
            // non surrogate
            //❶❷❸❹❺
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            }else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            }else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            }else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            }else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }
    
    return returnValue;
}

+ (BOOL)textInput:(id<UITextInput>)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string MaxLen:(NSUInteger)maxLen NumberOnly:(BOOL)numberOnly
          Decimal:(Byte)decimal PassWord:(BOOL)passWord
       InputEmoji:(BOOL)inputEmoji
  inputCharacters:(NSString *)inputCharacters
deleteBackwarding:(BOOL *)deleteBackwarding
{
    UIView *inputTextView = (UIView *)textField;

    
    if (!string || string.length == 0)
        return YES;
    
    if (![textField respondsToSelector:@selector(text)])
        return YES;

    NSString *oldText = [inputTextView valueForKey:@"text"];
    
    //粘贴过长字符时,返回FALSE  这些属性 都是NSUInteger 有 相减 运算,要转为 NSInteger
    NSInteger totalLen = oldText.length + string.length - range.length;
    //控制长度
    if (!textField.markedTextRange && totalLen > maxLen && string && string.length > 0)
    {
        return NO;
    }
//    if((range.location >= maxLen || totalLen > maxLen) )
//    {
//        //markedTextRange 拼音联想录入
//        if (passWord || numberOnly || range.location >= maxLen)
//            return NO;
//    }
    
    if (inputCharacters && inputCharacters.length > 0)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:inputCharacters] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    
    //禁止表情输入法的表情输入
    if (!inputEmoji)
    {
        UITextInputMode *textInputMode = nil;
        if ([inputTextView respondsToSelector:@selector(textInputMode)])
        {
            textInputMode = [inputTextView textInputMode];
            if (!textInputMode)  //emoji输入法时 为nil， 第三方输入法，这判断是没用的。
                return NO;
        }
        else
            textInputMode = [UITextInputMode currentInputMode];
        
        if (textInputMode && [textInputMode.primaryLanguage isEqualToString:@"emoji"])
            return NO;
    }
    
    //密码 不录入中文
    if ((passWord || !inputEmoji) && string.length > 0) //
    {
        __block BOOL returnValue = YES;
        [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                                   options:NSStringEnumerationByComposedCharacterSequences
                                usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                    
                                    unichar ch = [substring characterAtIndex:0];
                                    if (passWord && (ch < 20 || ch >= 127))
                                    {
                                        returnValue = NO;
                                        *stop = YES;
                                    }
                                    else
                                        if (!inputEmoji && [HSUITextFieldObject stringContainsEmoji:substring])
                                        {
                                            returnValue = NO;
                                            *stop = YES;
                                        }
                                }];
        if (!returnValue)
            return returnValue;
    }

    
    if (numberOnly)
    {        
        double d = [string doubleValue];
        if (string.length > 1 && d == 0)
            return NO;
        
        //如果录入整数,有 点 时, 不应录入
        NSRange dr = [string rangeOfString:@"."];
        if (decimal == 0 && dr.length > 0)
            return NO;
        
        //录入 .
        if (dr.length > 0 && string.length - dr.location - 1 > decimal)
            return NO;
        
        int inputDecCount = 0;
        //有了小数点
        NSRange decimalRange = [oldText rangeOfString:@"."];

        for (NSUInteger i = 0; i < string.length; i++) {
            
            unichar ch = [string characterAtIndex:i];
            
            //字符0－9 和 .
            if( ch != 46 && (ch < 48 || ch > 57))
                return NO;
            
            if (ch == '.')
            {
                inputDecCount++;
                if (inputDecCount > 1)
                    return NO;
                
                //如果录入点(.), 但后面有大于3位时,不能录入.
                if (range.length > 0 && totalLen - (range.location + i)  > decimal)
                    return NO;
            }
        }
        
        if(decimalRange.length == 1)
        {
            NSUInteger length = decimalRange.location;
            
            //小数点后面两位小数 且不能再是小数点//3表示后面小数位的个数。。
            if(oldText.length - length > decimal || inputDecCount > 0)
                return NO;
        }
    }
    
    //录入文本时，将多余字符切掉
    if (totalLen > maxLen)
    {
        NSInteger dec = totalLen - maxLen;
        NSInteger maxLen1 = maxLen + MIN(dec, 4);
        NSInteger subDec = maxLen1 - range.location;
        if (subDec > string.length)  //拼音输入时
            return YES;
        
        NSInteger saveLen = oldText.length;
        //单个红旗还是不行
        //NSRange decRange = [string rangeOfComposedCharacterSequenceAtIndex:maxLen - oldText.length];
        //if (decRange.location <= 0)
        //    return NO;
        //NSString *textStr = [string substringToIndex: ];
        
        NSString *textStr = [string substringToIndex: subDec];
        *deleteBackwarding  = maxLen - (oldText.length + textStr.length) > 1;  //还有一个字符时，要触发change事件;
        [textField insertText:textStr];
        
        NSString *sNewText = [inputTextView valueForKey:@"text"];
        
        while (sNewText && sNewText.length > maxLen) {
            sNewText = [inputTextView valueForKey:@"text"];
            *deleteBackwarding = sNewText.length - maxLen > 1;  //还有一个字符时，要触发change事件
            [textField deleteBackward];
            sNewText = [inputTextView valueForKey:@"text"];
        }
        
        if ([inputTextView isKindOfClass:[UITextView class]])
        {
            UITextView *textView = (UITextView*)inputTextView;
            range.location += textView.text.length - saveLen;
            range.length   = 0;
            [textView scrollRangeToVisible:range];
            textView.selectedRange = range;
        }
            
        return NO;
    }
    
    return YES;
}

- (void)textFieldValueDidChange:(UITextField *)textField
{
    if (_deleteBackwarding)
        return;
    if (_passWord || _numberOnly || !_inputEmoji || textField.text.length > _maxLen ||
        (_inputCharacters && _inputCharacters.length > 0))
    {
        NSString * newText = @"";
        UITextRange *markedTextRange = [textField markedTextRange];
        if (markedTextRange) ////拼音录入时,及联想录入时
        {
            self.preMarkedTextRange = markedTextRange; //unmarkText 会再触发 textFieldValueDidChange
            return;
        }
        
        if (_preMarkedTextRange)
        {
            newText         = [textField textInRange: _preMarkedTextRange];
            markedTextRange = _preMarkedTextRange;
        }
        else
        if (!markedTextRange && _checkMarkedRange.length > 0)
        {
            [HSUITextFieldObject textInput:textField
                        preMarkedTextRange:_preMarkedTextRange
                          checkMarkedRange:&_checkMarkedRange
                                 tickCount:&_tickCount
                              changedBlock:nil
                                    MaxLen:self.maxLen
                                NumberOnly:self.numberOnly
                                   Decimal:self.decimal
                                  PassWord:self.passWord
                                InputEmoji:self.inputEmoji
                           inputCharacters:_inputCharacters
                         deleteBackwarding:&_deleteBackwarding];
        }
        
        if (!markedTextRange)
        {
            return;
        }
        
        NSRange tRange = [HSUITextFieldObject textInput:textField textRange:markedTextRange];
        
        if (textField.text.length > _maxLen || (newText && newText.length > 0 &&
                                           (![HSUITextFieldObject textInput:textField
                                              shouldChangeCharactersInRange:tRange
                                                          replacementString:newText
                                                                     MaxLen:self.maxLen
                                                                 NumberOnly:self.numberOnly
                                                                    Decimal:self.decimal
                                                                   PassWord:self.passWord
                                                                 InputEmoji:self.inputEmoji
                                                            inputCharacters:_inputCharacters
                                                          deleteBackwarding:&_deleteBackwarding])))
        {
            //联想录入字符不对时，直接替换
            if (markedTextRange)
            {
                _deleteBackwarding = YES;
                [textField replaceRange:markedTextRange withText:@""];
                _deleteBackwarding = NO;
            }
            
            //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSInteger dec      = textField.text.length - _maxLen;
            if (dec <= 0)
            {
                self.preMarkedTextRange = nil;
                return;
            }
            _deleteBackwarding = YES;
            
            CGFloat sysVer = [[[UIDevice currentDevice] systemVersion] doubleValue];
            
            //多留4个字节，避免遇到4个字节的字符，如🇨🇳 可以用 rangeOfComposedCharacterSequencesForRange 判断，但考虑中间插入时，处理就比较麻烦了
            NSInteger maxLen = _maxLen + (sysVer >= 7.0 ? MIN(dec, 4) : 0);
            NSRange r = NSMakeRange(tRange.location, textField.text.length - maxLen);
            
            if (sysVer >= 7.0)
            {
                if (r.length > 0)
                {
                    UITextRange *textRange    = [HSUITextFieldObject textInput:textField range:r];
                    [textField replaceRange:textRange withText:@""];
                }
                
                //IOS6 在录入 中 英文混合时，这会死循环
                while (textField.text.length > _maxLen) {
                    [textField deleteBackward];     //有些特殊符号是4个字节，所以不能直接用replace,如🇨🇳
                }
            }
            else
            {
                NSMutableString *ms = [NSMutableString stringWithString:textField.text];
                [ms replaceCharactersInRange:r withString:@""];
                textField.text = ms;
                r.length = 0;
                textField.selectedTextRange = [HSUITextFieldObject textInput:textField range:r];
            }
            
            _deleteBackwarding = NO;
            //                if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldValueDidChange:)])
            //                    [self.delegate textFieldValueDidChange: self];
            //});
        }
        self.preMarkedTextRange = nil;
    }
}


+ (UITextRange *)textInput:(id<UITextInput>)textInput range:(NSRange)range
{
    UITextPosition *beginning = textInput.beginningOfDocument;
    UITextPosition *start     = [textInput positionFromPosition:beginning offset: range.location];
    UITextPosition *end       = [textInput positionFromPosition:start offset: range.length];
    UITextRange *textRange    = [textInput textRangeFromPosition:start toPosition:end];
    return textRange;
}

+ (NSRange)textInput:(id<UITextInput>)textInput textRange:(UITextRange *)textRange
{
    NSRange range;
    range.location = [textInput offsetFromPosition:textInput.beginningOfDocument toPosition:textRange.start];
    range.length   = [textInput offsetFromPosition:textRange.start toPosition:textRange.end];
    return range;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField addTarget:self action:@selector(textFieldValueDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

+ (NSInteger)textInput:(id<UITextInput>)textInput
                maxLen:(NSUInteger) maxLen
                 range:(NSRange)range
     replacementString:(NSString *)string
    preMarkedTextRange:(UITextRange *)preMarkedTextRange
      checkMarkedRange:(NSRange *)checkMarkedRange
             tickCount:(int64_t *)tickCount
{
    if (tickCount && *tickCount == INT64_MAX)
    {
        *checkMarkedRange = NSMakeRange(0, 0);
        return 0;
    }
    
    UIView *inputTextView = (UIView *)textInput;
    NSString *text = [inputTextView valueForKey:@"text"];
    NSInteger totalLen = text.length + string.length - range.length;
    if ((!textInput.markedTextRange && totalLen > maxLen && string && string.length > 0))
    {
        if (tickCount)
        {
            *tickCount = 1;
        }
        return 0;
    }
    NSRange saveRange;
    if (checkMarkedRange)
    {
        saveRange =*checkMarkedRange;
        *checkMarkedRange = NSMakeRange(0, 0);
    }

    if (string.length == 1 && (!preMarkedTextRange || textInput.markedTextRange)) //拼音，手写 第一次录入 都要先返回YES
    {
        int64_t tick = 0;
        if (tickCount)
        {
            if (*tickCount > 0)
            {
                tick = [Comm tickCount] - *tickCount;
            }
            *tickCount = [Comm tickCount];
        }
        
        UIResponder *responder = (UIResponder *)textInput;
        UITextInputMode *textInputMode = nil;
        if (responder && [textInput respondsToSelector:@selector(textInputMode)])
            textInputMode = [responder textInputMode];
        else
            textInputMode = [UITextInputMode currentInputMode];
        NSString *lang   = [textInputMode primaryLanguage];
        NSString *layout = [textInputMode valueForKey:@"softwareLayout"]; //Pinyin10-Simplified 九宫格
        //判断输入法 这判断输入法比较不合理，应该是判断 输入法有没有打开 联想，如果有就要先return YES
        if ([lang isEqualToString:@"zh-Hans"] && [layout rangeOfString:@"10"].length > 0) {
            unichar c = [string characterAtIndex:0]; //录入拼音才会去markedText
            BOOL alpha = isalpha(c); //c >= 'A' && c <= 'z'
            //@"➋➌➍➎➏➐➑➒"
            if (alpha || (0x2100 <= c && c <= 0x27ff))
            {
                //录入单个字母时，要在didChanged去再做判断
                if (checkMarkedRange && alpha && !preMarkedTextRange && textInput.markedTextRange == nil)
                {
                    //开始录入字母时
                    if (saveRange.length == 0 || saveRange.location == range.location)
                    {
                        *checkMarkedRange = NSMakeRange(range.location, saveRange.length ? : 1);
                    }
                    else
                    {
                        //连续按同一个键时。 在1秒内c为上次pc+1
                        unichar pc = [text characterAtIndex:saveRange.location];
                        if (tick > 0 && tick <= 1000 && range.location == saveRange.location + 1 && range.length == 0 && c == pc + 1)
                        {
                            *checkMarkedRange = saveRange;
                        }
                        else
                        {
                            //不同按键时，字符串追加
                            *checkMarkedRange = NSMakeRange(saveRange.location, range.location - saveRange.location + 1);
                        }
                    }
                }
                return 1;
            }
        }
    }
    return -1;
}

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
deleteBackwarding:(BOOL *)deleteBackwarding
{
    NSRange save = *checkMarkedRange;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([Comm tickCount] - *tickCount < 1000)
        {
            return;
        }
        
        NSRange range = *checkMarkedRange;
        if (range.length <= 0) range = save;
        
        UITextRange *markedTextRange = [HSUITextFieldObject textInput:textField range:range];
        UIView *inputView = (UIView *)textField;
        NSString *text = [inputView valueForKey:@"text"];
        if (range.length == 0 || NSMaxRange(range) > text.length)
            return;
        //九营格 中文输入法，快速 录入英文切换字母时，会取全部录入的字符 _checkMarkedRange.location为text的length
        NSString *newText         = [textField textInRange: markedTextRange];
        if (newText && newText.length > 0 && newText.length == range.length &&
            (![HSUITextFieldObject textInput:textField
               shouldChangeCharactersInRange:range
                           replacementString:newText
                                      MaxLen:maxLen
                                  NumberOnly:numberOnly
                                     Decimal:decimal
                                    PassWord:passWord
                                  InputEmoji:inputEmoji
                             inputCharacters:inputCharacters
                           deleteBackwarding:deleteBackwarding]))
        {
            //联想录入字符不对时，直接替换
            if (markedTextRange)
            {
                *tickCount = INT64_MAX;
                UIWindow *win = [UIApplication sharedApplication].windows.lastObject;
                UIView *backView = [[UIView alloc] initWithFrame:win.frame];
                backView.backgroundColor = [UIColor clearColor];
                backView.userInteractionEnabled = YES;
                [win addSubview:backView];
#if !__has_feature(objc_arc)
                [backView release];
#endif
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (*tickCount == INT64_MAX)
                    {
                        *tickCount = 0;
                        *checkMarkedRange = NSMakeRange(0, 0);
                    }
                    [backView removeFromSuperview];
                });
                
                *deleteBackwarding = YES;
                [textField replaceRange:markedTextRange withText:@""];
                *deleteBackwarding = NO;
                if (changedBlock)
                {
                    changedBlock();
                }
            }
        }
    });
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger check = [[self class] textInput:textField
                                       maxLen:_maxLen
                                        range:range
                            replacementString:string
                           preMarkedTextRange:_preMarkedTextRange
                             checkMarkedRange:&_checkMarkedRange
                                     tickCount:&_tickCount];
    if (check >= 0)
    {
        return check > 0;
    }

    return [[self class] textInput:textField
     shouldChangeCharactersInRange:range
                 replacementString:string
                            MaxLen:_maxLen
                        NumberOnly:_numberOnly
                           Decimal:_decimal
                          PassWord:_passWord
                        InputEmoji:_inputEmoji
            inputCharacters:_inputCharacters
            deleteBackwarding:&_deleteBackwarding
            ];
}


@end

@interface HSUITextField()
<UITextFieldDelegate>
{
    id<HSUITextFieldDelegate> _delegate;
    BOOL _deleteBackwarding;
}

//记录上次录入需要确认的内容，如：录入拼音、联想录入
@property (nonatomic, copy)   UITextRange *preMarkedTextRange;
//记录中文输入法 九宫格录入英文字母A-z的区间
@property (nonatomic, assign) NSRange checkMarkedRange;

@property (nonatomic, assign) int64_t tickCount;

@end

@implementation HSUITextField

@dynamic delegate;

- (id)init
{
    self = [super init];
    if (self) {
        [self doInitValues];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self doInitValues];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self doInitValues];
    }
    return self;
}

- (void)doInitValues
{
    _maxLen     = 400;
    _numberOnly = NO;
    _decimal    = 2;
    _passWord   = NO;
    
    _inputEmoji = NO;
    _focusLineWidth = 0;
    
    super.text = @"";  //IOS 6.0 初始化为 空字符串
    
    [super setDelegate:self];
    
    //关闭纠错  纠错行 向UITextField插入内容时，没有maskedRange，
    //也不会触发 textFieldShouldChangeCharactersInRange
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [self addTarget:self action:@selector(textFieldValueDidChange:) forControlEvents:UIControlEventEditingChanged];
}


- (void)dealloc
{
    self.inputCharacters = nil;
    self.preMarkedTextRange = nil;
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

//- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange
//{
//    [super setMarkedText:markedText selectedRange:selectedRange];
//}
//
//- (void)unmarkText
//{
//    [super unmarkText];
//}

- (void)textFieldValueDidChange:(id *)sender
{
    if (_deleteBackwarding)
        return;
    if (_passWord || _numberOnly || !_inputEmoji || self.text.length > _maxLen ||
        (_inputCharacters && _inputCharacters.length > 0))
    {
        NSString * newText = @"";
        UITextRange *markedTextRange = [self markedTextRange];
        if (markedTextRange) ////拼音录入时,及联想录入时
        {
            self.preMarkedTextRange = markedTextRange; //unmarkText 会再触发 textFieldValueDidChange
            return;
        }
        if (_preMarkedTextRange)
        {
            newText = [self textInRange: _preMarkedTextRange];
            markedTextRange = _preMarkedTextRange;
        }
        else
        if (!markedTextRange && _checkMarkedRange.length > 0)
        {
            [HSUITextFieldObject textInput:self
                        preMarkedTextRange:_preMarkedTextRange
                          checkMarkedRange:&_checkMarkedRange
                                 tickCount:&_tickCount
                              changedBlock:^{
                                  if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldValueDidChange:)])
                                      [self.delegate textFieldValueDidChange: self];
                              } MaxLen:self.maxLen
                                NumberOnly:self.numberOnly
                                   Decimal:self.decimal
                                  PassWord:self.passWord
                                InputEmoji:self.inputEmoji
                           inputCharacters:_inputCharacters
                         deleteBackwarding:&_deleteBackwarding];
        }
        
        if (!markedTextRange)
        {
            goto finished;
//            return;
        }
        
        NSRange tRange = [HSUITextFieldObject textInput:self textRange:markedTextRange];
    
        if (self.text.length > _maxLen || (newText && newText.length > 0 &&
                                           (![HSUITextFieldObject textInput:self
                                              shouldChangeCharactersInRange:tRange
                                                          replacementString:newText
                                                                     MaxLen:self.maxLen
                                                                 NumberOnly:self.numberOnly
                                                                    Decimal:self.decimal
                                                                   PassWord:self.passWord
                                                                 InputEmoji:self.inputEmoji
                                                            inputCharacters:_inputCharacters
                                                          deleteBackwarding:&_deleteBackwarding])))
        {
            //联想录入字符不对时，直接替换
            if (markedTextRange)
            {
                _deleteBackwarding = YES;
                NSLog(@"did change3: %@", self.text);
                [self replaceRange:markedTextRange withText:@""];
                NSLog(@"did change4: %@", self.text);
                _deleteBackwarding = NO;
            }
        
            //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSInteger dec      = self.text.length - _maxLen;
                if (dec <= 0)
                {
                    self.preMarkedTextRange = nil;
                    goto finished;
                    return;
                }
                _deleteBackwarding = YES;
            
                CGFloat sysVer = [[[UIDevice currentDevice] systemVersion] doubleValue];
            
                //多留4个字节，避免遇到4个字节的字符，如🇨🇳 可以用 rangeOfComposedCharacterSequencesForRange 判断，但考虑中间插入时，处理就比较麻烦了
                NSInteger maxLen = _maxLen + (sysVer >= 7.0 ? MIN(dec, 4) : 0);
                NSRange r = NSMakeRange(tRange.location, self.text.length - maxLen);
            
                if (sysVer >= 7.0)
                {
                    if (r.length > 0)
                    {
                        UITextRange *textRange    = [HSUITextFieldObject textInput:self range:r];
                        [self replaceRange:textRange withText:@""];
                    }
                    
                    //IOS6 在录入 中 英文混合时，这会死循环
                    while (self.text.length > _maxLen) {
                        [self deleteBackward];     //有些特殊符号是4个字节，所以不能直接用replace,如🇨🇳
                    }
                }
                else
                {
                    NSMutableString *ms = [NSMutableString stringWithString:self.text];
                    [ms replaceCharactersInRange:r withString:@""];
                    self.text = ms;
                    r.length = 0;
                    self.selectedTextRange = [HSUITextFieldObject textInput:self range:r];
                }
            
                _deleteBackwarding = NO;
//                if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldValueDidChange:)])
//                    [self.delegate textFieldValueDidChange: self];
            //});
        }
        else
        {
            _checkMarkedRange.length = 0;
        }
        self.preMarkedTextRange = nil;
    }
    
finished:
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldValueDidChange:)])
        [self.delegate textFieldValueDidChange: self];   
}


- (BOOL)textFieldShouldChangeCharactersInRange:(NSRange)range
                             replacementString:(NSString *)string
{
    NSInteger check = [HSUITextFieldObject textInput:self
                                              maxLen:_maxLen
                                               range:range
                                   replacementString:string
                                  preMarkedTextRange:_preMarkedTextRange
                                    checkMarkedRange:&_checkMarkedRange
                                            tickCount:&_tickCount];
    if (check >= 0) {
        return check > 0;
    }

    return [HSUITextFieldObject textInput:self
            shouldChangeCharactersInRange:range
                        replacementString:string
                                   MaxLen:_maxLen
                               NumberOnly:_numberOnly
                                  Decimal:_decimal
                                 PassWord:_passWord
                               InputEmoji:_inputEmoji
                          inputCharacters:_inputCharacters
                        deleteBackwarding:&_deleteBackwarding
            ];
}

- (void)setMaxLen:(NSUInteger)maxLen
{
    if (maxLen <= 0 || maxLen >= INT_MAX)
        maxLen = 1;
    _maxLen = maxLen;
    if (self.text && self.text.length > _maxLen)
    {
        NSRange rangeIndex = [self.text rangeOfComposedCharacterSequenceAtIndex:_maxLen];
        //删除多出来的部份
        NSRange delRange = NSMakeRange(rangeIndex.location, self.text.length - rangeIndex.location);
        UITextRange *textRange = [HSUITextFieldObject textInput:self range:delRange];
        [self replaceRange:textRange withText:@""];
    }
}

- (void)setDecimal:(Byte)decimal
{
    _decimal = decimal;
    if (_decimal > 0 && !_numberOnly)
        [self setNumberOnly:YES];
}

- (void)setNumberOnly:(BOOL)numberOnly
{
    _numberOnly = numberOnly;
    if (_numberOnly)
    {
        if (_maxLen > 19)
            _maxLen = 19;
        [self setKeyboardType: _decimal > 0 ? UIKeyboardTypeDecimalPad : UIKeyboardTypeNumberPad];
    }
    //UIKeyboardTypeNumbersAndPunctuation; // UIKeyboardTypeNumberPad;
}

- (void)setPassWord:(BOOL)passWord
{
    if (passWord)
    {
        if (_maxLen > 20)
            _maxLen = 20;
        else
            if (_maxLen < 6)
                _maxLen = 6;
        [self setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    }
    self.secureTextEntry = passWord;
    _passWord = passWord;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    if (_numberOnly)
    {
        keyboardType = _decimal > 0 ? UIKeyboardTypeDecimalPad : UIKeyboardTypeNumberPad;
    }
    else
    if (_passWord)
        keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    if(keyboardType == UIKeyboardTypeNumberPad || keyboardType == UIKeyboardTypeDecimalPad)
    {
        [self setKeyboard:keyboardType];
    } else {
        [super setKeyboardType:keyboardType];
    }
}

- (void)setKeyboard:(UIKeyboardType)keyboardType
{
    RYNumberKeyboard *tNumberKb = [[RYNumberKeyboard alloc] init];
    tNumberKb.textFiled = self;
    tNumberKb.keyboardType = keyboardType;
    tNumberKb.maxLen = _maxLen;
    tNumberKb.decimal = _decimal;
    __weak typeof(self) wSelf = self;
    [tNumberKb setTextDidChangeBlock:^(UITextField *textField){
        if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(textFieldValueDidChange:)])
            [wSelf.delegate textFieldValueDidChange: textField];
    }];
    self.inputView = tNumberKb;
}

- (void)setDelegate:(id<HSUITextFieldDelegate>)delegate
{
    _delegate = delegate;
}

- (id<HSUITextFieldDelegate>)delegate
{
    return _delegate;
}

- (void)setFocusLineWidth:(CGFloat)focusLineWidth
{
    _focusLineWidth = focusLineWidth;
    [self addFocusLineWidthAndFocused:self.isFirstResponder];
}

- (void)addFocusLineWidthAndFocused:(BOOL)focused
{
    if (_focusLineWidth > 0 && self.frame.size.width > 0)
    {
        [self addFocusLineWithFocused:focused
                                Width:_focusLineWidth <= self.frame.size.width ? self.frame.size.width : _focusLineWidth];
    }
}

/* 选中文字后的菜单响应的选项 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    if (action == @selector(copy:)) { // 菜单不能响应copy项
//        return NO;
//    }
//    else if (action == @selector(selectAll:)) { // 菜单不能响应select all项
//        return NO;
//    }
    
    //录入密码时，不允许复制
    if (action == @selector(copy:) && (self.secureTextEntry || self.passWord))
        return NO;
    /*
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    if (action == @selector(paste:) && pboard.string && pboard.string.length > 0)
    {
        //密码 不录入中文
        if (self.passWord || !self.inputEmoji || self.numberOnly) //
        {
            __block BOOL returnValue = YES;
            [pboard.string enumerateSubstringsInRange:NSMakeRange(0, [pboard.string length])
                                       options:NSStringEnumerationByComposedCharacterSequences
                                    usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                        
                                        unichar ch = [substring characterAtIndex:0];
                                        //46:.  48:0  57:9  47: /
                                        if (self.numberOnly && ((ch < 46 || ch > 57 || ch == 47) ||
                                                                (self.decimal <= 0 && ch == 46)))
                                        {
                                            returnValue = NO;
                                            *stop = YES;
                                        }
                                        else
                                        if (self.passWord && (ch < 20 || ch >= 127))
                                        {
                                            returnValue = NO;
                                            *stop = YES;
                                        }
                                        else
                                            if (!self.inputEmoji && [HSUITextFieldObject stringContainsEmoji:substring])
                                            {
                                                returnValue = NO;
                                                *stop = YES;
                                            }
                                    }];
            return returnValue;
        }
    }
     */
    // 事实上一个return NO就可以将系统的所有菜单项全部关闭了
    return [super canPerformAction:action withSender:sender];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    UIViewController *vc = [self viewController];
    if (vc && [vc respondsToSelector: @selector(textFieldBeginEditingAndSetInputView:)])
        [vc performSelectorOnMainThread: @selector(textFieldBeginEditingAndSetInputView:)
                             withObject: textField
                          waitUntilDone: YES];

    if (_delegate && [_delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)])
        return [_delegate textFieldShouldBeginEditing: textField];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    if (_focusLineWidth > 0 && self.frame.size.width > 0)
        [self addFocusLineWidthAndFocused:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
        [_delegate textFieldDidBeginEditing:textField];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
{
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldShouldEndEditing:)])
        return [_delegate textFieldShouldEndEditing:textField];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
    if (_focusLineWidth > 0 && self.frame.size.width > 0)
        [self addFocusLineWidthAndFocused:NO];
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDidEndEditing:)])
        [_delegate textFieldDidEndEditing:textField];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
{
    if (textField != self)
        return NO;
    BOOL result = [self textFieldShouldChangeCharactersInRange:range
                                             replacementString:string];
    if (result && _delegate && [_delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
        result = [_delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    return result;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField               // called when clear button pressed. return NO to ignore (no notifications)
{
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldShouldClear:)])
        [_delegate textFieldShouldClear:textField];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    BOOL result = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldShouldReturn:)])
        result = [_delegate textFieldShouldReturn:textField];
    
    //默认关闭键盘
    if ([textField isFirstResponder] &&
        textField.returnKeyType != UIReturnKeyNext &&
        textField.returnKeyType != UIReturnKeyContinue)
    {
        [textField resignFirstResponder];
    }
    
    return result;
}

//有些设备会卡死
- (id)customOverlayContainer {
    return self;
}


@end

@implementation UITextField (Empty)

//判断文本框是否为空
- (BOOL)isEmpty
{
    return  !self.text || [self.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
}

@end

@implementation HSUITextField (InputCharacters)

//设置只录入数字与字母
- (void)setAlphaNumberInputCharacters
{
    self.inputCharacters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
}

//设置身份证号
- (void)setCardNumberInputCharacters
{
    self.inputCharacters = @"0123456789Xx";
    self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
}


@end

@implementation UITextField (LXExtension)

/** 通过这个属性名，就可以修改textField内部的占位文字颜色 */
static NSString *const kPlaceholderColorKeyPath = @"placeholderLabel.textColor";

static UIColor *kPlaceholderColorDefault;

/**
 *  设置占位文字颜色
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    // 这3行代码的作用：1> 保证创建出placeholderLabel，2> 保留曾经设置过的占位文字
    NSString *placeholder = self.placeholder;
    self.placeholder = @" ";
    self.placeholder = placeholder;
    
    if (!kPlaceholderColorDefault)
    {
        kPlaceholderColorDefault = [self valueForKeyPath:kPlaceholderColorKeyPath];
    }
    
    // 处理xmg_placeholderColor为nil的情况：如果是nil，恢复成默认的占位文字颜色
    if (!placeholderColor) {
        placeholderColor = kPlaceholderColorDefault;
    }
    
    // 设置占位文字颜色
    [self setValue:placeholderColor forKeyPath:kPlaceholderColorKeyPath];
}

/**
 *  获得占位文字颜色
 */
- (UIColor *)placeholderColor
{
    return [self valueForKeyPath:kPlaceholderColorKeyPath];
}

- (void)setPointColor:(UIColor *)pointColor
{
    if ([self respondsToSelector:@selector(textInputTraits)])
    {
        id val = [self valueForKey:@"textInputTraits"];
        [val setValue:[UIColor greenColor] forKey:@"insertionPointColor"];
    }
}

- (UIColor *)pointColor
{
    if ([self respondsToSelector:@selector(textInputTraits)])
    {
        id val = [self valueForKey:@"textInputTraits"];
        return [val valueForKey:@"insertionPointColor"];
    }
    else
    {
        //0.26 0.42 0.95 1
        return [UIColor colorWithRed:0.26 green:0.42 blue:0.95 alpha:1];
    }
}

@end
