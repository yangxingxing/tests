//
//  UIColor+Hex.h
//  wBaiJu
//
//  Created by Apple on 14-12-12.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

//从十六进制字符串获取颜色，
//color:支持 0X123456
+ (UIColor *)colorWithHex:(int)rgbValue alpha:(CGFloat)alpha;

@end