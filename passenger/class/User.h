//
//  UserInfo.h
//  114SD
//
//  Created by 杨星星 on 2017/3/25.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "wConsts.h"
#import "BaseModel.h"
#import "BusinessShowInfoView.h"

// 缓存主目录
#define UserCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"UserCache"]
// 存储文件信息的路径（caches）
#define UserInfoPath [UserCachesDirectory stringByAppendingPathComponent:@"userInfoPath.user"]

typedef NS_ENUM(int,User_typeEnum) {
    User_typeNormal = 1, // 1 普通会员
    User_typeInvited,    // 2邀请会员
    User_typeVip,        // 3vip会员
    User_typeCompany,     // 企业
};

@interface User : BaseModel

+ (instancetype)standardUserInfo;

+(void)attempDealloc;

@property (nonatomic, assign) double longitude;// 经度

@property (nonatomic, assign) double latitude; // 维度

@property (nonatomic,copy) NSString *location;

@property (nonatomic,copy) NSString *provience;

@property (nonatomic,copy) NSString *city;
///区
@property (nonatomic, copy)   NSString         *district;
///区域编码
//@property (nonatomic, copy)   NSString         *adcode;
///乡镇街道
@property (nonatomic, copy)   NSString         *township;


- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues;

/**
 * 归档
 */
+ (void)save:(User *)user;

/**
 * 读取model
 */
+ (User *)getUserInfo;

+ (void)deleteFile;

@end
