//
//  wParams.h
//  wBaiJu
//  读取数据,及参数类
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

//#import "SQLiteUtils.h"
#import "wComm.h"
//#import "Reachability.h"
//#import "AsyncSocketClient.h"
//#import "wUserInfo.h"
#import "HSLocalized.h"
//#import "NSString+addition.h"

#import <Foundation/Foundation.h>

@interface SysParams : NSObject
//<AsyncSocketClientDelegate>
{

}

+ (instancetype)getParams;

+ (void)setParams:(SysParams *)aParams;


- (void)loadParams;

- (NSDictionary *)getConfigItems;

#pragma mark - Save Or Read Configs
- (void)saveSingleParam:(char *)AKey Value:(NSString *)AValue;

- (NSString *)readValue:(char *)AKey;

- (void)beginSaveParams;
- (void)endSaveParams;

#pragma mark - other

- (long long)lastLoginUserId;

//取多语言字符
- (NSString *)localStr:(NSString *)localStr;

//根据服务器端返回错误code,读取错误信息
- (NSString *)readError:(NSInteger)code;

//用下从 服务器下载的图片实例,imageName,即为 阿里云的key
//assignNone true 时,如果图片不存在, 返回 unHasIconImage 图片
- (UIImage *)imageLocal:(NSString *)imageName AssignNone:(BOOL)assignNone;

//取得本地手机上 图片全路径
- (NSString *)imageFile:(NSString *)imageName;

//取得本地手机上 语音全路径
- (NSString *)voiceFile:(NSString *)voiceName;

//取得本地手机上 视频全路径
- (NSString *)videoFile:(NSString *)videoName;

#pragma mark - property

//@property (nonatomic, readonly) AsyncSocketClient *socketClient;
//@property (nonatomic, retain)   SQLiteDataBase *dbUser;
//@property (nonatomic, retain)   SQLiteDataBase *dbConfig;

/// <summary>
/// 登录系统用户信息
/// </summary>
//@property (readonly, getter = getUserInfo) UserInfo *userInfo;

@property (getter = getLanguage, setter = setLanguage:)HSLanguage language;
@property (readonly) HSDriveType driveType;

//系统版本号
@property (readonly) float sysVer;


#pragma mrak 路径
//图片路径 聊天
@property (readonly) NSString *imagesDir;

//大图原始路径
@property (readonly) NSString *bigImageDir;

//语音路径
@property (readonly) NSString *voicesDir;

//视频路径
@property (readonly) NSString *videoDir;

//gif路径
@property (readonly) NSString *emojiOfGifDir;


#pragma mark 图片
@property (retain) UIImage* buttonAddImage;
@property (retain) UIImage* buttonBackImage;

//用户 没有头像时,显示的图片  使用大部可以调用 [params: imageLocal: @"XXXXX" AssignNone: true];
@property (retain) UIImage* unHasIconImage;

//消息声音 类型
@property (nonatomic) MessageSoundType messageSoundType;

//消息 振动
@property (nonatomic) BOOL messageVibration;

@property (nonatomic) NSInteger areaId;

#pragma mark urls 

//HTTP 使用地址，根据分配IP变的
@property (nonatomic, copy) NSString *serverUrl;

//HTTP 接口地址   @"http://www.wbaiju.com/wbaiju/cgi/"
@property (nonatomic, readonly) NSString *apiUrl;

//HTTP 域名地址，不变 @"http://www.wbaiju.com/wbaiju/" 内网测试时，是IP
@property (nonatomic, copy) NSString *wBaiJuUrl;

//获取分配IP的 地址  此两项是固定的
@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, copy) NSString *baseUrl1;

@end

typedef enum SysParamValueType
{
    wpvtText,
    wpvtBool,
    wpvtInt
} SysParamValueType;

@interface SysParamKey : NSObject


@property (nonatomic) char *key;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSString *group;
@property (nonatomic, retain) NSString *caption;
@property SysParamValueType valType;
@end
