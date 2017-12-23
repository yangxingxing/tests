//
//  AuditOrderCell.h
//  passenger
//
//  Created by 杨星星 on 2017/12/19.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "UITableViewCellCustom.h"
#import "OfficalOrderModel.h"
@class AuditOrderCell;

@protocol AuditOrderCellCustomDelegate <NSObject>

- (void)selectBtnClickWithCell:(AuditOrderCell *)cell;

- (void)PayTypeBtnClickWithCell:(AuditOrderCell *)cell btn:(UIButtonCustom *)btn;

@end

@interface AuditOrderCell : UITableViewCellCustom

@property (nonatomic,strong) OfficalOrderModel *model;

@property (nonatomic,weak) id<AuditOrderCellCustomDelegate> delegate;

@end
