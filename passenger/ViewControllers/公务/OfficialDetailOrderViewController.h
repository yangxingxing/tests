//
//  OfficialDetailOrderViewController.h
//  passenger
//
//  Created by 杨星星 on 2017/12/20.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "PassengerBaseController.h"
#import "OfficalOrderModel.h"

typedef NS_ENUM(int,DetailOrderType) {
    DetailOrderHadApprove = 0,  // 已批准
    DetailOrderHadReject = 1,   // 已驳回
    DetailOrderIsApproval,       // 审批
};

@interface OfficialDetailOrderViewController : PassengerBaseController

@property (nonatomic,assign) DetailOrderType type; // 0-已批准 1-已驳回

@property (nonatomic,strong) OfficalOrderModel *model;

// 驳回
- (void)rejectBtnClick:(UIButtonCustom *)btn;

// 批准
- (void)approveBtnClick:(UIButtonCustom *)btn;

// 撤回返审
- (void)returnBtnClick:(UIButtonCustom *)btn;

@end

