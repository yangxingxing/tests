//
//  CustomShareView.h
//  FengShui
//
//  Created by 杨星星 on 2017/10/16.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "EWMBackView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ShareClass.h"

typedef NS_ENUM(NSInteger,SharePlatType){
    SharePlatTypeWX = 1,//微信好友
    SharePlatTypeWXCircle = 2,//微信朋友圈
    SharePlatTypeQQ = 4,//QQ
    SharePlatTypeSina = 8,//新浪
};

@protocol CustomShareViewDelegate <NSObject>

@optional
-(void)shareActionWithType:(SSDKPlatformType)type;
-(void)shareActionWithType:(SharePlatType)type shareDic:(NSDictionary *)shareDic;

@end
@interface CustomShareView : EWMBackView
@property (assign,nonatomic)id<CustomShareViewDelegate> shareDelegate;
@property (nonatomic,strong,readonly) NSMutableArray *shareAry;//分享总数据;
-(void)displayView;

@end
