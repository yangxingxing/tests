//
//  ShareClass.h
//  YunFu
//
//  Created by 杨星星 on 2017/8/18.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface ShareClass : NSObject

+ (void)shareWithImageArray:(NSArray *)imageArray
                      title:(NSString *)title
                       text:(NSString *)text
                        url:(NSURL *)url;

+ (void)shareWithPlatformType:(SSDKPlatformType)platformType
                   imageArray:(NSArray *)imageArray
                        title:(NSString *)title
                         text:(NSString *)text
                          url:(NSURL *)url;

@end
