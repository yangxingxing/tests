//
//  WBJUIFont.h
//  字体管理
//
//  Created by 邱家楗 on 15/11/10.
//  Copyright © 2015年 tigo soft. All rights reserved.
//

#import "HSLocalized.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WBJUIFont : NSObject

//细字体
+ (UIFont*)lightFontWithSize:(CGFloat)size;


+ (void)setFontLevel:(SInt8)fontLevel;

+ (SInt8)fontLevel;                 //字体级别 默认 1

//以下字体，根据 字体级别 改变
//网格 字体大小
+ (CGFloat)tableViewFontSize;       //default 15.0
+ (UIFont *)tableViewFont;

+ (CGFloat)tableViewDetailFontSize;       //default 13.0
+ (UIFont *)tableViewDetailFont;

//网格中 时间 字体大小
+ (CGFloat)tableViewTimeFontSize;  //default 12.0
+ (UIFont *)tableViewTimeFont;


//文本 标签 标准字体大小
+ (CGFloat)textFontSize;           //default 15.0
+ (UIFont *)textFont;

//返回TableView 标准行高 主从数据
+ (CGFloat)tableViewRowHeight;

//返回TableView 标准行高 只要标题行
+ (CGFloat)tableViewSingleRowHeight;

//返回UIButton 标准高    //default 36
+ (CGFloat)buttonHeight;

//为了适应不同像素，以320为基准， 算当前屏放大比例 (SCREENW / 320.0)
//Screen Rate
+ (CGFloat)screenRate;

//这不需要调用
+ (void)setScreenBaseWithWidth:(CGFloat)width;

+ (void)calcFontSizeWithFontLevel:(SignedByte)fontLevel
                     TextFontSize:(float *)textFontSize
                   DetailFontSize:(float *)detailFontSize
                     TimeFontSize:(float *)timeFontSize;

@end
