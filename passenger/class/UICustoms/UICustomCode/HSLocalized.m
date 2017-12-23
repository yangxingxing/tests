//
//  HSLocalized.m
//  wBaiJu
//
//  Created by apple on 14-07-18.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import "HSLocalized.h"
#import <UIKit/UIDevice.h>

static HSLanguage kHSLanguage  = hslSimple;

static NSString *kUserLanguage = nil;

static NSBundle *kLanguageBundle = nil;

//语言字段 后缀
static NSString* const HSLanguageFixs[] =
{
    [hslSimple]      = @"",        //{中文简体}
    [hslTraditional] = @"_cht",    //{中文繁体},
    [hslEnglish]     = @"_en"      //{英文}
};

#define AppLanguage @"appLanguageOfUser"


@implementation HSLocalized


+ (NSString *)localStr:(NSString *)keyStr
{
    if (!kUserLanguage)
    {
        NSString *sLang = [[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage];
        kUserLanguage   = (sLang && sLang.length > 0) ? [sLang copy] : [@"" copy];
    }
    
    NSString *result = nil;
    if (kUserLanguage.length > 0)
    {
        if (!kLanguageBundle)
        {
            NSString * path = [[NSBundle mainBundle] pathForResource:kUserLanguage ofType:@"lproj"];
            kLanguageBundle = [NSBundle bundleWithPath:path];
#if ! __has_feature(objc_arc)
            [kLanguageBundle retain];
#endif

        }
        result = [kLanguageBundle localizedStringForKey:keyStr value:@"" table:nil];
    }
    else
        result = NSLocalizedString(keyStr, @"");
    return result;
}

+ (NSString *)lanuageFix
{
    return HSLanguageFixs[kHSLanguage];
}

+ (HSLanguage)language
{
    return kHSLanguage;
}

+ (void)setLanguage:(NSString *)language
{
    /*
     //IOS 设备设置语言
     NSString *identifier = [[NSLocale currentLocale] localeIdentifier]; // 比如Loacl是en_Zh
     NSString *displayName = [[NSLocale currentLocale] displayNameForKey:NSLocaleIdentifier value:identifier]; // displayName = “中国”
     NSLog(@"%@  %@", identifier, displayName);
     
     //APP当前使用的语言
     NSLog(@"preferredLocalizations: %@", [[NSBundle mainBundle] preferredLocalizations]);
     
     //当前APP所支持的所有语言
     NSLog(@"localizations: %@", [[NSBundle mainBundle] localizations]);
     
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
     //NSString *currentLanguage = [languages objectAtIndex:0];
     NSLog(@"AppleLanguages: %@", languages);
     */
    NSArray *langs = [[NSBundle mainBundle] preferredLocalizations];
    NSString *identifier = langs && langs.count > 0 ? langs[0] : [[NSLocale currentLocale] localeIdentifier];
    if (!language || [language isEqualToString:identifier])
        language = @"";
    
    if (language.length > 0)
    {
        //设置了非法语言
        NSArray *localizations = [[NSBundle mainBundle] localizations];
        if (![localizations containsObject:language])
            language = @"";
    }
    
    if (![language isEqualToString:kUserLanguage])
    {
        
#if ! __has_feature(objc_arc)
        if (kLanguageBundle)
            [kLanguageBundle release];
        if (kUserLanguage)
            [kUserLanguage release];
#endif
        
        kUserLanguage   = [language copy];
        kLanguageBundle = nil;
        
        if (kUserLanguage.length == 0)
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:AppLanguage];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:kUserLanguage forKey:AppLanguage];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString *sLang = kUserLanguage.length == 0 ? identifier :  kUserLanguage;
    sLang = [sLang substringToIndex:2];
    if ([sLang isEqualToString:@"en"])
        kHSLanguage = hslEnglish;
    else
        kHSLanguage = hslSimple;
}
static HSDriveType driveType = hsdtNone;

+ (HSDriveType)driveType
{
    if (driveType != hsdtNone)
        return driveType;
    UIUserInterfaceIdiom idiom = UI_USER_INTERFACE_IDIOM();
    if (idiom == UIUserInterfaceIdiomPad)
        driveType = hsdtiPad;
    else
    if (idiom == UIUserInterfaceIdiomPhone)
    {
        NSString *drive = [[UIDevice currentDevice] model]; //  [iPodParams driveName];
        driveType = [drive hasPrefix:@"iPod"] ? hsdtiPod : hsdtiPhone;
    }
    return driveType;
}

@end
