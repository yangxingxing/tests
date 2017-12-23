//
//  MyTools.h
//  114SD
//
//  Created by 杨星星 on 2017/3/29.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"  // 活动指示器

@interface MyTools : NSObject

+ (void)playMsgReciveSound;

+ (UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size;

// 加载指示器
+ (MBProgressHUD *)createHudWithFrame:(UIView *)view;

+ (UIImage *)createQRCode:(NSString *)str width:(CGFloat)width;

//UIView
+(UIView *)createViewWithFrame:(CGRect)frame;
//UILabel
+(UILabelCustom *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(CGFloat)font;
//UIButton
+(UIButtonCustom *)createButtonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor imageName:(NSString *)imageName backgroundImageName:(NSString *)backgroundImageName target:(id)target selector:(SEL)selector;
//UIImageView
+(UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;
//UITextField
+(UITextField *)createTextFieldWithFrame:(CGRect)frame text:(NSString *)text placeHolder:(NSString *)placeHolder;

+ (HSUITextField *)createHSUITexfielfWithFrame:(CGRect)frame
                                          text:(NSString *)text
                                   placeHolder:(NSString *)placeHolder
                                       decimal:(int)decimal
                                      delegate:(id)delegate
                                          font:(UIFont *)font
                                        maxLen:(int)maxLen
                               clearButtonMode:(UITextFieldViewMode)clearButtonMode
                                    numberOnly:(BOOL)numberOnly
                                     textColor:(UIColor *)textColor;

+ (UITableView *)createTableViewWithFrame:(CGRect)frame delegate:(id)delegate backgroundColor:(UIColor *)backgroundColor rowHeight:(CGFloat)rowHeight;

// 返回不同颜色的富文本
+ (NSAttributedString *)getDifferentColorWithString:(NSString *)string containStr:(NSString *)containStr  color:(UIColor *)color;

// 不同字体
+ (NSAttributedString *)getDifferentFontWithString:(NSString *)string containStr:(NSString *)containStr font:(CGFloat)fontSzie;

// 不同颜色不同大小
+ (NSAttributedString *)getDifferentFontAndColorWithString:(NSString *)string containStr:(NSString *)containStr font:(CGFloat)fontSzie color:(UIColor *)color;

// html->富文本
+ (NSAttributedString *)getAttWithHtmlStr:(NSString *)html;

+ (void)loginOut;


//百度经纬度转换高德经纬度
+(NSArray *)bdExchangeToGeoWith:(double)lat lng:(double)lng;

//高德转百度
+(NSArray *)geoExchangeBDGeoWith:(double)lat lng:(double)lng;

+ (void)showMsg:(NSString *)msg target:(UIViewController *)target  handler:(dispatch_block_t)handler;

// 提示框
+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message action1:(NSString *)actionStr1 action2:(NSString *)actionStr2 target:(UIViewController *)target secondHandler:(dispatch_block_t)handler;

+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message action1:(NSString *)actionStr1 action2:(NSString *)actionStr2 target:(UIViewController *)target firstHandler:(dispatch_block_t)firstHandler secondHandler:(dispatch_block_t)secondHandler;

// Key: 按照排序的key; ascending: YES为升序, NO为降序。
+ (NSArray *)arrayWithSort:(NSMutableArray *)dataArray key:(NSString *)key ascending:(BOOL)ascending;

@end
