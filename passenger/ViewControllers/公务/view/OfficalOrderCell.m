//
//  OfficalOrderCell.m
//  passenger
//
//  Created by 杨星星 on 2017/12/14.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "OfficalOrderCell.h"

@interface OfficalOrderCell() {
    UILabel *_startLocationLabel,*_endLocationLabel;
    UIView *_greenCircleView;
    UIButtonCustom *_useBtn;
}

@end

@implementation OfficalOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, SCREENW - 2*10, 140)];
    backView.backgroundColor = textWhiteColor;
    _backView = backView;

    [self.contentView addSubview:backView];
    backView.layer.cornerRadius  = 3;
    [backView setLayerShadow:textGrayColorPass offset:CGSizeMake(0.4, 0.4) radius:0.5];
    backView.layer.shadowOpacity = 0.5;
    
    {
        _nameLabel = [MyTools createLabelWithFrame:CGRectMake(10, 0, backView.width/2-10, 49) text:nil textColor:textBlackColorPass font:15];
        [backView addSubview:_nameLabel];
        
        _stateLabel = [MyTools createLabelWithFrame:CGRectMake(backView.width-_nameLabel.width-10, 0, _nameLabel.width, _nameLabel.height) text:nil textColor:textBlackColorPass font:15];
        [backView addSubview:_stateLabel];

        
        self.orderTypeLabel = [MyTools createLabelWithFrame:CGRectMake(0, 0, _nameLabel.width, 22) text:nil textColor:textLightGrayColorPass font:14];
        [backView addSubview:self.orderTypeLabel];
        
        self.carTypeLabel = [MyTools createLabelWithFrame:CGRectMake(0, 0, _nameLabel.width, self.orderTypeLabel.height) text:nil textColor:textLightGrayColorPass font:14];
        [backView addSubview:self.carTypeLabel];
        
        self.returnLabel = [MyTools createLabelWithFrame:CGRectMake(0, _carTypeLabel.y, _nameLabel.width, _orderTypeLabel.height) text:@"往返" textColor:textLightGrayColorPass font:14];
        [backView addSubview:self.returnLabel];
        
        self.orderTypeLabel.centerY = self.carTypeLabel.centerY = _nameLabel.centerY;
        [self.orderTypeLabel setBorderWithRadius:3 borderColor:textLightGrayColorPass borderWidth:1];
        [self.carTypeLabel setBorderWithRadius:3 borderColor:textLightGrayColorPass borderWidth:1];
        [self.returnLabel setBorderWithRadius:3 borderColor:textLightGrayColorPass borderWidth:1];
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameLabel.frame), backView.width, 1)];
        [UIView drawDashLine:lineView lineLength:5 lineSpacing:3 lineColor:[UIColor colorWithHexString:@"#dddddd"]];
        [backView addSubview:lineView];
    }
    
    {
        _timeLabel = [MyTools createLabelWithFrame:CGRectMake(10+17, CGRectGetMaxY(_stateLabel.frame) + 10, backView.width-10, 15) text:nil textColor:textLightGrayColorPass font:15];
        [backView addSubview:_timeLabel];
        
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(_nameLabel.x, 0, 7, 7)];
        redView.backgroundColor = textRedColorPass;
        [backView addSubview:redView];
        
        _greenCircleView = [[UIView alloc] initWithFrame:CGRectMake(_nameLabel.x, 0, 7, 7)];
        _greenCircleView.backgroundColor = textGreenColorPass;
        [backView addSubview:_greenCircleView];
        
        _greenCircleView.layer.masksToBounds = redView.layer.masksToBounds = YES;
        _greenCircleView.layer.cornerRadius = redView.layer.cornerRadius = _greenCircleView.height/2;
        
        _startLocationLabel = [MyTools createLabelWithFrame:CGRectMake(_timeLabel.x, CGRectGetMaxY(_timeLabel.frame)+10, backView.width - 85 - 5 - _timeLabel.x, 15) text:nil textColor:textGrayColorPass font:15];
        [backView addSubview:_startLocationLabel];
        
        
        _endLocationLabel = [MyTools createLabelWithFrame:CGRectMake(_startLocationLabel.x, CGRectGetMaxY(_startLocationLabel.frame)+10, _startLocationLabel.width, _startLocationLabel.height) text:nil textColor:textGrayColorPass font:15];
        [backView addSubview:_endLocationLabel];
        
        redView.centerY = _startLocationLabel.centerY;
        _greenCircleView.centerY = _endLocationLabel.centerY;
        
        _useBtn = [MyTools createButtonWithFrame:CGRectMake(backView.width - 75 - 10, 0, 75, 40) title:@"立即用车" titleColor:textWhiteColor imageName:nil backgroundImageName:nil target:self selector:@selector(userBtnClick)];
        [backView addSubview:_useBtn];
        _useBtn.backgroundColor = [UIColor colorWithHexString:@"#88c8f3"];
        [_useBtn setBorderWithRadius:_useBtn.height/2 borderColor:textWhiteColor];
        _useBtn.centerY = (backView.height + _nameLabel.height)/2;
        
        _useBtn.titleLabel.font = FontSize(15);
    }
    
    _nameLabel.textAlignment = _timeLabel.textAlignment = _startLocationLabel.textAlignment = _endLocationLabel.textAlignment = NSTextAlignmentLeft;
    _stateLabel.textAlignment = NSTextAlignmentRight;
}

- (void)setModel:(OfficalOrderModel *)model {
    _model = model;
    
    _nameLabel.text = model.title;
    _timeLabel.text = model.time;
    _startLocationLabel.text = model.startLocation;
    _endLocationLabel.textColor = textGrayColorPass;
    _greenCircleView.hidden = NO;
    self.orderTypeLabel.hidden = self.carTypeLabel.hidden = self.returnLabel.hidden = YES;
    if (model.isReturn) {
        _returnLabel.hidden = NO;
    }
    if (model.orderType && model.orderType.length > 0) {
        self.orderTypeLabel.hidden = NO;
        self.orderTypeLabel.text = model.orderType;
    }
    if (model.carType && model.carType.length > 0) {
        self.carTypeLabel.text = model.carType;
        self.carTypeLabel.hidden = NO;
    }
    
    if (model.endLocation) {
        _endLocationLabel.text = model.endLocation;
    } else if (model.charteredBus) {
        _greenCircleView.hidden = YES;
        _endLocationLabel.textColor = textLightBlueColorPass;
        _endLocationLabel.text = model.charteredBus;
    }
    _stateLabel.text = OfficalOrderStr[model.state];
    _stateLabel.textColor = textGreenColorPass;
    _useBtn.hidden = YES;
    if (model.state > OfficalOrderWaitSendCar && model.state < OfficalOrderUnApprove) {
        _stateLabel.textColor = textGrayColorPass;
    } else if (model.state == OfficalOrderHasApprove) {
        _useBtn.hidden = NO;
    } else if (model.state >= OfficalOrderUnApprove) {
        _stateLabel.textColor = textRedColorPass;
    }
    
}

- (void)userBtnClick {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.orderTypeLabel sizeToFit];
    [self.carTypeLabel sizeToFit];
    [_nameLabel sizeToFit];
    _nameLabel.height = 49;
    self.orderTypeLabel.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame) + 10, self.orderTypeLabel.y, self.orderTypeLabel.width + 10, 22);
    self.carTypeLabel.frame = CGRectMake(CGRectGetMaxX(self.orderTypeLabel.frame) + 10, self.orderTypeLabel.y, self.carTypeLabel.width + 10, self.orderTypeLabel.height);
}

/*  masksToBounds = YES 与 shadow共存
 _dropView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.8];
 _dropView.layer.cornerRadius = 8;
 _dropView.layer.masksToBounds = YES;
 CALayer *subLayer=[CALayer layer];
 
 CGRect fixframe=_dropView.layer.frame;
 
 fixframe.size.width=[UIScreen mainScreen].bounds.size.width-40;
 
 subLayer.frame=fixframe;
 
 subLayer.cornerRadius=8;
 
 subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
 
 subLayer.masksToBounds=NO;
 
 subLayer.shadowColor=[UIColor grayColor].CGColor;
 
 subLayer.shadowOffset=CGSizeMake(10,10);
 
 subLayer.shadowOpacity=0.5;
 
 subLayer.shadowRadius=8;
 
 [self.layer insertSublayer:subLayer below:_dropView.layer];
 */

@end
