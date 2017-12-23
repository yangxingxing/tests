//
//  UserInfo.m
//  114SD
//
//  Created by 杨星星 on 2017/3/25.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "User.h"
#import <objc/message.h>

@implementation User

static User *userInfo = nil;
static dispatch_once_t onceToken;

+ (instancetype)standardUserInfo {
    dispatch_once(&onceToken, ^{
        userInfo = [User getUserInfo];
        if (!userInfo) {
            userInfo = [[User alloc] init];
            [userInfo createCacheDirectory];
        }
//        if (!userInfo.city || userInfo.city.length == 0) {
//            userInfo.provience = @"福建省";
//            userInfo.city = @"泉州市";
//        }
//        if (!userInfo.selectedCity || userInfo.selectedCity.length == 0) {
//            userInfo.selectedCity = userInfo.city;
//            userInfo.selectedProvince = userInfo.provience;
//        }
//        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//        NSString *uuidString = [user valueForKey:DeviceTokenStringKey];
//        if (!uuidString || uuidString.length == 0) {
//            uuidString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//            uuidString = [uuidString md5String];
//        }
//        userInfo.uuidString =uuidString;
//        [user setValue:uuidString forKey:DeviceTokenStringKey];
//        SLog(@"uuidString=%@",uuidString);
    });
    return userInfo;
}

// 释放单例
+(void)attempDealloc {
    onceToken = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
    userInfo = nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {};

//- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues {
//    [super setValuesForKeysWithDictionary:keyedValues];
//}

//归档
- (void)encodeWithCoder:(NSCoder *)coder
{
    unsigned int count = 0;
    // C语言里面，如果传基本数据类型的指针!那么一般都是需要在函数内部改变他的值！
    Ivar * ivars = class_copyIvarList([User class], &count); // .m内属性照样能拿到
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char * name = ivar_getName(ivar);
        NSString * key = [NSString stringWithUTF8String:name];
        //归档
        [coder encodeObject:[self valueForKey:key] forKey:key];
    }
    
    // 在C语言里面，但凡看到NEW,Create,Copy函数需要释放！
    free(ivars);
}


//解档
- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar * ivars = class_copyIvarList([User class], &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            const char * name = ivar_getName(ivar);
            NSString * key = [NSString stringWithUTF8String:name];
            //解档
            id value = [coder decodeObjectForKey:key];
            //设置到成员变量身上
            [self setValue:value forKey:key];
        }
        
        free(ivars);
    }
    return self;
}

/**
 * 归档
 */
+ (void)save:(User *)user
{
    [NSKeyedArchiver archiveRootObject:userInfo toFile:UserInfoPath];
}

/**
 * 读取model
 */
+ (User *)getUserInfo
{
    // 文件信息
    User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:UserInfoPath];
    return user;
}

// 删除文件夹    ********************************
+ (void)deleteFile
{
    // 获取要删除的路径
//    NSString *deletePath = [UserCachesDirectory stringByAppendingPathComponent:UserInfoPath];
    // 创建文件管理对象
    NSFileManager *manager = [NSFileManager defaultManager];
    // 删除
    BOOL isDelete = [manager removeItemAtPath:UserCachesDirectory error:nil];
    NSLog(@"%d", isDelete);
}

/**
 *  创建缓存目录文件
 */
- (void)createCacheDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:UserCachesDirectory]) {
        [fileManager createDirectoryAtPath:UserCachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}


@end
