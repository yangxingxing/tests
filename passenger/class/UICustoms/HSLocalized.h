//
//  wLocalized.h

//  读取多语言字符资源
//  Created by apple on 14-06-18.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HSLanguage)
{
    hslSimple      = 0,      //{中文简体}
    hslTraditional = 1,      //{中文繁体},
    hslEnglish     = 2      //{英文}
};

typedef NS_ENUM(NSInteger, HSDriveType)
{
    hsdtNone = 0,
    hsdtiPad = 1,   //iPad
    hsdtiPod = 2,   //iPod
    hsdtiPhone = 3  //iPhone
};

#define LocalizedString(key) \
  [HSLocalized localStr:key]

@interface HSLocalized : NSObject

+ (NSString *)localStr:(NSString *)keyStr;

+ (NSString *)lanuageFix;

+ (HSLanguage)language;

+ (void)setLanguage:(NSString *)language;

+ (HSDriveType)driveType;

@end
