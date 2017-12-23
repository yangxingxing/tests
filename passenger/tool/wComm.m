//
//  wMsgbox.m
//  wBaiJu
//
//  Created by apple on 12-2-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "wComm.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "HSLocalized.h"
#import <mach/mach_time.h>
#import <sys/utsname.h>
#import "wParams.h"


@class WBJAVAudioPlayer;

static BOOL kSoundHint = YES;

static SystemSoundID kNotifyAudioSoundId = 0;

static WBJAVAudioPlayer *kReceivedAudioPlayer = nil;
static SystemSoundID kReceivedAudioSoundId = 0;

static SystemSoundID kPresenAudioSoundId = 0;
static SystemSoundID kSendMessageSoundId = 0;

@interface UIAlertViewComm : UIAlertView

@end

@implementation UIAlertViewComm

-(void)show
{
    [super show];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSelf)
                                                 name:@"mctShutdown" object:nil];
}

-(void)removeSelf{
    
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end

@interface WBJAVAudioPlayer : AVAudioPlayer
<AVAudioPlayerDelegate>

@property(nonatomic)MessageSoundType soundType;

@end

@implementation WBJAVAudioPlayer


-(instancetype)initWithContentsOfURL:(NSURL *)url error:(NSError **)outError
{
    self = [super initWithContentsOfURL:url error:outError];
    if (self)
    {
        self.delegate = self;
    }
    return self;
}

-(void)stopPlayer
{
    if (kReceivedAudioPlayer)
    {
        [kReceivedAudioPlayer release];
        kReceivedAudioPlayer = nil;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stopPlayer];
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    [self stopPlayer];
}

@end


@implementation Comm

+(void)setSoundHint:(BOOL)value
{
    kSoundHint = value;
}

+(BOOL)getSoundHint
{
    return kSoundHint;
}

+(void)playMsgVibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

//当音频播放完毕会调用这个函数
static void presenSoundFinished(SystemSoundID soundId,void* sample){
    
    /*播放全部结束，因此释放所有资源 */
    AudioServicesDisposeSystemSoundID(soundId);
    //if (sample)
    //    CFBridgingRelease(sample);  //会报错
    //CFRunLoopStop(CFRunLoopGetCurrent());
    
    kPresenAudioSoundId = 0;
}

+(void)playPresenSound
{
    if (kPresenAudioSoundId > 0)
        return;
    
    NSURL *soundPath = [[NSBundle mainBundle] URLForResource:@"diaoluo_da" withExtension:@"mp3"];
    if (!soundPath)
        return;
    
    CFURLRef urlRef = (CFURLRef)soundPath; //[NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID(urlRef, &kPresenAudioSoundId);
    AudioServicesAddSystemSoundCompletion(kPresenAudioSoundId, NULL, NULL, presenSoundFinished, &urlRef);
    AudioServicesPlaySystemSound(kPresenAudioSoundId);
}

//当音频播放完毕会调用这个函数
static void sendMessageSoundFinished(SystemSoundID soundId,void* sample){
    
    /*播放全部结束，因此释放所有资源 */
    AudioServicesDisposeSystemSoundID(soundId);
    //if (sample)
    //    CFBridgingRelease(sample);  //会报错
    //CFRunLoopStop(CFRunLoopGetCurrent());
    
    kSendMessageSoundId = 0;
}

//发送消息 声音
+(void)playSendMessage
{
    //NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"sent_message" ofType:@"mp3"];
    NSURL *soundPath = [[NSBundle mainBundle] URLForResource:@"sent_message" withExtension:@"mp3"];
    if (!soundPath || kSendMessageSoundId > 0)
        return;
    CFURLRef urlRef = (CFURLRef)soundPath;  //[NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID(urlRef, &kSendMessageSoundId);
    AudioServicesAddSystemSoundCompletion(kSendMessageSoundId, NULL, NULL, sendMessageSoundFinished, &urlRef);
    AudioServicesPlaySystemSound(kSendMessageSoundId);
}

//当音频播放完毕会调用这个函数
static void notifySoundFinished(SystemSoundID soundId,void* sample){
    
    /*播放全部结束，因此释放所有资源 */
    AudioServicesDisposeSystemSoundID(soundId);
    //if (sample)
    //    CFBridgingRelease(sample);  //会报错
    //CFRunLoopStop(CFRunLoopGetCurrent());
    
    kNotifyAudioSoundId = 0;
}

+(void)playMsgSoud
{
    if (!kSoundHint || kNotifyAudioSoundId > 0)
        return;

//    NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"notify" ofType:@"wav"];
//    if (!soundPath)
//        return;
    NSURL *soundPath = [[NSBundle mainBundle] URLForResource:@"notify" withExtension:@"wav"];
    if (!soundPath)
        return;
    
    CFURLRef urlRef = (CFURLRef)soundPath;  //[NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID(urlRef, &kNotifyAudioSoundId);
    AudioServicesAddSystemSoundCompletion(kNotifyAudioSoundId, NULL, NULL, notifySoundFinished, &urlRef);
    AudioServicesPlaySystemSound(kNotifyAudioSoundId);
}

static SystemSoundID sysDefaultSystemSoundID = 1007;
//当音频播放完毕会调用这个函数
static void SoundFinished(SystemSoundID soundId,void* sample){

    /*播放全部结束，因此释放所有资源 */
    if (soundId != sysDefaultSystemSoundID)
        AudioServicesDisposeSystemSoundID(soundId);
    //if (sample)
    //    CFRelease(sample);;  //会报错
    //CFRunLoopStop(CFRunLoopGetCurrent());
    
    kReceivedAudioSoundId = 0;
}

+(void)playMsgReceivedSound:(MessageSoundType)soundType Vibration:(BOOL)vibration WaitDone:(BOOL)waitDone
{
    if (waitDone && kReceivedAudioSoundId > 0)
        return;
    
    if (vibration)
        [[self class] playMsgVibrate];
    
    //不播放声音
    if (mstNone == soundType)
        return;
    
    
    if (kReceivedAudioSoundId > 0)
        SoundFinished(kReceivedAudioSoundId, nil);
    
    NSString *soundPath = nil;
    switch (soundType) {
        case mstNormal:  //标准  meximexi
            //soundPath = [[NSBundle mainBundle] pathForResource:@"meximexi" ofType:@"mp3"];
            soundPath = [[NSBundle mainBundle] pathForResource:@"chord" ofType:@"caf"];
            break;
        case mstDiDi:     //嘀嘀
            soundPath = [[NSBundle mainBundle] pathForResource:@"dingdong" ofType:@"mp3"];
            break;
        case mstSystem:
            //soundPath = @"/System/Library/Audio/UISounds/begin_video_record.caf";
            kReceivedAudioSoundId = sysDefaultSystemSoundID;
            break;
        default:
            break;
    }
    
    CFURLRef urlRef = nil;
    if (kReceivedAudioSoundId == 0)
    {
        if (!soundPath)
            return;
        
        urlRef = (__bridge CFURLRef)[NSURL fileURLWithPath:soundPath];
        AudioServicesCreateSystemSoundID(urlRef, &kReceivedAudioSoundId);
    }
    AudioServicesAddSystemSoundCompletion(kReceivedAudioSoundId, NULL, NULL, SoundFinished, &urlRef);
    AudioServicesPlaySystemSound(kReceivedAudioSoundId);
}

/*
+(void)playMsgReceivedSound2:(MessageSoundType)soundType Vibration:(BOOL)vibration WaitDone:(BOOL)waitDone
{
    if (waitDone && kReceivedAudioPlayer)
        return;
    
    if (vibration)
        [[self class] playMsgVibrate];
    
    //不播放声音
    if (mstNone == soundType)
        return;

    if (kReceivedAudioPlayer)
    {
        if (kReceivedAudioPlayer.soundType == soundType)
            return;
        [kReceivedAudioPlayer release];
    }
    kReceivedAudioPlayer = nil;
    
    NSOperationQueue *operationQueue = [[NSOperationQueue  alloc] init];
    [operationQueue addOperationWithBlock: ^{
        
        NSString *soundPath = nil;
        switch (soundType) {
            case mstNormal:  //标准  meximexi
                soundPath = [[NSBundle mainBundle] pathForResource:@"meximexi" ofType:@"mp3"];
                break;
            case mstDiDi:     //嘀嘀
                soundPath = [[NSBundle mainBundle] pathForResource:@"classic" ofType:@"mp3"];
                break;
            case mstSystem:
                soundPath = @"/System/Library/Audio/UISounds/begin_video_record.caf";
                break;
            default:
                break;
        }
        if (!soundPath)
            return;
        
        AVAudioSession* session = [AVAudioSession sharedInstance];
        
        NSError* error;
        //使用扬声器
        AVAudioSessionPortOverride audioPort = AVAudioSessionPortOverrideSpeaker;
        [session overrideOutputAudioPort:audioPort
                                   error:&error];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        
        NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath];
        
        kReceivedAudioPlayer = [[WBJAVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
        kReceivedAudioPlayer.soundType = soundType;
        if (error) {
            //NSLog(@"出错了");
        }
        [soundUrl release];
        if (kReceivedAudioPlayer)
            [kReceivedAudioPlayer prepareToPlay];
        
        if (kReceivedAudioPlayer)
            [kReceivedAudioPlayer play];
    }];
    [operationQueue release];
}
*/

+(void)playMsgReceivedSound
{
    SysParams *params = [SysParams getParams];
    
    [[self class] playMsgReceivedSound:params.messageSoundType
                           Vibration:params.messageVibration
                            WaitDone:true];
}

+(void)stopSounds
{
    if (kPresenAudioSoundId > 0)
        presenSoundFinished(kPresenAudioSoundId, nil);
    
    if (kSendMessageSoundId > 0)
        sendMessageSoundFinished(kSendMessageSoundId, nil);
        
    if (kNotifyAudioSoundId > 0)
        notifySoundFinished(kNotifyAudioSoundId, nil);
    
    if (kReceivedAudioSoundId > 0)
        SoundFinished(kReceivedAudioSoundId, nil);
}

/// <summary>
/// 显示错误信息
/// </summary>
/// <param name="msg"></param>
+(void)errorMsg:(NSString*)msg
{
    [Comm playMsgSoud];
    
    dispatch_main_sync_safe(^{
        
        UIAlertViewComm *alter = [[UIAlertViewComm alloc] initWithTitle: [HSLocalized localStr: @"Error"]
                                                        message: msg
                                                       delegate:nil
                                              cancelButtonTitle:[HSLocalized localStr: @"OK"]//, @"确定")
                                              otherButtonTitles:nil];
        [alter show];
        [alter release];
    });
}

/// <summary>
/// 显示错误信息
/// </summary>
/// <param name="msg"></param>
+(void)errorMsg:(NSString*)msg Title:(NSString*)title
{
    [Comm playMsgSoud];
    
    dispatch_main_sync_safe(^{
        
        UIAlertViewComm *alter = [[UIAlertViewComm alloc] initWithTitle: title
                                                        message: msg
                                                       delegate:nil
                                              cancelButtonTitle:[HSLocalized localStr: @"OK"]//, @"确定")
                                              otherButtonTitles:nil];
        [alter show];
        [alter release];
    });
}


/// <summary>
/// 显示信息框
/// </summary>
/// <param name="message"></param>
+(void)showMsg:(NSString *)msg
{
    dispatch_main_sync_safe(^{
        UIAlertViewComm *alter = [[UIAlertViewComm alloc] initWithTitle:@"提示"//, @"提示")
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"//, @"确定")
                                              otherButtonTitles:nil];
        [alter show];
        [alter release];
    });
    [Comm playMsgSoud];
}

//显示警告信息
+(void)warningMsg:(NSString *)msg
{
    dispatch_main_sync_safe(^{
        UIAlertViewComm *alter = [[UIAlertViewComm alloc] initWithTitle:[HSLocalized localStr: @"Warning"]//, @"警告")
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:[HSLocalized localStr: @"OK"]//, @"确定")
                                              otherButtonTitles:nil];
        [alter show];
        [alter release];
    });
    [Comm playMsgSoud];
}

/// <summary>
/// 格式显示数字
/// </summary>
/// <param name="value"></param>
/// <returns></returns>
+ (NSString *)formatFloat:(double)value Digits:(int)digits
{            
    NSString *fmt = [NSString stringWithFormat:@"%%.%df", digits];
    return [NSString stringWithFormat:fmt, value];
}


//生成按每个字符模糊查找
+ buildLikeStrs:(NSString *)aFilterStr
{
    NSMutableString *result = [NSMutableString stringWithString:@"%"];
    for (int i = 0; i < aFilterStr.length; i++) {
        [result appendFormat:@"%@%%", [aFilterStr substringWithRange:NSMakeRange(i, 1)]];
    }
    return result;
}


+ (NSString *)guid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    return uuid;
}

+ (BOOL)fileExists:(NSString *)file
{
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:file];
}

//根据原有Size  按比例 转
+ (CGSize)tranSizeFrom:(CGSize)baseSize ToSize:(CGSize)toSize
{
    CGFloat w = baseSize.width;
    CGFloat h = baseSize.height;
    
    CGFloat rate = 1.0;
    if (w > toSize.width || h > toSize.height)
    {
        if (toSize.width / w > toSize.height / h)
            rate = toSize.height / h;
        else
            rate = toSize.width / w;
    }
    
    
    if (rate > 0)
    {
        w = w * rate;
        h = h * rate;
    }
    if (w > toSize.width)
        w = toSize.width;
    
    if (h > toSize.height)
        h = toSize.height;
    return CGSizeMake(w, h);
}

//根据 秒 转为小时 分钟 字符串
+ (NSString *)secondToTimeStr:(float)second
{
    int h = (int)floor(second / 360.0f);
    second -= h * 360;
    int m = (int)floor(second / 60.0f);
    second -= m * 60;
    int s = (int)floor(second);
    
    NSMutableString *showtimeNew = [NSMutableString string];
    
    if (h > 0)
        [showtimeNew appendFormat:@"%02d:", h];
    [showtimeNew appendFormat:@"%02d:", m];
    [showtimeNew appendFormat:@"%02d", s];
    
    return showtimeNew;

}

//根据 byte 转为kb mb 字符串
+ (NSString *)byteSizeToStr:(long)bytes
{
    float mb = bytes / (1024.0f * 1024.0f);
    NSMutableString *result = nil;
    if (((int)floor(mb)) > 0)
        result = [NSMutableString stringWithFormat:@"%.1fM", mb];
    else
    {
        float kb = bytes / 1024.0f;
        if (((int)floor(kb)) > 0)
            result = [NSMutableString stringWithFormat:@"%.1fK", kb];
    }
    if (result != nil)
    {
        NSRange range = NSMakeRange(result.length - 3, 2);
        NSString *last = [result substringWithRange:range];
        if ([last compare:@".0"] == NSOrderedSame)
            [result replaceCharactersInRange:range withString:SStringEmpty];
        return result;
    }

    return [NSString stringWithFormat:@"%ldB", bytes];
}

static NSString *SEncryptEmptyStr = nil;
static NSString *const SEncryptKey = @"(@9a=!!~`%5^A)&_~$#5.?Vf*-";

+ (NSString *)encryptStr:(NSString *)src
{
    if (!SEncryptEmptyStr)
    {
        SEncryptEmptyStr = [NSString stringWithFormat:@"qztigo8FE89985EE8A422C8C1%c%c%c%c%c", 
                            (char)1 ,(char)3, (char)4, (char)6, (char)7];
        [SEncryptEmptyStr retain];  //必须将记数加1，不然多次验证空密码时会报错
    }
    
    NSInteger SrcLen = 0;
    if (src)
        SrcLen = src.length;
    if (SrcLen == 0)
    {
        NSString *s = [Comm encryptStr: SEncryptEmptyStr];
        if ([s isEqualToString: SEncryptEmptyStr])
            return SStringEmpty;
        else
            return s;
    }
    
    NSMutableString *sLongKey = [[NSMutableString alloc] init];
    for (int i = 0; i <= (SrcLen / SEncryptKey.length); i++)
        [sLongKey appendString: SEncryptKey];
    
    char* srcChars = (char *)[src UTF8String];
    char* sLongKeyChars = (char *)[sLongKey UTF8String];
    NSMutableString *result = [NSMutableString stringWithString:SStringEmpty];
    for (int i = 0; i < SrcLen; i++)
    {
        int C = (int)srcChars[i] ^ (int)sLongKeyChars[i];
        if (C == 0)
            C = (int)sLongKeyChars[i];
        
        [result appendFormat:@"%c", (char)C];
    }
    [sLongKey release];
    return result;
}

+ (uint64_t)tickCount
{
    static const int64_t kOneMillion = 1000 * 1000;
    static mach_timebase_info_data_t s_timebase_info;
    
    if (s_timebase_info.denom == 0) {
        (void) mach_timebase_info(&s_timebase_info);
    }
    
    // mach_absolute_time() returns billionth of seconds,
    // so divide by one million to get milliseconds
    return ((mach_absolute_time() * s_timebase_info.numer) / (kOneMillion * s_timebase_info.denom));
}

//获取随机数
+ (int)randomNumber:(int)from To:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

//object 转float
+ (float)objToFloat:(id)val
{
    double result = 0.0;
    if (val)
    {
        result = [val doubleValue];
        if (isnan(result))
            result = 0.0;
    }
    return result;
}

//object 转 double
+ (double)objToDouble:(id)val
{
    long double result = 0.0;
    if (val)
    {
        result = [val doubleValue];
        if (isnan(result))
            result = 0.0;
    }
    return result;
}

+ (id)nullOf:(id)val to:(id)toVal
{
    if (!val || [val isKindOfClass:[NSNull class]] ||
        ([val isKindOfClass:[NSString class]] && ([val isEqualToString:@"<null>"] ||
                                                  [val isEqualToString:@"(null)"])))
        return toVal;
    return val;
}

// stringByAddingPercentEscapesUsingEncoding不对@ & 等编码，所以自已特殊处理
//+(NSString*)httpEncode:(NSString*)str
//{
//    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
//}

//根据传入图片数组,生成图片数组 位置返回
//images 图片数组 最多处理9张
//aWidth 宽度
//aSpace 行列简隔
+ (NSArray *)calcRectsWithImages:(NSArray *)images Width:(float)aWidth Space:(float)aSpace;
{
    CGFloat bW = aSpace; //1.5f;
    CGFloat w = 0;
    int rowCount = 1;
    int colCount = 1;
    if (images.count >= 2)
        colCount = 2;
    if (images.count >= 3)
        rowCount = 2;
    if (images.count >= 5)
    {
        colCount = 3;
        if (images.count > 6)
            rowCount = 3;
    }
    
    int ic = colCount;  //如果只有一列时, 改为两列
    if (ic == 1)
        ic++;
    w = (aWidth - (bW * (ic + 1))) / ic;
    
    int row = rowCount - 1;
    int col = colCount - 1;
    
    CGFloat y = (aWidth - (w *rowCount)- bW *(rowCount+1)) / 2.0f;
    CGFloat x = images.count > 1 ? 0.0f : w / 2.0f;   //如果只有 1张图片 左右 居中
    
    NSMutableArray *result = [NSMutableArray array];
    int iCount = (int)images.count;
    if (iCount > 9)
        iCount = 9;
    for (int i = iCount - 1; i >= 0; i--) {
        
        CGRect r = CGRectMake(x + bW + (w + bW) * col ,
                              (y + bW + (w + bW) * row), w, w);
        
        [result addObject:[NSValue valueWithCGRect:r]];
        col--;
        if (col < 0)
        {
            col = colCount - 1;
            row --;
            //第一行,如果数量 小于列数时,位置左右居中
            if (row == 0 && i < colCount && x == 0)
                x = -(aWidth - (w *i)- bW *(i+1)) / 2.0f;
        }
    }
    return result;
}

//根据传入多张图片,排版 画成一张图
//images 图片数组 最多处理9张
//aWidth 宽度
//aSpace 行列简隔
+ (UIImage *)drawImageWithImages:(NSArray *)images Width:(float)aWidth Space:(float)aSpace
{
    CGRect rect = CGRectMake(0, 0, aWidth, aWidth);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    [[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] set];
    UIRectFill(rect);
    
    
    NSArray *array = [self calcRectsWithImages:images Width: aWidth Space: aSpace];
    
    for (int i = 0 ; i < (int)array.count; i++) {
        
        NSValue *value = array[i];
        CGRect r = [value CGRectValue];
        [images[i] drawInRect:r];
    }
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//重新设置 ViewController View Frame
+ (void)resetNavViewFrame
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.keyWindow.rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController*)app.keyWindow.rootViewController;
        CGRect r = [[UIScreen mainScreen] bounds];
        nav.view.frame = CGRectMake(0, 0, r.size.width, r.size.height);
        //        for (UIViewController *wv in nav.viewControllers) {
        //            wv.view.frame = CGRectMake(0, 0, r.size.width, r.size.height);
        //        }
    }
}

//图片居中显示
+ (void)setImageViewCenterFromSupperView:(UIImageView *)imageView
{
    CGSize  s = imageView.image.size;
    CGRect  r = imageView.superview.frame;
    if (s.width > s.height * 2.0 || s.height > s.width * 2.0)
    {
        CGRect rect = imageView.frame;
        CGFloat w = MIN(r.size.width, r.size.height); //考虑 有时 横屏，有时竖屏
        CGFloat rate = 1;
//        if (s.width > s.height * 2) //横屏
//        {
//            CGFloat rate = w / s.height;
//            rect.size.height = w;
//            rect.size.width  = (s.width * rate);
//        }
//        else
        {
            CGFloat rate = w / s.width;
            rect.size.width = w;
            rect.size.height = (s.height * rate);
        }
        
        //大长图、大竖图 要可以滚动，小图直接用控件自适应 imageView.contentMode = UIViewContentModeScaleAspectFit;
        //if (rect.size.height > r.size.height || rect.size.width > r.size.width * 2.0) //图片大于superView的高
        {
            if (rect.size.height <= r.size.height)
                rect.origin.y = (r.size.height - rect.size.height) * 0.5;
            
            if (rect.size.width <= r.size.width)
                rect.origin.x = (r.size.width - rect.size.width) * 0.5;
            
            //如果是UIScrollView 调整 contentSize
            if (imageView.superview && [imageView.superview isKindOfClass:[UIScrollView class]])
            {
                UIScrollView *parent = (UIScrollView *)imageView.superview;
                parent.contentSize = rect.size;
                rate = MAX(s.height, s.width) / w;
                parent.maximumZoomScale = MAX(rate, 2.5);
            }
            else
            //调整高度到 上上级View高度
            if (imageView.superview.superview)
            {
                if (rect.size.width > r.size.width * 2.0)
                {
                    rect.origin.x    = 0;
                    rect.size.width = imageView.superview.superview.frame.size.width;
                    r.size.width    = rect.size.width;
                    imageView.superview.frame = r;
                }
                else
                if (rect.size.height > imageView.superview.superview.frame.size.height)
                {
                    rect.origin.y    = 0;
                    rect.size.height = imageView.superview.superview.frame.size.height;
                    r.size.height    = rect.size.height;
                    imageView.superview.frame = r;
                }
            }
        }
        
        if (s.width > s.height * 2)
        {
            r.origin = CGPointZero;
            imageView.frame = r;
        }
        else
        {
            imageView.frame = rect;
        }
    }
    else
    {
        r.origin = CGPointZero;
        imageView.frame = r;
    }

 
    imageView.contentMode = UIViewContentModeScaleAspectFit;
}

+ (UIViewAutoresizing)exchAutoSizeMask:(UIViewAutoresizing)mask
{
    //上 下 左 右，要取反值，如：上 要UIViewAutoresizingFlexibleBottomMargin
    NSInteger totalMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;  //1 + 8 + 4 + 32 = 45
    NSInteger dec = 0;
    NSInteger add = 0;
    
    if ((UIViewAutoresizingFlexibleLeftMargin & mask) == UIViewAutoresizingFlexibleLeftMargin)
        dec += UIViewAutoresizingFlexibleLeftMargin;
    if ((UIViewAutoresizingFlexibleTopMargin & mask) == UIViewAutoresizingFlexibleTopMargin)
        dec += UIViewAutoresizingFlexibleTopMargin;
    if ((UIViewAutoresizingFlexibleRightMargin & mask) == UIViewAutoresizingFlexibleRightMargin)
        dec += UIViewAutoresizingFlexibleRightMargin;
    if ((UIViewAutoresizingFlexibleBottomMargin & mask) == UIViewAutoresizingFlexibleBottomMargin)
        dec += UIViewAutoresizingFlexibleBottomMargin;
    
    //宽 高 是相加
    if ((UIViewAutoresizingFlexibleWidth & mask) == UIViewAutoresizingFlexibleWidth)
        add += UIViewAutoresizingFlexibleWidth;
    
    if ((UIViewAutoresizingFlexibleHeight & mask) == UIViewAutoresizingFlexibleHeight)
        add += UIViewAutoresizingFlexibleHeight;
    
    return totalMask - dec + add;
}

+ (NSString *)urlEncode:(NSString *) str UsingEncoding:(NSStringEncoding)encoding {
    
    return [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                (CFStringRef)str,
                                                                NULL,
                                                                (CFStringRef)@"!*'&\"();:@=+$,/?%#[]% ",
                                                                CFStringConvertNSStringEncodingToEncoding(encoding)) autorelease];
}

@end
