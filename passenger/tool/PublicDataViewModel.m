
//
//  PublicDataViewModel.m
//  FengShui
//
//  Created by 杨星星 on 2017/9/17.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "PublicDataViewModel.h"

@implementation PublicDataViewModel


//+ (void)getQNiuInfo {
//    __weak typeof(self) wSelf = self;
//    HttpClient *client = [HttpClient httpWithReceived:^(NSDictionary *dict, NSInteger code) {
//        if (!wSelf) return;
//        SLog(@"%@",dict);
//        if (code == SuccessCode) {
//            NSDictionary *data = dict[@"data"];
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            [userDefaults setValue:data[@"accessKey"] forKey:QNiuAccessKey];
//            [userDefaults setValue:data[@"secretKey"] forKey:QNiuSecretKey];
//            [userDefaults setValue:data[@"taobaostone"] forKey:QNiuFengshuiBaseUrl];
//            [userDefaults setValue:data[@"UPAUTO_HOST"] forKey:QNiuUPAUTO_HOST];
//            [userDefaults synchronize];
//        } else {
//            // [BusinessShowInfoView showInfo:dict[@"msg"]];
//        }
//    } Fail:^(NSString *error) {
//        if (!wSelf) return;
//        [wShowInfoView showInfo:FailHint];
//    }];
//    [client getQNiuInfo];
//}
//
//+ (void)getQNiuToken {
//    __weak typeof(self) wSelf = self;
//    HttpClient *client1 = [HttpClient httpWithReceived:^(NSDictionary *dict, NSInteger code) {
//        if (!wSelf) return;
//        SLog(@"%@",dict);
//        if (code == SuccessCode) {
//            NSDictionary *data = dict[@"data"];
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            [userDefaults setValue:data[@"token"] forKey:QNiuToken];
//            [userDefaults synchronize];
//        } else {
//            // [BusinessShowInfoView showInfo:dict[@"msg"]];
//        }
//    } Fail:^(NSString *error) {
//        if (!wSelf) return;
//        [wShowInfoView showInfo:FailHint];
//    }];
//    [client1 getQNiuToken];
//}

@end
