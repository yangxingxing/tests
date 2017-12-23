//
//  OfficalOrderModel.h
//  passenger
//
//  Created by 杨星星 on 2017/12/14.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(int,OfficalOrderState) {
    OfficalOrderHasApprove  = 1,
    OfficalOrderWaitSendCar = 2,
    OfficalOrderWaitApprove = 3,
    OfficalOrderHadCancel   = 4,
    OfficalOrderHadFinish   = 5,
    OfficalOrderHadClose    = 6,
    OfficalOrderUnApprove   = 7,
};

static NSString *OfficalOrderStr[] = {
    [OfficalOrderHasApprove]     = @"已批准",
    [OfficalOrderWaitSendCar]    = @"待派车",
    [OfficalOrderWaitApprove]    = @"待审批",
    [OfficalOrderHadCancel]      = @"已取消",
    [OfficalOrderHadFinish]      = @"已结束",
    [OfficalOrderHadClose]       = @"已关闭",
    [OfficalOrderUnApprove]      = @"被驳回",
};

@interface OfficalOrderModel : BaseModel

@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) int state;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *startLocation;
@property (nonatomic,copy) NSString *endLocation;
@property (nonatomic,copy) NSString *charteredBus; // 包车
@property (nonatomic,copy) NSString *orderType;  // 订单类型
@property (nonatomic,copy) NSString *carType;  // 车类型
@property (nonatomic,copy) NSString *phone; // 手机号码
@property (nonatomic,assign) int isReturn;  // 往返
@property (nonatomic,copy) NSString *money; // 需要多少钱
@property (nonatomic,copy) NSString *name;  // 司机
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,assign) int payType; // 支付方式

@end
