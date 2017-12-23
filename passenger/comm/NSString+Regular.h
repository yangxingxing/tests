//
//  NSString+Regular.h
//  114SD
//
//  Created by 杨星星 on 2017/3/25.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regular)

//过滤空字符串
+(NSString*)filterEmptyString:(NSString*)str;

- (BOOL)isChinese;
- (BOOL)isChineseName;
- (BOOL)isQQNum;
//固定电话
- (BOOL)isTelePhone;
- (BOOL)isPhoneNumber;
- (BOOL)isSHIYIWEI;
- (BOOL)isEmail;
- (BOOL)isNum;
- (BOOL)isAccount;
//
- (BOOL)isZipCode;

- (BOOL)isURL;

//去除字符串空格
- (NSString*)trim;

//单引号 处理, 例如: @"A'B", 转为 @"'A''B'"
- (NSString*)quotedStr;

//判断字符串 不为null
+ (BOOL)vaildateStr:(NSString *)str;

//如果字符串 为 null, 则返回空字符 @""
+ (NSString *)nullOfEmptyStr:(NSString*)str;

//JOSN 转 NSDictionary
- (NSDictionary *)JSONToDictionary;

//NSDictionary 转 JSON 字符串
+ (NSString *)stringFromJSONDictionary:(NSDictionary *)JSONData;

//代替 sizeWithFont:(UIFont *)font
- (CGSize)calcSizeWithFont:(UIFont *)font;

//代替 sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
- (CGSize)calcSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size; // Uses NSLineBreakByWordWrapping

//代替 sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:
- (CGSize)calcSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

//字符版本串转，数字 "1.0.1" 转为 1.01, "1.0"转为1.0 非法不处理如：“1.0.0.1”
-(CGFloat)stringToFloatVer;

//返回今年的第几天
- (NSInteger)daysInTistYearWithDate:(NSString *)dateString;

//手机号码中间4位用*代替
- (NSString *)handlePhoneSecrect;

//券号按位隔开
- (NSString *)ticketNumberSeparate:(int)digit;

//券号四位隔开
- (NSString *)ticketNumberSeparate;

//商城钱保留小数点两位
- (NSString *)removeZeroAtTheBackOfTheDecimalPoint;

//去掉小数点后面最后一位的0,小数保留两位数,第三位四舍五入   Decimal为要保留的最长位数
- (NSString *)numDecimalAndRemoveLastZeroWithMaxDecimal:(int)Decimal;

// 去掉从通讯录copy来的号码中带的"+86"、"-"、" "
- (NSString *)removeAddressBookCopySpecilCharacters;

//13位时间戳+4位随机
+ (NSString *)topicClientId;

// 处理输入框钱
- (NSString *)dealWithMoneyTextField;

@end
