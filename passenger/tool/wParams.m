//
//  wParams.m
//  wBaiJu
//  微佰聚 参数类
//  Created by apple on 12-3-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "wParams.h"
#import "wComm.h"
#import "HSLocalized.h"
#import "UIImageCategory.h"
#import "WBJUIFont.h"


static SysParams       *kHSParams = nil;

//static AsyncSocketClient  *kSocketClient = nil;


//Reachability  *hostReach;

//static NSString* const SErrorCodeDbFile = @"returnCode.db";

@interface SysParams()
{
//    SQLiteDataBase  *_dbErrorCode;
//    UserInfo        *_userInfo;
}

@end

@implementation SysParams


+(instancetype)getParams
{
    @synchronized(self){
        if (!kHSParams)
        {
            kHSParams = [[SysParams alloc] init];
            [kHSParams loadParams];
        }
    }
    return kHSParams;
}

+(void)setParams:(SysParams*)aParams;
{
    if (!aParams && kHSParams)
    {
        [kHSParams release];
        kHSParams = nil;
    }
    kHSParams = aParams;
}


-(void)loadParams
{
//    if (hostReach) {
//        [hostReach release];
//        hostReach = nil;
//    }

    
    //SQLiteDataReader *reader = [[SQLiteDataReader alloc] initWithSQLite:kDbConfig
    //                                                                SQL:@"SELECT Key,Value FROM t_ichat_config"];
    //while ([reader read]) {
        //char *key = [reader valCStr:0];
        //char *val = [reader valCStr:1];
        
        //if (strcmp(key, SParamsServerIP) == 0)  //服务器IP
        //    [_serverIP setString:[NSString stringWithUTF8String:val]];
    //}
    //[reader release];
}


-(NSDictionary*)getConfigItems
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    /*
    SysParamKey *paramKey = nil;
    NSMutableArray *subParams = nil;
    
    subParams = [[NSMutableArray alloc] init];
    
    //服务器端口
    paramKey = [[HSParamKey alloc] init];
    paramKey.key = SParamServerPort;
    paramKey.value = [NSString stringWithFormat:@"%d", serverPort];
    paramKey.group = paramKeySocket;
    paramKey.caption = [self localStr:@"Port"];        //端口:
    paramKey.valType = hspvtInt;
    [subParams addObject:paramKey];
    [paramKey release];
    
    [result setObject:subParams forKey:paramKey.group];
    [subParams release];
    
    subParams = [[NSMutableArray alloc] init];
    
    //点菜时合并编号相同的菜品
    paramKey = [[SysParamKey alloc] init];
    paramKey.key = SParamsIsTogetherFood;
    paramKey.value = [NSString stringWithFormat:@"%d", (int)isTogetherFood];
    paramKey.group = paramKeyTake;
    paramKey.caption = [self localStr:@"TogetherDish"];  //点单时合并编号相同的商品
    paramKey.valType = hspvtBool;
    [subParams addObject:paramKey];
    [paramKey release];
@property (nonatomic, result setObject:subParams forKey:paramKey.group];
    [subParams release];
    */
    
    return [result autorelease];
}


//-(UserInfo *)getUserInfo
//{
//    if (!_userInfo)
//    {
//        if (self.socketClient.lastLoginUserId <= 0)
//            _userInfo = [[UserInfo alloc] init];
//        else
//        {
//            _userInfo = [UserInfo userForKeyId:self.socketClient.lastLoginUserId];
//            [_userInfo retain];
//        }
//    }
//    return _userInfo;
//}


-(NSString *)readValue:(char *)AKey
{
    __block NSString *result = nil;
//    SQLiteDataBase *db = self.dbConfig;
    //[db execInBack:^{
        NSString * sWhere = [NSString stringWithFormat: @"Key='%s'", AKey];
//        result = [db lookUpText:@"t_ichat_config" field:@"Value" where:sWhere];
    //}];
    
    return result;
}

-(void)beginSaveParams
{
    [[self dbConfig] beginTransaction];
}

-(void)endSaveParams
{
    [[self dbConfig] commit];
}

-(void)saveSingleParam:(char *)AKey Value:(NSString*)AValue
{


}

-(NSString*)languageFix
{
    return [HSLocalized lanuageFix];
}

-(NSString *)localStr:(NSString*)localStr
{
    return [HSLocalized localStr:localStr];
}

/*
-(Reachability*)gethostReach
{
    if (!hostReach)
    {
        hostReach = [Reachability reachabilityWithHostName:SSocketServerAddress];
        [hostReach retain];
    }
    return hostReach;
}

-(BOOL)canConnectSvr
{
    return self.hostReach.currentReachabilityStatus != NotReachable;
}
*/

-(void)setSoundHint:(BOOL)value
{
    [Comm setSoundHint:value];
}

-(BOOL)getSoundHint
{
    return [Comm getSoundHint];
}

/*
-(void)copyDBFile
{
    //NSHomeDirectory()
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentLibraryFolderPath = [documentsDirectory stringByAppendingPathComponent:SErrorCodeDbFile];
    NSFileManager *fm = [NSFileManager defaultManager];
    //if (![fm fileExistsAtPath:documentLibraryFolderPath])
    {
        
        NSString *resourceFolderPath =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:SErrorCodeDbFile];
        
        //NSLog(@"resourceSampleImagesFolderPath=%@",resourceFolderPath);
        NSData *mainBundleFile = [NSData dataWithContentsOfFile:resourceFolderPath];
        //NSLog(@"mainBundleFile==%@",mainBundleFile);
        [fm createFileAtPath:documentLibraryFolderPath
                    contents:mainBundleFile
                  attributes:nil];
    };
}
 */


//创建图片目录
-(void)createImagesDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE);
    _imagesDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"images"];
    [_imagesDir retain];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (! [fm fileExistsAtPath:_imagesDir])
    {
        NSError *error;
        [fm createDirectoryAtPath:_imagesDir
      withIntermediateDirectories:TRUE
                       attributes:nil
                            error:&error];
    }
    
    NSString *businessImgDir = [_imagesDir stringByAppendingPathComponent:@"Business"];
    if (! [fm fileExistsAtPath:businessImgDir])
    {
        NSError *error;
        [fm createDirectoryAtPath:businessImgDir
      withIntermediateDirectories:TRUE
                       attributes:nil
                            error:&error];
    }
    _bigImageDir = [_imagesDir stringByAppendingPathComponent:@"bigImage"];
    [_bigImageDir retain];
    if (! [fm fileExistsAtPath:_imagesDir])
    {
        NSError *error;
        [fm createDirectoryAtPath:_imagesDir
      withIntermediateDirectories:TRUE
                       attributes:nil
                            error:&error];
    }
}

//创建声音目录
-(void)createVoicesDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE);
    _voicesDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Voices"];
    [_voicesDir retain];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (! [fm fileExistsAtPath:_voicesDir])
    {
        NSError *error;
        [fm createDirectoryAtPath:_voicesDir
      withIntermediateDirectories:TRUE
                       attributes:nil
                            error:&error];
    }
}

//创建视频目录
-(void)createVideoDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE);
    _videoDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Videos"];
    [_videoDir retain];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (! [fm fileExistsAtPath:_videoDir])
    {
        NSError *error;
        [fm createDirectoryAtPath:_videoDir
      withIntermediateDirectories:TRUE
                       attributes:nil
                            error:&error];
    }
}

-(void)createEmojiOfGifDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE);
    _emojiOfGifDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"EmojiOfGif"];
    [_emojiOfGifDir retain];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (! [fm fileExistsAtPath:_emojiOfGifDir])
    {
        NSError *error;
        [fm createDirectoryAtPath:_emojiOfGifDir
      withIntermediateDirectories:TRUE
                       attributes:nil
                            error:&error];
    }
    NSString *path = [_emojiOfGifDir stringByAppendingPathComponent:@"0"];
    if (![fm fileExistsAtPath:path]) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}


-(id)init
{
    self = [super init];
    if (self) {
        
        [WBJUIFont fontLevel];
        
        //hostReach = nil;
        [self createImagesDir];
        [self createVoicesDir];
        [self createVideoDir];
        [self createEmojiOfGifDir];
        
        //[self copyDBFile]
        
        _driveType = [HSLocalized driveType];
        _sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
        
        // 监测网络情况
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillTerminate)
                                                     name: UIApplicationWillTerminateNotification
                                                   object: nil];
        if ([[UIButton appearance] respondsToSelector:@selector(setExclusiveTouch)])
            [[UIButton appearance] setExclusiveTouch:YES];
    }
    return self;
}

-(void)applicationWillTerminate
{
    [SysParams setParams:nil];
}

-(UIImage*)imageLocal:(NSString*)imageName AssignNone:(BOOL)assignNone
{
    NSString *sFile = [self imageFile: imageName];
    UIImage *image = nil;
    if ([Comm fileExists:sFile])
    {
        image = [UIImage imageWithContentsOfFile:sFile];
        if (image)
            image = [image tranToSelf];
    }
    if (assignNone && !image)
        image = self.unHasIconImage;
    return image;
}

-(NSString*)imageFile:(NSString*)imageName
{
    if (![NSString vaildateStr: imageName])
        return SStringEmpty;
    return [_imagesDir stringByAppendingPathComponent: imageName];  //[NSString stringWithFormat:@"%@.png", imageName]
}

-(NSString*)voiceFile:(NSString*)voiceName;
{
    if (![NSString vaildateStr: voiceName])
        return SStringEmpty;
    return [_voicesDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr", voiceName]];
}

//取得本地手机上 视频全路径
-(NSString*)videoFile:(NSString*)videoName
{
    if (![NSString vaildateStr: videoName])
        return SStringEmpty;
    if (videoName.length > SStringMP4.length)
    {
        if ([videoName compare:SStringMP4 options:NSCaseInsensitiveSearch
                         range:NSMakeRange(videoName.length - SStringMP4.length, SStringMP4.length)] != NSOrderedSame)
            videoName = [videoName stringByAppendingString:SStringMP4];
    }
    return [_videoDir stringByAppendingPathComponent:videoName];
}

- (NSString *)readError:(NSInteger)code
{
    NSString * field;
    switch ([HSLocalized language]) {
        case hslSimple:            //{中文简体}
            field =  @"discribe";
            break;
        case hslTraditional:      //{中文繁体}
            field =  @"discribe_Ch_Trad";
            break;
        case hslEnglish:          //{英文}
            field =  @"discribe_Eng";
            break;
        default:
            break;
    }
    NSString* sWhere = [NSString stringWithFormat:@"code=%ld", (long)code];
    return nil;
}

-(NSString*)apiUrl
{
    NSString *s = _serverUrl;
    if (![NSString vaildateStr: s] || s.length == 0)
        s = _baseUrl;
    return [s stringByAppendingString:@"/cgi/"];
}

-(void)dealloc
{
    [_imagesDir release];
    [_imagesDir release];
    [_voicesDir release];
    [_videoDir release];

    [_emojiOfGifDir release];

    self.wBaiJuUrl = nil;
    self.serverUrl = nil;
    self.baseUrl   = nil;
    self.baseUrl1  = nil;
    //if (hostReach)
    //    [hostReach release];
    
    if (_buttonAddImage)
        [_buttonAddImage release];
    
    if (_buttonBackImage)
        [_buttonBackImage release];
    
    if (_unHasIconImage)
        [_unHasIconImage release];

    [super dealloc];
}

@end

@implementation SysParamKey


-(void)dealloc
{
    self.value   = nil;
    self.group   = nil;
    self.caption = nil;
    [super dealloc];
}

@end
