//
//  wComm.h
//  wBaiJu
//  微佰聚 消息提示框
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "wConsts.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIAlertView.h>


@interface Comm : NSObject

+ (void)setSoundHint:(BOOL)value;

+ (BOOL)getSoundHint;


//播放 对话框弹出时的 声音
+ (void)playMsgSoud;

//播放 接到消息时的 声音
+ (void)playMsgReceivedSound;

+ (void)playMsgReceivedSound:(MessageSoundType)soundType Vibration:(BOOL)vibration WaitDone:(BOOL)waitDone;

//振动
+ (void)playMsgVibrate;

//礼物 声音
+ (void)playPresenSound;

//发送消息 声音
+ (void)playSendMessage;

//关闭正在播放消息声音
+ (void)stopSounds;

//显示错误消息, Title 默认为 错误
+(void)errorMsg:(NSString*)msg;

//显示错误消息
+ (void)errorMsg:(NSString*)msg Title:(NSString*)title;

//显示消息,Title默认为 提示
+ (void)showMsg:(NSString *)msg;

//显示警告消息, Title默认为  警告
+ (void)warningMsg:(NSString *)msg;

//数字 根据小数位数,转为字符串
+ (NSString *)formatFloat:(double)value Digits:(int)digits;

//字符串简单加密
+ (NSString *)encryptStr:(NSString *)src;

//取得时间戳
+ (uint64_t)tickCount;

//获取随机数
+ (int)randomNumber:(int)from To:(int)to;

//object 转float
+ (float)objToFloat:(id)val;

//object 转 double
+ (double)objToDouble:(id)val;

+ (id)nullOf:(id)val to:(id)toVal;

//生成按每个字符模糊查找
+ (NSString *)buildLikeStrs:(NSString *)aFilterStr;

//生成 GUID字符串
+ (NSString *)guid;

//判断文件是否存在
+ (BOOL)fileExists:(NSString *)file;


//根据原有Size  按比例 转
+ (CGSize)tranSizeFrom:(CGSize)baseSize ToSize:(CGSize)toSize;

//根据 秒 转为小时 分钟 字符串
+ (NSString *)secondToTimeStr:(float)second;

//根据 byte 转为kb mb 字符串
+ (NSString *)byteSizeToStr:(long)bytes;


//根据传入图片数组,生成图片数组 位置返回
//images 图片数组 最多处理9张
//aWidth 宽度
//aSpace 行列简隔
+ (NSArray *)calcRectsWithImages:(NSArray *)images
                           Width:(float)aWidth
                           Space:(float)aSpace;

//根据传入多张图片,排版 画成一张图, 防微信 群 头像
//images 图片数组 最多处理9张
//aWidth 宽度
//aSpace 行列简隔
+ (UIImage *)drawImageWithImages:(NSArray *)images
                           Width:(float)aWidth
                           Space:(float)aSpace;

// stringByAddingPercentEscapesUsingEncoding不对@ & 等编码，所以自已特殊处理
//+(NSString*)httpEncode:(NSString*)str;

//重新设置 ViewController View Frame IOS8 拍照 转到 录像时，很容易出现 ViewController 高度增加
+ (void)resetNavViewFrame;

//图片居中显示
//+ (void)setImageViewCenterFromSupperView:(UIImageView*)imageView;


//转换 UIViewAutoresizing
+ (UIViewAutoresizing)exchAutoSizeMask:(UIViewAutoresizing)mask;

+ (NSString *)urlEncode:(NSString*) str UsingEncoding:(NSStringEncoding)encoding;

@end
