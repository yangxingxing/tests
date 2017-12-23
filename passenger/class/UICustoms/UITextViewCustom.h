//
//  UITextViewCustom.h
//  navViewController
//
//  Created by 邱家楗 on 16/1/20.
//  Copyright © 2016年 邱家楗. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UITextViewCustom;

@protocol UITextViewCustomDelegate <NSObject, UITextViewDelegate>

@optional

//autoHeight改变调度时
-(void)textViewDidChangeHeight:(UITextViewCustom *)textView;

@end

@interface UITextViewCustom : UITextView

//最大长度，默认8000
@property (nonatomic)IBInspectable           NSUInteger maxLen;

//允许录入键盘表情符emoji 默认YES
@property (nonatomic)IBInspectable           BOOL     inputEmoji;

//删除过长字会时
@property (nonatomic, readonly) BOOL     deleteBackwarding;

@property (nonatomic, copy)  IBInspectable     NSString *placeholder;   // default is nil. string is drawn 70% gray
@property (nonatomic, retain)IBInspectable     UIColor  *placeholderColor;

//自动调整View高度 autoHeightMinLine > 0 && autoHeightMaxLine > autoHeightMinLine 时才会调整
//autoHeightMinHeight 是为了弥补autoHeightMinLine过小时
@property (nonatomic, assign)IBInspectable   ushort   autoHeightMinLine;     //default 1
@property (nonatomic, assign)IBInspectable   ushort   autoHeightMaxLine;     //default 1
@property (nonatomic, assign)IBInspectable   CGFloat  autoHeightMinHeight;   //default 0

//必须设置getter
//注意：取delegate时，如果类型是UITextView要转为UITextViewCustom或者用 [textView valueForKey:@"delegate"]
@property (nonatomic, weak, getter=getDelegate) id<UITextViewCustomDelegate> delegate;

@end
