//
//  ProjectConfig.m
//  YunFu
//
//  Created by 杨星星 on 2017/8/23.
//  Copyright © 2017年 杨星星. All rights reserved.
//

//#import "UMessage.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"

#define QQAppId @"1106485206"

#define QQAppKey @"4q0fCxCzktNfFAF7"

#define WeChatAppId @"wx645bf4fd00fcf21e"

#define WeChatSecret @"b7f54791287a8ec709bb03df64b82783"

#import "ShareConfig.h"

@implementation ShareConfig


- (void)registerActivePlatforms {
    /**初始化ShareSDK应用
     @param activePlatforms
     使用的分享平台集合
     @param importHandler (onImport)
     导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
     @param configurationHandler (onConfiguration)
     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
     */
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformSubTypeQZone),
                                        @(SSDKPlatformSubTypeQQFriend),
                                        @(SSDKPlatformSubTypeWechatTimeline),
                                        @(SSDKPlatformSubTypeWechatSession),
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"3375152085" appSecret:@"efa1db06ac65d1b7246a8a14f9d6abcc" redirectUri:@"http://www.sharesdk.cn" authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WeChatAppId appSecret:WeChatSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:QQAppId appKey:QQAppKey authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
    [WXApi registerApp:WeChatAppId];
}

@end
