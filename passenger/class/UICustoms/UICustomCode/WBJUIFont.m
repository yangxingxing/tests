//
//  WBJUIFont.m
//  wBaijuApi
//
//  Created by 邱家楗 on 15/11/10.
//  Copyright © 2015年 tigo soft. All rights reserved.
//

#import "WBJUIFont.h"

#define SSysFontLevel @"SysFontLevel"

static SignedByte _fontLevel = -1;

static CGFloat _tableViewFontSize       = 14.0;
static CGFloat _tableViewDetailFontSize = 13.0;
static CGFloat _tableViewTimeFontSize   = 11;
static CGFloat _textFontSize            = 14.0;

static UIFont* _tableViewFont         = nil;
static UIFont* _tableViewDetailFont   = nil;
static UIFont* _tableViewTimeFont     = nil;
static UIFont* _textFont              = nil;

static CGFloat kBaseScreenWidth = 375;
static CGFloat kScreenRate      = -1;

@implementation WBJUIFont

//细字体
+ (UIFont*)lightFontWithSize:(CGFloat)size
{
    if (_tableViewTimeFont)
        return [_tableViewTimeFont fontWithSize:size];
    else
    {
        UIFont *result = [UIFont fontWithName:@"STHeitiSC-Light" size:size];
        if (!result)
            result = [UIFont systemFontOfSize:size];
        return result;
    }
}

//以下字体，根据 字体级别 改变
//网格 字体大小
+ (CGFloat)tableViewFontSize //default         14.0
{
    return _tableViewFontSize;
}

+ (UIFont *)tableViewFont
{
    return _tableViewFont;
}

+ (CGFloat)tableViewDetailFontSize       //default 13.0
{
    return _tableViewDetailFontSize;
}

+ (UIFont *)tableViewDetailFont
{
    return _tableViewDetailFont;
}


//网格中 时间 字体大小
+ (CGFloat)tableViewTimeFontSize //default 12.0
{
    return _tableViewTimeFontSize;
}

+ (UIFont *)tableViewTimeFont
{
    return _tableViewTimeFont;
}

//文本 标签 标准字体大小
+ (CGFloat)textFontSize //default         14.0
{
    return _textFontSize;
}

+ (UIFont *)textFont
{
    return _textFont;
}

//返回TableView 标准行高
+ (CGFloat)tableViewRowHeight
{
    UIFont *font       = [self tableViewFont];
    UIFont *detailFont = [self tableViewDetailFont];
    
    CGFloat h = ceilf((font ? font.lineHeight : 19.0) +
                      (detailFont ? detailFont.lineHeight : 16) + 16 * [self screenRate]);
    return h;
}

//返回TableView 标准行高 只要标题行
+ (CGFloat)tableViewSingleRowHeight
{
    UIFont *font       = [self tableViewFont];
    
    CGFloat h = ceilf((font ? font.lineHeight : 19.0) + 26 * [self screenRate]);
    return h;
}

//返回UIButton 标准高    //default 36
+ (CGFloat)buttonHeight
{
    UIFont *font = [self textFont];
    //20 / 320.0 = 0.6  
    CGFloat h    = ceilf((font ? font.lineHeight : 19.0) + 25 * [self screenRate]);
    return h;
}

+ (void)setScreenBaseWithWidth:(CGFloat)width
{
    kBaseScreenWidth = width;
    if (kBaseScreenWidth < 320)
        kBaseScreenWidth = 320;
}

//Screen Rate
+ (CGFloat)screenRate
{
    if (kScreenRate < 0)
    {
        kScreenRate = [UIScreen mainScreen].bounds.size.width / kBaseScreenWidth;
    }
    return kScreenRate;
}

+ (void)calcFontSizeWithFontLevel:(SignedByte)fontLevel
                     TextFontSize:(float *)textFontSize
                   DetailFontSize:(float *)detailFontSize
                     TimeFontSize:(float *)timeFontSize
{
    CGFloat baseSysSize    = 15.0;
    CGFloat baseDetailSize = 13.0;
    CGFloat baseTimeSize   = 11.0;
    
    CGFloat fontSize   = baseSysSize + fontLevel;
    //    if (fontLevel == 4)
    //        fontSize = 19.0;
    //    else
    //        if (fontLevel == 5)
    //            fontSize = 21.0;
    
    *textFontSize   = fontSize;
    *detailFontSize = baseDetailSize + (fontLevel * 0.5);
    *timeFontSize   = baseTimeSize   + (fontLevel * 0.5);
}

//字体级别 默认 1
+ (SInt8)fontLevel
{
    if (_fontLevel < 0)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        id fontLevel = [userDefaults valueForKey:SSysFontLevel];
        SInt8 level = fontLevel ? [fontLevel intValue] : 1;
        [self setFontLevel: level];
    }
    return _fontLevel;
}

+ (void)setFontLevel:(SInt8)fontLevel
{
    if (_fontLevel != fontLevel)
    {
        _fontLevel = fontLevel;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setInteger:_fontLevel forKey:SSysFontLevel];
        [userDefault synchronize];
        
        float fontSize;
        float detailFontSize;
        float timeFontSize;
        [self calcFontSizeWithFontLevel:_fontLevel TextFontSize:&fontSize
                         DetailFontSize:&detailFontSize
                           TimeFontSize:&timeFontSize];
        
#if ! __has_feature(objc_arc)
        if (_tableViewFont)
        {
            [_tableViewFont release];
            [_tableViewDetailFont release];
            [_tableViewTimeFont release];
            [_textFont release];
        }
#endif
        
        //网格 字体大小
        _tableViewFontSize = fontSize;
        _tableViewFont     = [UIFont systemFontOfSize:_tableViewFontSize];
        
        _tableViewDetailFontSize = detailFontSize;
        _tableViewDetailFont = [_tableViewFont fontWithSize:_tableViewDetailFontSize];
        
        //网格中 时间 字体大小
        _tableViewTimeFontSize = timeFontSize; //default 12.0
        _tableViewTimeFont     = [UIFont fontWithName:@"STHeitiSC-Light" size:_tableViewTimeFontSize];
        if (!_tableViewTimeFont)
            _tableViewTimeFont = [_tableViewFont fontWithSize:_tableViewTimeFontSize];
        
        //文本 标签 标准字体大小
        _textFontSize      = fontSize; //default         14.0
        _textFont          = [_tableViewFont fontWithSize:_textFontSize];
        
#if ! __has_feature(objc_arc)
        [_tableViewFont retain];
        [_tableViewDetailFont retain];
        [_tableViewTimeFont retain];
        [_textFont retain];
#endif

    }
}

@end
