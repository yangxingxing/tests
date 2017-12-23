//
//  GlobalHeader.h
//  114SD
//
//  Created by 杨星星 on 2017/3/25.
//  Copyright © 2017年 杨星星. All rights reserved.
//
#import "PassengerHeader.h"
typedef NS_ENUM(NSInteger, ShopGrade) {
    ShopGradeNone = 0,   // 未认领
    ShopGradeNormal, // 普通商家
    ShopGradeVIP,    // VIP商家
};

#import "MJRefresh.h"  // 下拉刷新，上拉加载
#import "UIScrollView+EmptyDataSet.h"

// 缓存主目录
#define BusinessCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"SearchCache"]

#define DeviceUUIDString @"uuidString"

#define UITableViewBackgroundColor [UIColor colorWithHexString:@"F0F0F5"]

#define TabBarBackgroundColor [UIColor colorWithHexString:@"313131"]

#define HomeTopNavColor [UIColor colorWithHexString:@"F5F5F5"]

#define LoginNavColor [UIColor colorWithHexString:@"EBECEE" alpha:1]

#define GradeBackColor color(230, 167, 95, 1) // 显示等级背景颜色

#define GradeTextColor color(189, 87, 21, 1)  // 显示等级文本颜色

#define MainColor [UIColor colorWithHexString:@"3a99D8"]    // 导航栏背景色

#define ConfirmBtnBackgroundColor textOrangeColor     // 主题背景色

#define CodeBtnBackColor color(252, 178, 36, 1)  // 获取验证码背景颜色

#define FontSize(a) [UIFont systemFontOfSize:a]

#define LightFontSize(a) [UIFont fontWithName:@"STHeitiSC-Light" size:a]

#define ImageNamed(a) [UIImage imageNamed:a]

//#define UrlWithStr(a) [NSURL URLWithString:a]

#define UrlWithStr(a) [NSURL URLWithString:a]

#define UrlWithIconStr(a) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageBaseFile,a]] // 图片Url

#define DefalutOpenIMPassword @"123456"

#define AliPayCompleteNotification @"AliPayCompleteNotification"

#define WeChatCompleteNotification @"WeChatPayCompleteNotification"

#define APPIsLogin @"APPIsLogin" 

#define APPIsLoginOut @"APPIsLoginOut" 

#define RememberPassword @"RememberPassword" 

#define APPFirstLaunch @"APPFirstLaunch" // 首次下载APP

#define SoundIsClose @"SoundIsClose"  // 声音是否打开

#define VibratingAlertIsClose @"VibratingAlertIsClose"  // 振动是否打开

#define LastUserAccount @"LastUserAccount"

#define ReciveNewMessage @"ReciveNewMessage"

#define CustomPersonId  [NSString stringWithFormat:@"%@%@",DefaultOpenIMId,@"woody550518"]

#define DefalutHeadImage ImageNamed(@"headportrait_bg_navbar")

#define DefalutImage ImageNamed(@"icon_default")

#define LogoImage ImageNamed(@"fengshui_login") // logo


#define ScreenRate  SCREENW/375.0 // 屏幕比例

static NSString *imageBaseFile = @"http://123.206.100.209//Iospay/Public/"; // 图片路径

static const NSInteger SuccessCode = 1;

static const NSInteger RightBarBtnEdge = 9;
static CGFloat leftSpace = 12; // 左边距
static CGFloat lineWidth = 0.2;// 线条宽度


#define FailHint @"网络连接失败，请稍后重试"
