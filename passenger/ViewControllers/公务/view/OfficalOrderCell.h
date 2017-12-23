//
//  OfficalOrderCell.h
//  passenger
//
//  Created by 杨星星 on 2017/12/14.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "UITableViewCellCustom.h"
#import "OfficalOrderModel.h"

@interface OfficalOrderCell : UITableViewCellCustom

@property (nonatomic,strong) OfficalOrderModel *model;

@property (nonatomic,assign) int from;

@property (nonatomic,strong) UILabel *orderTypeLabel;
@property (nonatomic,strong) UILabel *carTypeLabel;
@property (nonatomic,strong) UILabel *returnLabel;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIView *backView;

- (void)initViews;

@end
