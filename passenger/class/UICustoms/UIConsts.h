//
//  UIConsts.h
//  定义一些UI方面的 常量，宏....
//
//  Created by 邱家楗 on 16/3/26.
//
//

/** 开发模式 */
static BOOL const DEVELOPER_MODE = NO;

#pragma mark NSLog
//调试模式
//#if DEBUG
//#define SLog(fmt,...) NSLog(fmt,##__VA_ARGS__)
//#else
//#define SLog(fmt,...)
//#endif

#if DEBUG
#define SLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define SLog(...);
#endif


#pragma mark UITableView
//网格背景色 颜色
//#define UITableViewBackgroundColor [UIColor colorWithRed:0.937255 green:0.937255 blue:0.956863 alpha:1.0]
//[UIColor colorWithRed:239.0 / 255.0 green:239.0 / 255.0 blue:244.0 / 255.0 alpha:1.0]

//网格行 颜色
#define UITableViewCellBackgroundColor [UIColor whiteColor]

//网格 线 颜色
#define UITableViewSeparatorColor  [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1.0]   //[[UIColor grayColor]colorWithAlphaComponent:0.2]

//网格   标准高度
#define UITableViewRowHeight        44

//网格  分隔行 标准高度
#define UITableViewSplitRowHeight   8

//网格 字体大小
#define UITableViewFontSize         15.0
#define UITableViewFont             [UIFont systemFontOfSize:UITableViewFontSize]

//网格中 时间 字体大小
#define UITableViewTimeFontSize     12.0
#define UITableViewTimeFont         [WBJUIFont lightFontWithSize:UITableViewTimeFontSize]

//文本 标签 标准字体大小
#define UITextFontSize              15.0
#define UITextFont                  [UIFont systemFontOfSize:UITextFontSize]


//Button Border Width
#define UIButtonBorderWidth         0.5

//线条 粗细
#define UILineBorderWidth           0.4


//头像圆角（全局）
#define RadiusIcon  3.5

//大圆角
#define RadiusBig   8.0


#define SCREENH [[UIScreen mainScreen] bounds].size.height
#define SCREENW [[UIScreen mainScreen] bounds].size.width

//需要横屏或者竖屏，获取屏幕宽度与高度
/*
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上

#define SCREEN_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define SCREENH_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define SCREEN_SIZE ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#endif
*/

// OS Version
#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define iOS102 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.2)
#define iOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define iOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS6 ((([[UIDevice currentDevice].systemVersion intValue] >= 6) && ([[UIDevice currentDevice].systemVersion intValue] < 7)) ? YES : NO )
#define iOS5 ((([[UIDevice currentDevice].systemVersion intValue] >= 5) && ([[UIDevice currentDevice].systemVersion intValue] < 6)) ? YES : NO )

#define LargeScreen ([UIScreen mainScreen].bounds.size.height > 480)

#define iOS7AddStatusHeight (IOS7?20:0)

#define degreesToRadians(degrees) ((degrees) / 180.0 * M_PI)
#define foo4random() (1.0 * (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX)

//UIViewAutoresizing
//宽高等比拉
#define UIAutoSizeMaskAll            UIViewAutoresizingFlexibleWidth       | UIViewAutoresizingFlexibleHeight

//Top,height固定,宽等比拉
#define UIAutoSizeMaskTop            UIViewAutoresizingFlexibleWidth       | UIViewAutoresizingFlexibleBottomMargin

//bottom,height固定，宽等比拉
#define UIAutoSizeMaskBottom         UIViewAutoresizingFlexibleWidth       | UIViewAutoresizingFlexibleTopMargin

//left,width固定，高等比拉
#define UIAutoSizeMaskLeft           UIViewAutoresizingFlexibleHeight      | UIViewAutoresizingFlexibleRightMargin

//right,width固定，高等比拉
#define UIAutoSizeMaskRight          UIViewAutoresizingFlexibleHeight      | UIViewAutoresizingFlexibleLeftMargin

//固定于 左上角，宽高固定
#define UIAutoSizeMaskLeftTopOnly    UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin

//固定于 右上角，宽高固定
#define UIAutoSizeMaskRightTopOnly   UIViewAutoresizingFlexibleLeftMargin  | UIViewAutoresizingFlexibleBottomMargin

//固定于 左下角，宽高固定
#define UIAutoSizeMaskLeftBottomOnly UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin

//固定于 右下角，宽高固定
#define UIAutoSizeMaskRightBottomOnly UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin

//四周等比固，如 横竖屏转换居中不拉申
#define UIAutoSizeMaskFixs UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin  |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin


#pragma mark 颜色
#define color(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define COLOR_DarkGreen               color(0, 128, 0, 1) //深绿色  用于一些进度条之类的
//链接字体颜色
#define COLOR_LINK                    [UIColor colorWithRed:40.0 / 255.0 green:137.0 / 255.0 blue:250.0 / 255.0 alpha:1.0]

//UIPageControl 点颜色
#define COLOR_PageControlTintColor    [UIColor colorWithRed:210.0 / 255.0 green:210.0 / 255.0 blue:210.0 / 255.0 alpha:0.5]

//UIPageControl 当前页颜色
#define COLOR_PageControlCurrentPage  [textOrangeColor colorWithAlphaComponent: 0.8]           //[UIColor greenColor]

#define sureBtnColor                  color(254, 156, 1, 1)     //[UIColor colorWithHexString:@"#fe9c01"]
#define textBlackColor                [UIColor blackColor]      //[UIColor colorWithHexString:@"#606060"]
#define textGrayColor                 [UIColor grayColor]       //[UIColor colorWithHexString:@"#949494"]
#define textOrangeColor               [UIColor orangeColor]     //[UIColor colorWithHexString:@"#fe9c01"]
#define YellowColor                   color(255, 216, 34, 1)    //[UIColor colorWithHexString:@"#ffd822"]
#define textGreenColor                color(96, 217, 78, 1)     //[UIColor colorWithHexString:@"#60d94e"]
#define textRedColor                  [UIColor redColor]     //[UIColor colorWithHexString:@"#fe5454"]
#define textLightGrayColor            [UIColor lightGrayColor]
#define GrayColor                     color(145, 145, 145, 1)      //[UIColor colorWithHexString:@"#919191"]
#define AshenColor                    color(245, 206, 147, 1)      //[UIColor colorWithHexString:@"#f5ce93"]//土色
#define textWhiteColor                [UIColor whiteColor]
#define DistanceAndTimeColor  [UIColor colorWithHexString:@"#828181"]

#define BusinessCellSeparatorLineColor [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1]   //商城淡淡的灰色线统一使用

#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HEXACOLOR(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

//[NSThread isMainThread]
static inline BOOL isMainQueue() {
#if DEBUG
    return [NSThread isMainThread]; //pthread_main_np()
#else
    static const void *mainQueueKey = "mainQueue";
    static  void *mainQueueContext = (void *)"mainQueue";
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_set_specific(dispatch_get_main_queue(), mainQueueKey, mainQueueContext, nil);
    });
    return dispatch_get_specific(mainQueueKey) == mainQueueContext;
#endif
}

//GCD - 确保block 在主线程执行
#define dispatch_main_sync_safe(block)\
if (isMainQueue())\
{\
block();\
}\
else\
{\
dispatch_sync(dispatch_get_main_queue(), block);\
}


//GCD - 开启异步主线程
#define dispatch_main_async(block)\
dispatch_async(dispatch_get_main_queue(), block);

//GCD - 开启多线程
#define dispatch_global_queue_default(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);


#ifndef WEAK
#if __has_feature(objc_arc_weak)
#define WEAK weak
#else
#define WEAK assign
#endif
#endif

#define WEAK_SELF __weak typeof(self) wself = self
#define STRONG_SELF if (!wself) return; \
__strong typeof(wself) sself = wself
