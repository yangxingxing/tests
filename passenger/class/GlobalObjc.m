//
//  GlobalObjc.m
//  114SD
//
//  Created by 杨星星 on 2017/4/3.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "GlobalObjc.h"

@interface GlobalObjc () {
    NSMutableArray *_userAddressArray; // 收货地址
}



@end

@implementation GlobalObjc

//static GlobalObjc *global = nil;
//+ (instancetype)standardGlobal {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        global = [[GlobalObjc alloc] init];
//        global->_userAddressArray = [NSMutableArray array];
//    });
//    return global;
//}
//
//// 收货地址列表
//- (void)getUserAddressListWithSuccess:(dispatch_block_t)success fail:(dispatch_block_t)fail {
//    __weak typeof(self) wSelf = self;
//    HttpClient *client = [HttpClient httpWithReceived:^(NSDictionary *dict, NSInteger code) {
//        if (!wSelf) return;
//        SLog(@"收货地址=%@",dict);
//        if (code == SuccessCode) {
//            _userAddressArray = [NSMutableArray array];
//            NSArray *listArray = dict[@"data"];
//            for (NSDictionary *modelDic in listArray) {
//                UserAddressModel *model = [UserAddressModel new];
//                [model setValuesForKeysWithDictionary:modelDic];
//                [_userAddressArray addObject:model];
//
//                if (model.status > 0) {
//                    _defaultModel = model;
//                }
//            }
//            if (success) {
//                success();
//            }
//        } else {
//            [BusinessShowInfoView showInfo:dict[@"msg"]];
//        }
//    } Fail:^(NSString *error) {
//        if (!wSelf) return;
//        if (fail) {
//            fail();
//        }
//        [wShowInfoView showInfo:@"网络连接失败，请稍后重试"];
//    }];
//    [client getAddressList];
//
//}
//
//// 获取所有地址
//- (void)getAllIndexAreaWithSuccess:(dispatch_block_t)success fail:(dispatch_block_t)fail {
//    __weak typeof(self) wSelf = self;
//    HttpClient *client = [HttpClient httpWithReceived:^(NSDictionary *dict, NSInteger code) {
//        if (!wSelf) return;
//        SLog(@"%@",dict);
//        if (code == SuccessCode) {
//            NSArray *data = dict[@"data"];
//            NSMutableArray *provinceArr = [NSMutableArray array]; // 省份数组
//            for (NSDictionary *provinceDict in data) {
//                ProvinceModel *proModel = [ProvinceModel new];
//                [proModel setValuesForKeysWithDictionary:provinceDict];
//                NSMutableArray *cityArr = [NSMutableArray array]; // 城市数组
//                for (NSDictionary *cityDict in proModel.city) {
//                    CityModel *cityModel = [CityModel new];
//                    [cityModel setValuesForKeysWithDictionary:cityDict];
//                    NSMutableArray *areaArr = [NSMutableArray array]; //
//                    for (NSDictionary *areaDict in cityModel.area) {
//                        AreaModel *areaModel = [AreaModel new];
//                        [areaModel setValuesForKeysWithDictionary:areaDict];
//                        [areaArr addObject:areaModel];
//                    }
//                    cityModel.area = areaArr;
//                    [cityArr addObject:cityModel];
//                }
//                proModel.city = cityArr;
//                [provinceArr addObject:proModel];
//            }
//            _provinceArray = provinceArr;
//        } else {
//            [BusinessShowInfoView showInfo:dict[@"msg"]];
//        }
//    } Fail:^(NSString *error) {
//        if (!wSelf) return;
//        [wShowInfoView showInfo:FailHint];
//    }];
//    [client getAllIndexArea];
//}
//
//- (void)setDefaultModel:(UserAddressModel *)defaultModel {
//    _defaultModel = defaultModel;
//}


@end

