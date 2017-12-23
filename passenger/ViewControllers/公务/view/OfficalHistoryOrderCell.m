//
//  OfficalHistoryOrderCell.m
//  passenger
//
//  Created by 杨星星 on 2017/12/20.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "OfficalHistoryOrderCell.h"

@interface OfficalHistoryOrderCell() {
    UILabel *_moneyLabel; // 钱
}

@end

@implementation OfficalHistoryOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [super initViews];
    _moneyLabel = [MyTools createLabelWithFrame:CGRectMake(self.backView.width - 15 - 100*ScreenRate, self.timeLabel.y, 100*ScreenRate, 15) text:@"约" textColor:textGrayColorPass font:15];
    _moneyLabel.adjustsFontSizeToFitWidth = YES;
    [self.backView addSubview:_moneyLabel];
    
    _moneyLabel.textAlignment = NSTextAlignmentRight;
}

- (void)setModel:(OfficalOrderModel *)model {
    [super setModel:model];
    _moneyLabel.text = [NSString stringWithFormat:@"约￥%@",model.money];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.carTypeLabel sizeToFit];
    [self.orderTypeLabel sizeToFit];
    [self.returnLabel sizeToFit];
    self.stateLabel.hidden = YES;
    
    CGFloat backViewWidth = SCREENW - 2*10;
    
    self.returnLabel.frame = CGRectMake(self.returnLabel.hidden ? backViewWidth : backViewWidth - self.returnLabel.width - 10 - leftSpace, self.returnLabel.y, self.returnLabel.hidden ? 0 : self.returnLabel.width + 10, 22);
    self.returnLabel.centerY = self.nameLabel.centerY;
    self.carTypeLabel.frame = CGRectMake(self.carTypeLabel.hidden ? self.returnLabel.x : self.returnLabel.x - 10 - self.carTypeLabel.width - 10, self.returnLabel.y, self.carTypeLabel.hidden ? 0 : self.carTypeLabel.width + 10,  self.returnLabel.height);
    
    self.orderTypeLabel.frame = CGRectMake(self.carTypeLabel.x - 10 - self.orderTypeLabel.width - 10, self.returnLabel.y, self.orderTypeLabel.width + 10, self.returnLabel.height);
    
    self.timeLabel.x = self.nameLabel.x;
}

@end
