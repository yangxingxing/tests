//
//  PersonalViewController.h
//  passenger
//
//  Created by 杨星星 on 2017/12/14.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "PassengerBaseController.h"

typedef NS_ENUM(int,UseCarType) {
    UseCarTypePersonal, // 个人
    UseCarTypeOfficial, // 公务
};

@interface PersonalViewController : PassengerBaseController

@property (nonatomic,strong) PassengerBaseController *nacController;

@property (nonatomic,assign) int useCarType;

@end
