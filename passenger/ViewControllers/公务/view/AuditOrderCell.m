//
//  AuditOrderCell.m
//  passenger
//
//  Created by 杨星星 on 2017/12/19.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "AuditOrderCell.h"

@interface AuditOrderCell() {
    UILabel *_nameLabel,*_phoneLabel,*_timeLabel;
    UIButtonCustom *_startLocationBtn,*_endLocationBtn;
    
    UIButtonCustom *_selectBtn;
    
    UILabel *_orderTypeLabel,*_carTypeLabel,*_returnLabel;
    
    UILabel *_moneyLabel; // 钱
    UIButtonCustom *_PayTypeBtn;
}

@end

@implementation AuditOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = textWhiteColor;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    {
        _selectBtn = [MyTools createButtonWithFrame:CGRectMake(0, 0, 40, 40) title:nil titleColor:nil imageName:@"n_check_icon_content" backgroundImageName:nil target:self selector:@selector(selectBtnClick:)];
        [_selectBtn setImage:ImageNamed(@"h_check_icon_content") forState:(UIControlStateSelected)];
        _selectBtn.imageViewFrame = CGRectMake(10, 10, 20, 20);
        [self.contentView addSubview:_selectBtn];
        
        _nameLabel = [MyTools createLabelWithFrame:CGRectMake(40, UITableViewCellCustomLeftX, 150, 15) text:nil textColor:textBlackColorPass font:15];
        [self.contentView addSubview:_nameLabel];
        
        _phoneLabel = [MyTools createLabelWithFrame:CGRectMake(_nameLabel.x, CGRectGetMaxY(_nameLabel.frame) + 7, _nameLabel.width, _nameLabel.height) text:nil textColor:MainColor font:15];
        [self.contentView addSubview:_phoneLabel];
        
        // 类型
        _orderTypeLabel = [MyTools createLabelWithFrame:CGRectMake(0, (_phoneLabel.y + CGRectGetMaxY(_nameLabel.frame))/2, _nameLabel.width, 22) text:nil textColor:textLightGrayColorPass font:14];
        [self.contentView addSubview:_orderTypeLabel];

        _carTypeLabel = [MyTools createLabelWithFrame:CGRectMake(0, _orderTypeLabel.y, _nameLabel.width, _orderTypeLabel.height) text:nil textColor:textLightGrayColorPass font:14];
        [self.contentView addSubview:_carTypeLabel];
        
        _returnLabel = [MyTools createLabelWithFrame:CGRectMake(0, _carTypeLabel.y, _nameLabel.width, _orderTypeLabel.height) text:@"往返" textColor:textLightGrayColorPass font:14];
        [self.contentView addSubview:_returnLabel];

        [_orderTypeLabel setBorderWithRadius:3 borderColor:textLightGrayColorPass borderWidth:1];
        [_carTypeLabel setBorderWithRadius:3 borderColor:textLightGrayColorPass borderWidth:1];
        [_returnLabel setBorderWithRadius:3 borderColor:textLightGrayColorPass borderWidth:1];
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(_nameLabel.x, CGRectGetMaxY(_phoneLabel.frame)+7, SCREENW - _nameLabel.x, 1)];
        [UIView drawDashLine:lineView lineLength:5 lineSpacing:3 lineColor:[UIColor colorWithHexString:@"#dddddd"]];
        [self.contentView addSubview:lineView];
        
        _timeLabel = [MyTools createLabelWithFrame:CGRectMake(_nameLabel.x, CGRectGetMaxY(lineView.frame) + leftSpace, 250*ScreenRate, 15) text:nil textColor:textLightGrayColorPass font:15];
        [self.contentView addSubview:_timeLabel];
        
        _moneyLabel = [MyTools createLabelWithFrame:CGRectMake(SCREENW - 15 - 100*ScreenRate, _timeLabel.y, 100*ScreenRate, 15) text:@"约" textColor:textGrayColorPass font:15];
        [self.contentView addSubview:_moneyLabel];
        
        _startLocationBtn = [MyTools createButtonWithFrame:CGRectMake(_nameLabel.x, CGRectGetMaxY(_timeLabel.frame) + 10, _timeLabel.width, _timeLabel.height) title:nil titleColor:textGrayColorPass imageName:@"green_circle" backgroundImageName:nil target:self selector:@selector(selectBtnClick:)];
        [self.contentView addSubview:_startLocationBtn];
        
        
        _endLocationBtn = [MyTools createButtonWithFrame:CGRectMake(_startLocationBtn.x, CGRectGetMaxY(_startLocationBtn.frame) + 10, _timeLabel.width, _timeLabel.height) title:nil titleColor:textGrayColorPass imageName:@"red_circle" backgroundImageName:nil target:self selector:@selector(selectBtnClick:)];
        [self.contentView addSubview:_endLocationBtn];
        
        _startLocationBtn.userInteractionEnabled = _endLocationBtn.userInteractionEnabled = NO;
        _endLocationBtn.imageViewFrame = _startLocationBtn.imageViewFrame = CGRectMake(0, (_startLocationBtn.height - 7)/2, 7, 7);
        _endLocationBtn.titleLabelFrame = _startLocationBtn.titleLabelFrame = CGRectMake(17, 0, _startLocationBtn.width - 17, _startLocationBtn.height);
        
        _startLocationBtn.titleLabel.textAlignment = _endLocationBtn.titleLabel.textAlignment = _timeLabel.textAlignment = _phoneLabel.textAlignment = _nameLabel.textAlignment = NSTextAlignmentLeft;
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        
//        CGFloat height = CGRectGetMaxY(_endLocationBtn.frame) + 19;
//        NSLog(@"height=%f",height);
        
        _PayTypeBtn = [MyTools createButtonWithFrame:CGRectMake(SCREENW - 15 - 120, _endLocationBtn.y, 120, _endLocationBtn.height) title:@"单位支付" titleColor:textGrayColorPass imageName:@"dropdownarrow_icon" backgroundImageName:nil target:self selector:@selector(PayTypeBtnClick:)];
        [_PayTypeBtn setImage:ImageNamed(@"dropUparrow_icon") forState:(UIControlStateSelected)];
        _PayTypeBtn.imageViewFrame = CGRectMake(_PayTypeBtn.width-8, (_PayTypeBtn.height-8)/2, 8, 8);
        _PayTypeBtn.titleLabelFrame = CGRectMake(0, 0, _PayTypeBtn.width-8-2, _PayTypeBtn.height);
        _PayTypeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _PayTypeBtn.titleLabel.font = FontSize(15);
        [self.contentView addSubview:_PayTypeBtn];
    }
}

- (void)selectBtnClick:(UIButtonCustom *)btn {
    btn.selected = !btn.selected;
    _model.isSelect = btn.selected;
    if(_delegate && [_delegate respondsToSelector:@selector(selectBtnClickWithCell:)]) {
        [_delegate selectBtnClickWithCell:self];
    }
}

- (void)PayTypeBtnClick:(UIButtonCustom *)btn {
    btn.selected = !btn.selected;
    if(_delegate && [_delegate respondsToSelector:@selector(PayTypeBtnClickWithCell:btn:)]) {
        [_delegate PayTypeBtnClickWithCell:self btn:btn];
    }
}

- (void)setModel:(OfficalOrderModel *)model {
    _model = model;
    _nameLabel.text = model.name;
    _timeLabel.text = model.time;
    _phoneLabel.text = model.phone;
    [_startLocationBtn setTitle:model.startLocation forState:(UIControlStateNormal)];
    _moneyLabel.text = [NSString stringWithFormat:@"约￥%@",model.money];
    
    _endLocationBtn.titleLabelFrame = CGRectMake(17, 0, _startLocationBtn.width - 17, _startLocationBtn.height);
    [_endLocationBtn setImage:ImageNamed(@"red_circle") forState:(UIControlStateNormal)];
    if (model.endLocation) {
        [_endLocationBtn setTitle:model.endLocation forState:(UIControlStateNormal)];
    } else if (model.charteredBus) {
        [_endLocationBtn setImage:nil forState:(UIControlStateNormal)];
        _endLocationBtn.titleLabelFrame = CGRectMake(0, 0, _endLocationBtn.width, _endLocationBtn.height);
        [_endLocationBtn setTitle:model.charteredBus forState:(UIControlStateNormal)];
    }
    
    _orderTypeLabel.hidden = _carTypeLabel.hidden = _returnLabel.hidden = YES;
    if (model.isReturn) {
        _returnLabel.hidden = NO;
    }
    if (model.orderType && model.orderType.length > 0) {
        _orderTypeLabel.hidden = NO;
        _orderTypeLabel.text = model.orderType;
    }
    if (model.carType && model.carType.length > 0) {
        _carTypeLabel.text = model.carType;
        _carTypeLabel.hidden = NO;
    }
    _selectBtn.selected = model.isSelect;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _selectBtn.centerY = self.height/2;
    [_orderTypeLabel sizeToFit];
    [_carTypeLabel sizeToFit];
    [_returnLabel sizeToFit];
    
    _returnLabel.frame = CGRectMake(_returnLabel.hidden ? SCREENW : SCREENW - _returnLabel.width - 10 - leftSpace, _returnLabel.y, _returnLabel.hidden ? 0 : _returnLabel.width + 10, 22);
    _returnLabel.centerY = (_phoneLabel.y + CGRectGetMaxY(_nameLabel.frame))/2;
    _carTypeLabel.frame = CGRectMake(_carTypeLabel.hidden ? _returnLabel.x : _returnLabel.x - 10 - _carTypeLabel.width - 10, _returnLabel.y, _carTypeLabel.hidden ? 0 : _carTypeLabel.width + 10, _returnLabel.height);

    _orderTypeLabel.frame = CGRectMake(_carTypeLabel.x - 10 - _orderTypeLabel.width - 10, _returnLabel.y, _orderTypeLabel.width + 10, _returnLabel.height);
}

@end
