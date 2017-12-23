//
//  MyTools.m
//  114SD
//
//  Created by 杨星星 on 2017/3/29.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "MyTools.h"
#import <AVFoundation/AVFoundation.h>
#import "BaseModel.h"

@implementation MyTools

// 播放声音
+ (void)playMsgReciveSound {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:SoundIsClose] boolValue]) return;
    //1.获取本地资源
    
    //(1)路径
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"chord" ofType:@"caf"];
    
    //(2)转换为NSURL
    //【注意】本地多媒体文件的读取 路径必须是NSURL类型 并且将字符串路径转为NSURL [NSURL fileURLWithPath:];
    
    //[NSURL URLWithString:]针对网络资源路径
    
    NSURL *URL = [NSURL fileURLWithPath:path];
    
    //    NSLog(@"%@",URL);
    
    //2.获取音频资源
    
    //短音频获取时 通过URL找到资源 系统给资源分配一个ID用于标识
    //ID代表了URL对应的资源
    
    
    SystemSoundID soundID;
    //用于标识资源的ID
    
    
    //(1)通过URL找到资源 请求系统给资源分配ID ID值赋值给soundID
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(URL), &soundID);
    
    //参数1:(__brige CFURLRef)固定写法 内存管理由系统控制器 自己不做管理 URL资源的路径
    //参数2:系统给资源分类的ID 用soundID来记录
    
    
    //(2)播放
    //系统中音频
    
    AudioServicesPlaySystemSound(soundID);
    
    //提示音 振动 警告
    //    AudioServicesPlayAlertSound(soundID);
    
    
    //3.实现循环播放
    //    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, &foo, NULL);
    /*
     参数1：循环播放的ID
     参数2：循环的runloop NULL使用系统默认的
     参数3：管理播放的runloop NULL使用系统默认的
     参数4: 函数地址 循环调用的函数 类型必须按照系统要求的来写
     参数5:NULL
     参数2、3、5可以认为是固定写法
     */
}

#pragma mark -- 播放时循环调用的函数
void foo(SystemSoundID soundID, void *context){
    
    AudioServicesPlayAlertSound(soundID);
    
}

+ (UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 加载指示器
+ (MBProgressHUD *)createHudWithFrame:(UIView *)view {
    //活动指示器
    MBProgressHUD * hud = [[MBProgressHUD alloc]initWithView:view];
    //设置加载的文字提示
    hud.label.text = @"加载数据...";
    hud.label.textColor = textWhiteColor;
    //设置菊花的颜色
//    hud.activityIndicatorColor = [UIColor blackColor];
    //RGB(114, 254, 241, 1);
    //设置颜色
    hud.bezelView.color = [textBlackColor colorWithAlphaComponent:0.8];
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [hud bringSubviewToFront:view];
    return hud;
}

+ (UIImage *)createQRCode:(NSString *)str width:(CGFloat)width {
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    
    // 3.将字符串转换成NSdata
    NSString *urlString = str;
    NSData *data  = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5.生成二维码
    CIImage *outputImage = filter.outputImage;
    CGFloat scale = width / CGRectGetWidth(outputImage.extent);
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale); // scale 为放大倍数
    CIImage *transformImage = [outputImage imageByApplyingTransform:transform];
    
    // 保存
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:transformImage fromRect:transformImage.extent];
    UIImage *qrCodeImage = [UIImage imageWithCGImage:imageRef];
    return qrCodeImage;
}

//UIView
+(UIView *)createViewWithFrame:(CGRect)frame
{
    UIView * view = [[UIView alloc]initWithFrame:frame];
    return view;
}
//UILabel
+(UILabelCustom *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(CGFloat)font
{
    UILabelCustom * label = [[UILabelCustom alloc]initWithFrame:frame];
    //文字
    label.text = text;
    //文字颜色
    label.textColor = textColor;
    //字体颜色
    label.font = FontSize(font);
    //设置对齐方式
    label.textAlignment = NSTextAlignmentCenter;
    return label;
    
}
//UIButton
+(UIButtonCustom *)createButtonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor imageName:(NSString *)imageName backgroundImageName:(NSString *)backgroundImageName target:(id)target selector:(SEL)selector
{
    UIButtonCustom * button = [UIButtonCustom buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    //设置标题
    [button setTitle:title forState:UIControlStateNormal];
    //设置标题颜色
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    //设置图片
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //设置背景图片
    [button setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
    
    //设置响应事件
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
//UIImageView
+(UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}
//UITextField
+(UITextField *)createTextFieldWithFrame:(CGRect)frame text:(NSString *)text placeHolder:(NSString *)placeHolder
{
    UITextField * textField = [[UITextField alloc]initWithFrame:frame];
    textField.text = text;
    textField.placeholder = placeHolder;
    return textField;
}

+ (HSUITextField *)createHSUITexfielfWithFrame:(CGRect)frame
                                          text:(NSString *)text
                                   placeHolder:(NSString *)placeHolder
                                       decimal:(int)decimal
                                      delegate:(id)delegate
                                          font:(UIFont *)font
                                        maxLen:(int)maxLen
                               clearButtonMode:(UITextFieldViewMode)clearButtonMode
                                    numberOnly:(BOOL)numberOnly
                                     textColor:(UIColor *)textColor {
    HSUITextField *textField = [[HSUITextField alloc] initWithFrame:frame];
    textField.font        = font;
    textField.textColor   = textColor;
    textField.placeholder = placeHolder;
    textField.delegate    = delegate;
    textField.decimal     = decimal;
    textField.maxLen      = maxLen;
    textField.text        = text;
    textField.numberOnly  = numberOnly;
    textField.clearButtonMode  = clearButtonMode;
    return textField;
}

+ (UITableView *)createTableViewWithFrame:(CGRect)frame delegate:(id)delegate backgroundColor:(UIColor *)backgroundColor rowHeight:(CGFloat)rowHeight  {
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    tableView.rowHeight = rowHeight;
    tableView.backgroundColor = backgroundColor;
    tableView.tableFooterView = [UIView new];
    return tableView;
}

+ (NSAttributedString *)getDifferentColorWithString:(NSString *)string containStr:(NSString *)containStr color:(UIColor *)color {
    NSMutableAttributedString *mAttStri = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange font_range1 = [string rangeOfString:containStr ? containStr : SStringEmpty];
    [mAttStri addAttribute:NSForegroundColorAttributeName value:color range:font_range1];
    return mAttStri;
}

+ (NSAttributedString *)getDifferentFontWithString:(NSString *)string containStr:(NSString *)containStr font:(CGFloat)fontSzie {
    NSMutableAttributedString *mAttStri = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange font_range = [string rangeOfString:containStr];
    [mAttStri addAttribute:NSFontAttributeName value:FontSize(fontSzie) range:font_range];
    return mAttStri;
}

// 不同颜色不同大小
+ (NSAttributedString *)getDifferentFontAndColorWithString:(NSString *)string containStr:(NSString *)containStr font:(CGFloat)fontSzie color:(UIColor *)color {
    NSMutableAttributedString *mAttStri = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange font_range = [string rangeOfString:containStr];
    [mAttStri addAttributes:@{NSFontAttributeName:FontSize(fontSzie),
                              NSForegroundColorAttributeName:color} range:font_range];
    return mAttStri;
}

+ (NSAttributedString *)getAttWithHtmlStr:(NSString *)html {
    return [[NSMutableAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
}

+ (void)loginOut {
    User *userInfo = [User standardUserInfo];
    userInfo = nil;
    [User deleteFile];
    [User attempDealloc];
    User *saveUser = [User standardUserInfo];
    [User save:saveUser];

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setBool:NO forKey:APPIsLogin];
}


//百度经纬度转换高德经纬度
+(NSArray *)bdExchangeToGeoWith:(double)lat lng:(double)lng
{
    double pi = 3.1415926535897932384626;
    double bd_lat = lat;
    double bd_lon = lng;
    
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * pi);
    double geoLon = z * cos(theta);
    double geoLat = z * sin(theta);
    
    //下标 1 为lat  下标 2 为lng
    NSArray *arr = @[@(geoLat),@(geoLon)];
    return arr;
}

//高德转百度
+(NSArray *)geoExchangeBDGeoWith:(double)lat lng:(double)lng
{
    double pi = 3.1415926535897932384626;
    double x = lng;
    double y = lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * pi);
    double mgLon1 = z * cos(theta) + 0.0065;
    double mgLat1 = z * sin(theta) + 0.006;
    
    //下标 1 为lat  下标 2 为lng
    NSArray *arr = @[@(mgLat1),@(mgLon1)];
    return arr;
}

+ (void)showMsg:(NSString *)msg target:(UIViewController *)target  handler:(dispatch_block_t)handler {
    [MyTools showAlertControllerWithTitle:@"温馨提示" message:msg action1:@"确定" action2:nil target:target firstHandler:handler secondHandler:nil];
}

// 提示框
+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message action1:(NSString *)actionStr1 action2:(NSString *)actionStr2 target:(UIViewController *)target secondHandler:(dispatch_block_t)handler {
    [MyTools showAlertControllerWithTitle:title message:message action1:actionStr1 action2:actionStr2 target:target firstHandler:nil secondHandler:handler];
}

// 提示框
+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message action1:(NSString *)actionStr1 action2:(NSString *)actionStr2 target:(UIViewController *)target firstHandler:(dispatch_block_t)firstHandler secondHandler:(dispatch_block_t)secondHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:actionStr1 style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (firstHandler) {
            firstHandler();
        }
    }];
    [alertController addAction:action1];
    if (actionStr2) {
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:actionStr2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (secondHandler) {
                secondHandler();
            }
        }];
        [alertController addAction:action2];
    }
    
    [target presentViewController:alertController animated:YES completion:nil];
}

// Key: 按照排序的key; ascending: YES为升序, NO为降序。
+ (NSArray *)arrayWithSort:(NSMutableArray *)dataArray key:(NSString *)key ascending:(BOOL)ascending {
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sorter count:1];
    [dataArray sortUsingDescriptors:sortDescriptors];
    return  dataArray;
}

@end
