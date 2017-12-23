//
//  OfficialDetailOrderViewController.m
//  passenger
//
//  Created by 杨星星 on 2017/12/20.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "OfficialDetailOrderViewController.h"
#import "SimpleCustomCell.h"
#import "RejectReasonView.h"
#import <ReactiveObjC.h>

@interface OfficialDetailOrderViewController () <UITableViewDelegate,UITableViewDataSource> {
    UITableView *_tableView;
    
    UIButtonCustom *_payTypeSelectedBtn; // 选择支付方式
    RejectReasonView *_rejectView;
}

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *detailDataArray;

@end

@implementation OfficialDetailOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
}

- (void)updateNavUI {
    self.headerTitle = @"订单详情";
}


- (void)initViews {
    _tableView = [MyTools createTableViewWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-64) delegate:self backgroundColor:UITableViewBackgroundColor rowHeight:50];
    [self.view addSubview:_tableView];
    [self initFootView];
}

- (void)initFootView {
    if (_type < DetailOrderIsApproval) { // 历史订单
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 100)];
        
        UIButtonCustom *returnBtn = [MyTools createButtonWithFrame:CGRectMake(20, 15, SCREENW-2*20, 50) title:@"撤回返审" titleColor:textWhiteColor imageName:nil backgroundImageName:nil target:self selector:@selector(returnBtnClick:)];
        [returnBtn setBorderWithRadius:returnBtn.height/2];
        returnBtn.backgroundColor = MainColor;
        [footView addSubview:returnBtn];
        
        _tableView.tableFooterView = footView;
    } else {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 100)];
        
        UIButtonCustom *rejectBtn = [MyTools createButtonWithFrame:CGRectMake(20, 15, SCREENW/2-2*20, 50) title:@"驳回" titleColor:textWhiteColor imageName:nil backgroundImageName:nil target:self selector:@selector(rejectBtnClick:)];
        [rejectBtn setBorderWithRadius:rejectBtn.height/2];
        rejectBtn.backgroundColor = textRedColorPass;
        [footView addSubview:rejectBtn];
        
        UIButtonCustom *approveBtn = [MyTools createButtonWithFrame:CGRectMake(SCREENW/2+20, rejectBtn.y, rejectBtn.width, rejectBtn.height) title:@"批准" titleColor:textWhiteColor imageName:nil backgroundImageName:nil target:self selector:@selector(approveBtnClick:)];
        [approveBtn setBorderWithRadius:approveBtn.height/2];
        approveBtn.backgroundColor = MainColor;
        [footView addSubview:approveBtn];
        
        _tableView.tableFooterView = footView;
    }
}

// 驳回
- (void)rejectBtnClick:(UIButtonCustom *)btn {
    if (_rejectView) {
        [_rejectView removeFromSuperview];
    }
    _rejectView = [RejectReasonView new];
    __weak typeof(self) wSelf = self;
    [[_rejectView rac_signalForSelector:@selector(confirmBtnClickWithText:)] subscribeNext:^(id  _Nullable x) {
        [_rejectView removeFromSuperview];
        _rejectView = nil;
        [wSelf close];
    }];
    [[_rejectView rac_signalForSelector:@selector(cancelBtnClick)] subscribeNext:^(id  _Nullable x) {
        [_rejectView removeFromSuperview];
        _rejectView = nil;
    }];
}

- (void)rejectBtnClickWithText:(NSString *)text {
    
}

// 批准
- (void)approveBtnClick:(UIButtonCustom *)btn {
    [self close];
}

// 撤回返审
- (void)returnBtnClick:(UIButtonCustom *)btn {
    [self close];
}

static CGFloat detailX = 90;
- (void)initData {
    NSString *detailText = @"参加第十九次人民，哈哈哈，需要参加第十九次人民代表大会";
    CGFloat height = [detailText boundingRectWithSize:CGSizeMake(SCREENW-detailX-10, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FontSize(15)} context:nil].size.height;
    _dataArray = @[@{TitleKey:@"预计费用",DetailTitleKey:@"￥80"},
                   @{TitleKey:@"申请人",DetailTitleKey:@"陈查查"},
                   @{TitleKey:@"用车事由",DetailTitleKey:detailText,@"height":[NSString stringWithFormat:@"%f",height]},
                   @{TitleKey:@"用车类型",DetailTitleKey:@"行政执法"},
                   @{TitleKey:@"用车信息",DetailTitleKey:@""},
                   @{TitleKey:@"预算",DetailTitleKey:@"已使用0.2万/剩余9.8万"},
                   @{TitleKey:@"支付方式",DetailTitleKey:@"财政支付"},].mutableCopy;
    if (_type == YES) {
        NSString *reasonText = @"不符合用车规定，不符合不符合用车规定，车身太长，走位太少，行程太短";
        CGFloat reasonHeight = [reasonText boundingRectWithSize:CGSizeMake(SCREENW-detailX-10, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FontSize(15)} context:nil].size.height;
        [_dataArray addObject:@{TitleKey:@"驳回说明",DetailTitleKey:reasonText,@"height":[NSString stringWithFormat:@"%f",reasonHeight]}];
    }
    
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return 125;
    } else if (indexPath.row == 2 || indexPath.row == 7) {
        NSDictionary *dict = _dataArray[indexPath.row];
        NSString *height = dict[@"height"];
        return height.floatValue + 34;
    } else if (indexPath.row == 6) {
        if (_type == DetailOrderIsApproval) {
            return 80;
        }
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewCellCustomLeftX;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UISectionHeaderView *headerView = [UISectionHeaderView headerWithHeight:UITableViewCellCustomLeftX];
    headerView.backgroundColor = UITableViewBackgroundColor;
    headerView.keepMoveSection = section;
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return [self createUseCarInfoWithtableView:tableView cellForRowAtIndexPath:indexPath];
    } else if (indexPath.row == 6) {
        return [self choosePayTypeWithtableView:tableView cellForRowAtIndexPath:indexPath];
    }
    static NSString *cellStr = @"SimpleCustomCell";
    SimpleCustomCell *customCell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!customCell) {
        customCell = [[SimpleCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        customCell.separatorAlign = SeparatorAlignLeft;
    }
    customCell.customTextLabel.textColor = textLightGrayColorPass;
    customCell.customDetailTextLabel.textColor = textGrayColorPass;
    customCell.customTextLabel.frame = CGRectMake(20, 0, 80, _tableView.rowHeight);
    customCell.customDetailTextLabel.frame = CGRectMake(detailX, 0, SCREENW-detailX-10, _tableView.rowHeight);
    customCell.customDetailTextLabel.numberOfLines = 0;
    customCell.customDetailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *dict = _dataArray[indexPath.row];
    customCell.customTextLabel.text = dict[TitleKey];
    customCell.customDetailTextLabel.text = dict[DetailTitleKey];
    customCell.customDetailTextLabel.font = customCell.customTextLabel.font = FontSize(15);
    customCell.customDetailTextLabel.textAlignment = NSTextAlignmentLeft;
    if (indexPath.row == 0) {
        customCell.customDetailTextLabel.textColor = textRedColorPass;
        customCell.customDetailTextLabel.font = FontSize(18);
    } else if (indexPath.row == 2) {
        NSString *height = dict[@"height"];
        customCell.customDetailTextLabel.frame = CGRectMake(detailX, 17, SCREENW-detailX-10, height.floatValue);
    } else if (indexPath.row == 7) {
        NSString *height = dict[@"height"];
        customCell.customDetailTextLabel.frame = CGRectMake(detailX, 17, SCREENW-detailX-10, height.floatValue);
    }
    
    return customCell;
}

// 支付方式
- (UITableViewCell *)choosePayTypeWithtableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"PayTypeCell";
    UITableViewCellCustom *customCell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!customCell) {
        customCell = [[UITableViewCellCustom alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    } else {
        [customCell removeAllSubviews];
    }
    
    UILabel *textLabel = [MyTools createLabelWithFrame  :CGRectMake(20, 0, 80, _type == DetailOrderIsApproval ? 40 : 50) text:@"支付方式" textColor:textLightGrayColorPass font:15];
    textLabel.textAlignment = NSTextAlignmentLeft;
    [customCell.contentView addSubview:textLabel];
    
    UIButtonCustom *firstBtn = [MyTools createButtonWithFrame:CGRectMake(detailX, 0, 180, textLabel.height) title:@"财政额度" titleColor:textGrayColorPass imageName:@"n_check_icon_content" backgroundImageName:nil target:self selector:@selector(firstPayBtnClick:)];
    [customCell.contentView addSubview:firstBtn];
    [firstBtn setImage:ImageNamed(@"h_check_icon_content") forState:(UIControlStateSelected)];
    
    firstBtn.imageViewFrame = CGRectMake(0, (firstBtn.height-16)/2, 16, 16);
    firstBtn.titleLabelFrame = CGRectMake(25, 0, firstBtn.width - 30, firstBtn.height);
    firstBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    firstBtn.titleLabel.font = FontSize(15);
    
    if (_type == DetailOrderIsApproval) {
        UIButtonCustom *secondBtn = [MyTools createButtonWithFrame:CGRectMake(firstBtn.x, CGRectGetMaxY(firstBtn.frame), firstBtn.width, firstBtn.height) title:@"单位额度" titleColor:textGrayColorPass imageName:@"n_check_icon_content" backgroundImageName:nil target:self selector:@selector(secondPayBtnClick:)];
        [customCell.contentView addSubview:secondBtn];
        [secondBtn setImage:ImageNamed(@"h_check_icon_content") forState:(UIControlStateSelected)];
        
        secondBtn.imageViewFrame = firstBtn.imageViewFrame;
        secondBtn.titleLabelFrame = firstBtn.titleLabelFrame;
        secondBtn.titleLabel.textAlignment = firstBtn.titleLabel.textAlignment;
        secondBtn.titleLabel.font = firstBtn.titleLabel.font;
        
        firstBtn.selected = _model.payType == 1;
        secondBtn.selected = !firstBtn.selected;
        
        _payTypeSelectedBtn = firstBtn.selected ? firstBtn : secondBtn;
    } else {
        [firstBtn setTitle:_model.payType == 1 ? @"财政支付" : @"单位支付" forState:(UIControlStateNormal)];
        [firstBtn setImage:ImageNamed(@"h_check_icon_content") forState:(UIControlStateNormal)];
    }
    
    
    return customCell;
}

- (void)firstPayBtnClick:(UIButtonCustom *)btn {
    _payTypeSelectedBtn.selected = NO;
    _payTypeSelectedBtn = btn;
    btn.selected = YES;
}

- (void)secondPayBtnClick:(UIButtonCustom *)btn {
    _payTypeSelectedBtn.selected = NO;
    _payTypeSelectedBtn = btn;
    btn.selected = YES;
}

// 用车信息
- (UITableViewCell *)createUseCarInfoWithtableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cell";
    UITableViewCellCustom *customCell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!customCell) {
        customCell = [[UITableViewCellCustom alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        customCell.separatorAlign = SeparatorAlignLeft;
    } else {
        [customCell removeAllSubviews];
    }
    
    UILabel *textLabel = [MyTools createLabelWithFrame:CGRectMake(20, 0, 80, _tableView.rowHeight) text:@"用车信息" textColor:textLightGrayColorPass font:15];
    textLabel.textAlignment = NSTextAlignmentLeft;
    [customCell.contentView addSubview:textLabel];
    
    UILabel *carTypeLabel = [MyTools createLabelWithFrame:CGRectMake(detailX, 17, 230*ScreenRate, 15) text:_model.carType ? _model.carType : @"未选择" textColor:textGrayColorPass font:15];
    [customCell.contentView addSubview:carTypeLabel];
    
    UILabel *timeLabel = [MyTools createLabelWithFrame:CGRectMake(carTypeLabel.x, CGRectGetMaxY(carTypeLabel.frame) + 10, carTypeLabel.width, carTypeLabel.height) text:_model.time textColor:textLightGrayColorPass font:15];
    [customCell.contentView addSubview:timeLabel];
    
    UIButtonCustom *startLocationBtn = [MyTools createButtonWithFrame:CGRectMake(timeLabel.x, CGRectGetMaxY(timeLabel.frame) + 10, timeLabel.width, timeLabel.height) title:_model.startLocation titleColor:textGrayColorPass imageName:@"green_circle" backgroundImageName:nil target:nil selector:nil];
    [customCell.contentView addSubview:startLocationBtn];
    
    
    UIButtonCustom *endLocationBtn = [MyTools createButtonWithFrame:CGRectMake(startLocationBtn.x, CGRectGetMaxY(startLocationBtn.frame) + 10, timeLabel.width, timeLabel.height) title:_model.endLocation titleColor:textGrayColorPass imageName:@"red_circle" backgroundImageName:nil target:nil selector:nil];
    [customCell.contentView addSubview:endLocationBtn];
    
    startLocationBtn.userInteractionEnabled = endLocationBtn.userInteractionEnabled = NO;
    endLocationBtn.imageViewFrame = startLocationBtn.imageViewFrame = CGRectMake(0, (startLocationBtn.height - 7)/2, 7, 7);
    endLocationBtn.titleLabelFrame = startLocationBtn.titleLabelFrame = CGRectMake(17, 0, startLocationBtn.width - 17, startLocationBtn.height);
    
    startLocationBtn.titleLabel.textAlignment = endLocationBtn.titleLabel.textAlignment = carTypeLabel.textAlignment = timeLabel.textAlignment = NSTextAlignmentLeft;
    startLocationBtn.titleLabel.font = endLocationBtn.titleLabel.font = FontSize(15);
    startLocationBtn.titleLabel.adjustsFontSizeToFitWidth = endLocationBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    if (_model.isReturn) {
        UILabel *returnLabel = [MyTools createLabelWithFrame:CGRectMake(SCREENW - 20 - 34, CGRectGetMaxY(carTypeLabel.frame) + 10, 40, 22) text:@"往返" textColor:textGrayColorPass font:12];
        returnLabel.centerY = carTypeLabel.centerY;
        returnLabel.textAlignment = NSTextAlignmentRight;
        [customCell.contentView addSubview:returnLabel];
    }
    
    if (_model.endLocation) {
        [endLocationBtn setTitle:_model.endLocation forState:UIControlStateNormal];
    } else if (_model.charteredBus) {
        [endLocationBtn setImage:nil forState:(UIControlStateNormal)];
        [endLocationBtn setTitleColor:textLightBlueColorPass forState:UIControlStateNormal];
        [endLocationBtn setTitle:_model.charteredBus forState:UIControlStateNormal];
    }
    
    return customCell;
}

@end
