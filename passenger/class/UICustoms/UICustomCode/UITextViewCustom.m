//
//  UITextViewCustom.m
//  navViewController
//
//  Created by 邱家楗 on 16/1/20.
//  Copyright © 2016年 邱家楗. All rights reserved.
//

#import "UITextViewCustom.h"
#import "HSUITextField.h"
#import "UIView+Category.h"

#define DEVICE_OS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue] //获取版本号

@interface UITextViewCustom()
<UITextViewDelegate>
{
#if !__has_feature(objc_arc)
    __unsafe_unretained id<UITextViewCustomDelegate> _delegate;
#else
    __weak id<UITextViewCustomDelegate> _delegate;
#endif
    
    NSUInteger _saveTextLen;
}

//记录上次录入需要确认的内容，如：录入拼音、联想录入
@property (nonatomic, copy) UITextRange *preMarkedTextRange;

//记录中文输入法 九宫格录入英文字母A-z的区间
@property (nonatomic, assign) NSRange checkMarkedRange;
@property (nonatomic, assign) int64_t tickCount;

@end

@implementation UITextViewCustom

@dynamic delegate;

- (id)init
{
    self = [super init];
    if (self) {
        [self doInitValues];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self doInitValues];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self doInitValues];
    }
    return self;
}

-(void)doInitValues
{
    _maxLen            = 8000;
    _inputEmoji        = YES;
    _saveTextLen       = 0;
    _deleteBackwarding = NO;
    _autoHeightMinLine = 1;
    _autoHeightMaxLine = 1;
    _autoHeightMinHeight = 0;
    
    self.placeholder      = nil;
    self.placeholderColor = nil;
    
    //UITextView 追加文字自动跳到顶部解决方法
    if ([self respondsToSelector:@selector(layoutManager)])
        self.layoutManager.allowsNonContiguousLayout = NO;

    [super setDelegate:self];
    
    //关闭纠错  纠错行 向UITextField插入内容时，没有maskedRange，
    //也不会触发 textFieldShouldChangeCharactersInRange
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    
//    if (DEVICE_OS_VERSION < 7.0)
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(textViewDidChange:)
//                                                     name:UITextViewTextDidChangeNotification
//                                                   object:self];
}

-(void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super setDelegate:nil];
    
    self.delegate         = nil;
    self.placeholder      = nil;
    self.placeholderColor = nil;
    self.preMarkedTextRange = nil;
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(void)insertText:(NSString *)text
{
    [super insertText:text];
    if (DEVICE_OS_VERSION < 7.0)
        [self textViewDidChange:self];
}

-(void)setText:(NSString *)text
{
    [super setText:text];
    [self textViewDidChange:self];
}

- (void)replaceRange:(UITextRange *)range withText:(NSString *)text
{
    [super replaceRange:range withText:text];
    if (DEVICE_OS_VERSION < 7.0)
        [self textViewDidChange:self];
}

-(void)setMaxLen:(NSUInteger)maxLen
{
    if (maxLen <= 0)
        maxLen = 1;
    
    if (maxLen >= LONG_MAX)
        maxLen = 8000;
    
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

-(void)setDelegate:(id<UITextViewCustomDelegate>)delegate
{
    _delegate = delegate;
}

//给当前类属性获得, 如果不这样做，对像在外部永远获到不到_delegate
-(id<UITextViewCustomDelegate>)getDelegate
{
    return _delegate;
}

//由于UITextView 继承UIScrollView，已经@dynamic, 所以此方法已经生成
-(id<UITextViewDelegate>)delegate
{
    return [super delegate];
}

#pragma mark placeholder
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if ([self hasText] || !_placeholder || _placeholder.length == 0)
        return;
    
    UIColor *placeholderColor = self.placeholderColor ?  : [[UIColor grayColor] colorWithAlphaComponent:0.7];
    UIFont  *placeholderFont  = self.font ? self.font : [UIFont systemFontOfSize:14];
    if (DEVICE_OS_VERSION >= 8.0)
    {
        NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = placeholderColor;
        attrs[NSFontAttributeName]            = placeholderFont;
        attrs[NSAttachmentAttributeName]      = [NSNumber numberWithInt: self.textAlignment];
        
        CGRect placeholderRect = self.frame;
        placeholderRect.origin = CGPointZero;
        if ([self respondsToSelector:@selector(textContainerInset)])
        {
            placeholderRect = UIEdgeInsetsInsetRect(placeholderRect, self.textContainerInset);
            if (placeholderRect.origin.x <= 0)
                placeholderRect.origin.x += 5;
        }
        //IOS7 会闪退
        [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
    }
    else
    {
        [placeholderColor setFill];
        CGFloat y = (self.frame.size.height - placeholderFont.lineHeight) * 0.5;
        [self.placeholder drawAtPoint:CGPointMake(5, y) withFont: placeholderFont];
    }
}

//有些设置会卡死
- (id)customOverlayContainer {
    return self;
}

/* 选中文字后的菜单响应的选项 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    //    if (action == @selector(copy:)) { // 菜单不能响应copy项
    //        return NO;
    //    }
    //    else if (action == @selector(selectAll:)) { // 菜单不能响应select all项
    //        return NO;
    //    }
    //    NSLog(@"%@", NSStringFromSelector(action));
    // 事实上一个return NO就可以将系统的所有菜单项全部关闭了
    return [super canPerformAction:action withSender:sender];
}

//切断超出长度部份
-(void)cutOutLenString
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
                              changedBlock:nil
                                    MaxLen:self.maxLen
                                NumberOnly:NO
                                   Decimal:0
                                  PassWord:NO
                                InputEmoji:self.inputEmoji
                           inputCharacters:nil
                         deleteBackwarding:&_deleteBackwarding];
        }
    
    if (!markedTextRange)
        return;
    
    NSRange tRange = [HSUITextFieldObject textInput:self textRange:markedTextRange];    
    
    if (self.text.length > _maxLen || (newText && newText.length > 0 && ! [HSUITextFieldObject textInput:self
                                                                           shouldChangeCharactersInRange:tRange
                                                                                       replacementString:newText
                                                                                                  MaxLen:(int)self.maxLen
                                                                                              NumberOnly:NO
                                                                                                 Decimal:0
                                                                                                PassWord:NO
                                                                                              InputEmoji:self.inputEmoji
                                                                           inputCharacters:nil
                                                                           deleteBackwarding:&_deleteBackwarding])) {
        //联想录入字符不对时，直接替换
        if (markedTextRange)
        {
            _deleteBackwarding = YES;
            [self replaceRange:markedTextRange withText:@""];
            _deleteBackwarding = NO;
        }
        
        NSInteger dec           = self.text.length - _maxLen;
        if (dec > 0)
        {
            _deleteBackwarding = YES;
            //多留4个字节，避免遇到4个字节的字符，如🇨🇳
            NSInteger maxLen        = _maxLen + MIN(dec, 4);
            
            NSRange r = NSMakeRange(tRange.location, self.text.length - maxLen);
            if (r.length > 0)
            {
                UITextRange *textRange    = [HSUITextFieldObject textInput:self range:r];
                [self replaceRange:textRange withText:@""];
            }
            
            while (self.text.length > _maxLen) {
                [self deleteBackward];  //有些特殊符号是4个字节，所以不能直接用replace,如🇨🇳
            }
            
            _deleteBackwarding = NO;
        }
        if (self.text.length == 0)
            [self setNeedsDisplay];
        
        //            如果中间插入的话，会把最后面的内容切掉
        //            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:_maxLen];
        //            //删除多出来的部份
        //            NSRange delRange = NSMakeRange(rangeIndex.location, toBeString.length - rangeIndex.location);
        //            self.selectedRange = delRange;
        //            [self replaceRange:self.selectedTextRange withText:@""];
        //            delRange.length = 0;
        //            [self scrollRangeToVisible: delRange];
        
    }
    self.preMarkedTextRange = nil;
}

- (BOOL)selfShouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger check = [HSUITextFieldObject textInput:self
                                              maxLen:_maxLen
                                               range:range
                                   replacementString:text
                                  preMarkedTextRange:_preMarkedTextRange
                                    checkMarkedRange:&_checkMarkedRange
                                           tickCount:&_tickCount];
    if (check >= 0) {
        return check > 0;
    }
    return [HSUITextFieldObject textInput:self
            shouldChangeCharactersInRange:range
                        replacementString:text
                                   MaxLen:(int)_maxLen
                               NumberOnly:NO
                                  Decimal:0
                                 PassWord:NO
                               InputEmoji:_inputEmoji
                          inputCharacters:nil
                        deleteBackwarding:&_deleteBackwarding
            ];
    /*
    if (!text || text.length == 0)  //删除
        return YES;
    if (!self.inputEmoji && text.length > 0)
    {
        UITextInputMode *textInputMode = nil;
        if ([self respondsToSelector:@selector(textInputMode)])
        {
            textInputMode = [self textInputMode];  //表情录入时 反回nil
            if (!textInputMode)
                return NO;
        }//IOS 6
        else
            textInputMode = [UITextInputMode currentInputMode];
        
        if (textInputMode && [textInputMode.primaryLanguage isEqualToString:@"emoji"])
            return NO;
        
        //IOS 9 九宫格拼音简体输入法
        if (text && text.length == 1 && [textInputMode respondsToSelector:@selector(normalizedIdentifier)] && [textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            NSString *sIdentifier = [textInputMode valueForKey:@"normalizedIdentifier"];
            if (sIdentifier && [sIdentifier isEqualToString:@"zh_Hans-Pinyin"])
            {
                const unichar hs = [text characterAtIndex:0];
                if (0x2100 <= hs && hs <= 0x27ff) ////❶❷❸❹❺
                    return YES;
            }
        }

        __block BOOL returnValue = YES;
        [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                 options:NSStringEnumerationByComposedCharacterSequences
                              usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                  
                                  //                                        unichar ch = [substring characterAtIndex:0];
                                  
                                  if (!self.inputEmoji && [HSUITextFieldObject stringContainsEmoji:substring])
                                  {
                                      returnValue = NO;
                                      *stop = YES;
                                  }
                              }];
        if (!returnValue)
            return returnValue;
//        return returnValue;
    }

    //粘贴过长字符时,返回FALSE  这些属性 都是NSUInteger 有 相减 运算,要转为 NSInteger
    NSInteger len = range.location + text.length - range.length;
    
    if (len > 0 && (len > _maxLen || (self.text.length > 0 && self.text.length + text.length - range.length > _maxLen)))
    {
        NSInteger dec           = len - _maxLen;
        NSInteger maxLen        = _maxLen + MIN(dec, 4);
        NSString *textStr       = [text substringToIndex: maxLen - range.location];
        
        _deleteBackwarding = self.text.length - _maxLen > 1;  //还有一个字符时，要触发change事件;
        NSInteger saveLen = self.text.length;
        [self insertText:textStr];
        while (self.text.length > _maxLen) {
            _deleteBackwarding = self.text.length - _maxLen > 1;  //还有一个字符时，要触发change事件
            [self deleteBackward];
        }
        NSRange r = NSMakeRange(range.location + self.text.length - saveLen, 0);
        [self scrollRangeToVisible: r];
        self.selectedRange = r;
        return NO;
    }
    return YES;
    */
}

-(void)autoResetHeight
{
    if (_autoHeightMinLine <= 0 || _autoHeightMinLine >= _autoHeightMaxLine)
        return;
    CGRect r = self.frame;
    CGFloat lineHeight   = self.font.lineHeight;
    if (lineHeight <= 0)
        return;
    CGFloat borderHeight = 0; //self.textContainerInset.top;// + self.textContainerInset.bottom;
    
    CGSize size          = [self sizeThatFits:CGSizeMake(self.frame.size.width, 80000.0f)];
    
    if (size.height > lineHeight * _autoHeightMaxLine + borderHeight)
        size.height = lineHeight * _autoHeightMaxLine + borderHeight;
    
    if (size.height < lineHeight * _autoHeightMinLine + borderHeight)
        size.height = lineHeight * _autoHeightMinLine + borderHeight; //inputTextHeight;
    if (_autoHeightMinHeight > 0 && size.height < _autoHeightMinHeight)
        size.height = _autoHeightMinHeight;
    
    if (size.height != r.size.height)
    {
        r.size.height = size.height;
        
        [UIView animateWithDuration:0.15 animations:^{
            self.frame = r;
            if (_delegate && [_delegate respondsToSelector:@selector(textViewDidChangeHeight:)])
                [_delegate textViewDidChangeHeight:self];
        }completion:^(BOOL finished) {
            if (finished)
            {
                self.frame = r;
                if (self.selectedRange.location == self.text.length)
                {
//                    CGPoint point = self.contentOffset;
//                    point.y = self.contentSize.height - r.size.height + self.textContainerInset.bottom;
//                    self.contentOffset = point;
                }
                if (_delegate && [_delegate respondsToSelector:@selector(textViewDidChangeHeight:)])
                    [_delegate textViewDidChangeHeight:self];
            }
        }];
    }
    else
    {
        if (self.selectedRange.location == self.text.length)
        {
//            CGPoint point = self.contentOffset;
//            point.y = self.contentSize.height - r.size.height; // + self.textContainerInset.bottom;
//            self.contentOffset = point;
        }
        //self.frame = r;
        //[self updateShowSendAndOther:s];
    }
    //[self scrollRangeToVisible:self.selectedRange];
}


-(void)setPlaceholder:(NSString *)placeholder
{
#if !__has_feature(objc_arc)
    if (_placeholder)
        [_placeholder release];
#endif

    _placeholder = [placeholder copy];
    if (placeholder)
        [self autoResetHeight];
    
    [self setNeedsDisplay];
}


#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    UIViewController *vc = [self viewController];
    if (vc && [vc respondsToSelector: @selector(textFieldBeginEditingAndSetInputView:)])
        [vc performSelectorOnMainThread: @selector(textFieldBeginEditingAndSetInputView:)
                             withObject: textView
                          waitUntilDone: YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(textViewShouldBeginEditing:)])
        return [_delegate textViewShouldBeginEditing: textView];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (_delegate && [_delegate respondsToSelector:@selector(textViewShouldEndEditing:)])
        return [_delegate textViewShouldEndEditing: textView];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (_delegate && [_delegate respondsToSelector:@selector(textViewDidBeginEditing:)])
        [_delegate textViewDidBeginEditing: textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (_delegate && [_delegate respondsToSelector:@selector(textViewDidEndEditing:)])
        [_delegate textViewDidEndEditing: textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView != self)
        return YES;
    
    BOOL result = [self selfShouldChangeTextInRange:range
                                    replacementText:text];
    
    if (_delegate && [_delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)])
    {
        //聊天 发送，是录入换行符的
        if (result || [text isEqualToString:@"\n"])
        {
            result =  [_delegate textView:textView shouldChangeTextInRange:range replacementText:text];
        }
    }
    return result;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView != self || _deleteBackwarding)
        return;
    
    if (_saveTextLen != self.text.length && (_saveTextLen == 0 || self.text.length == 0))
    {
        [self setNeedsDisplay];
    }
    
    [self cutOutLenString];
    
    [self autoResetHeight];
//    [self scrollRectToVisible:[self firstRectForRange:self.selectedTextRange] animated:NO];
    NSRange range = textView.selectedRange;
    [textView scrollRangeToVisible:range];

    _saveTextLen = self.text.length;
    
    if (_delegate && [_delegate respondsToSelector:@selector(textViewDidChange:)])
        [_delegate textViewDidChange: textView];
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (_delegate && [_delegate respondsToSelector:@selector(textViewDidChangeSelection:)])
        [_delegate textViewDidChangeSelection: textView];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if (_delegate && [_delegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)])
        return [_delegate textView:textView shouldInteractWithURL:URL inRange:characterRange];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    if (_delegate && [_delegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)])
        return [_delegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    return YES;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView                                               // any offset changes
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [_delegate scrollViewDidScroll: scrollView];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView // any zoom scale changes
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidZoom:)])
        [_delegate scrollViewDidZoom: scrollView];
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
        [_delegate scrollViewWillBeginDragging: scrollView];
}

// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
        [_delegate scrollViewWillEndDragging: scrollView withVelocity: velocity targetContentOffset: targetContentOffset];
}

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [_delegate scrollViewDidEndDragging: scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView   // called on finger up as we are moving
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
        [_delegate scrollViewWillBeginDecelerating: scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView      // called when scroll view grinds to a halt
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [_delegate scrollViewDidEndDecelerating: scrollView];
}

 // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
        [_delegate scrollViewDidEndScrollingAnimation: scrollView];
}

// return a view that will be scaled. if delegate returns nil, nothing happens
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(viewForZoomingInScrollView:)])
        return [_delegate viewForZoomingInScrollView: scrollView];
    return nil;
}

// called before the scroll view begins zooming its content
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
        [_delegate scrollViewWillBeginZooming: scrollView withView: view];
}

// scale between minimum and maximum. called after any 'bounce' animations
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
        [_delegate scrollViewDidEndZooming: scrollView withView: view atScale: scale];
}

// return a yes if you want to scroll to the top. if not defined, assumes YES
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
        return [_delegate scrollViewShouldScrollToTop: scrollView];
    return NO;
}

// called when scrolling animation finished. may be called immediately if already at top
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
        [_delegate scrollViewDidScrollToTop: scrollView];
}


@end
