//
//  PersonalViewController.m
//  passenger
//
//  Created by 杨星星 on 2017/12/14.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "PersonalViewController.h"
#import "MapFactory.h"
#import <ReactiveObjC.h>
#import "ChangePassengerViewController.h"
#import "OfficialUserCarTypeController.h"

@interface PersonalViewController () {
    UIView * _lineView;
    UIButtonCustom *_selectedBtn; // 顶部选中按钮
    
    UIButtonCustom *_selectCarBtn; // 车型
    
    UIButtonCustom *_returnBtn;
    
    UIView *_chooseView;
    
    UIButtonCustom *_startPointBtn;
    MapFactory *_factory; // 地图
    
    UIView *_bottomView;
    
    UseCarTypeModel *_selectedModel; // 用车类型
}

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_useCarType == UseCarTypeOfficial) {
        self.headerTitle = @"公务用车申请";
    }
    if (nil == self.nacController) {
        self.nacController = self;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - 搭建页面
- (void)initViews {
    self.view.backgroundColor = UITableViewBackgroundColor;
    [self setScrollBtn];
    [self createChooseView];
    [self initBottomView];
    [self createMapView];
}

static CGFloat lineStart = 20;
// 选择栏
- (void)createChooseView {
    if (_chooseView) {
        [_chooseView removeFromSuperview];
    }
    UIView *chooseView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+UITableViewCellCustomLeftX, SCREENW, 200)];
    chooseView.backgroundColor = textWhiteColor;
    CGFloat height = 0;
    _chooseView = chooseView;
    
    // 选择乘车人
    {
        UIView *choosePassengerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, chooseView.width, UITableViewRowHeight)];
        
        [choosePassengerView lineVerticalWithPoint:CGPointMake(lineStart, choosePassengerView.height-UILineBorderWidth) toPoint:CGPointMake(choosePassengerView.width - lineStart, choosePassengerView.height-UILineBorderWidth) andColor:textLightGrayColorPass];
        [choosePassengerView lineVerticalWithPoint:CGPointMake(choosePassengerView.width/2, 7) toPoint:CGPointMake(choosePassengerView.width/2, 7+30) andColor:textLightGrayColorPass];
        
        // 选择乘车人
        UIButtonCustom *passengerBtn = [MyTools createButtonWithFrame:CGRectMake(lineStart, 0, SCREENW/2 - lineStart - 10, choosePassengerView.height) title:@"自己" titleColor:textGrayColorPass imageName:@"enterinto_icon_content" backgroundImageName:nil target:self selector:@selector(passengerBtnClick:)];
        [choosePassengerView addSubview:passengerBtn];
        
        // 选择出发时间
        UIButtonCustom *timeBtn = [MyTools createButtonWithFrame:CGRectMake(SCREENW/2 + 10, 0, passengerBtn.width, passengerBtn.height) title:@"即走" titleColor:textGrayColorPass imageName:@"enterinto_icon_content" backgroundImageName:nil target:self selector:@selector(timeBtnClick:)];
        [choosePassengerView addSubview:timeBtn];
        
        passengerBtn.titleLabel.textAlignment =  timeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        passengerBtn.titleLabelFrame = timeBtn.titleLabelFrame = CGRectMake(0, 0, passengerBtn.width - 20, passengerBtn.height);
        passengerBtn.imageViewFrame = timeBtn.imageViewFrame = CGRectMake(passengerBtn.width - 20, (passengerBtn.height-30)/2, 30, 30);
        
        
        height = CGRectGetMaxY(choosePassengerView.frame);
        [chooseView addSubview:choosePassengerView];
    }
    
    
    {
        // 起点
        UIView *startPointView = [[UIView alloc] initWithFrame:CGRectMake(0, height, chooseView.width, UITableViewRowHeight)];
    
        [startPointView lineVerticalWithPoint:CGPointMake(lineStart, startPointView.height-UILineBorderWidth) toPoint:CGPointMake(startPointView.width - lineStart, startPointView.height-UILineBorderWidth) andColor:textLightGrayColorPass];
        
        UIButtonCustom *startPointBtn = [MyTools createButtonWithFrame:CGRectMake(lineStart, 0, startPointView.width - 2*lineStart, startPointView.height) title:@"正在获取上车位置..." titleColor:textBlackColorPass imageName:@"green_circle" backgroundImageName:nil target:self selector:@selector(startPointBtnClick:)];
        _startPointBtn = startPointBtn;
        [startPointView addSubview:startPointBtn];
        height = CGRectGetMaxY(startPointView.frame);
        [chooseView addSubview:startPointView];
        
        
        
        // 终点
        UIView *endPointView = [[UIView alloc] initWithFrame:CGRectMake(0, height, chooseView.width, UITableViewRowHeight)];
        
        [endPointView lineVerticalWithPoint:CGPointMake(lineStart, endPointView.height-UILineBorderWidth) toPoint:CGPointMake(endPointView.width - lineStart, endPointView.height-UILineBorderWidth) andColor:textLightGrayColorPass];
        
        UIButtonCustom *endPointBtn = [MyTools createButtonWithFrame:CGRectMake(lineStart, 0, startPointView.width - 2*lineStart, startPointView.height) title:@"要去哪儿" titleColor:textGrayColorPass imageName:@"red_circle" backgroundImageName:nil target:self selector:@selector(endPointBtnClick:)];
        
        startPointBtn.imageViewFrame = CGRectMake(0, (startPointBtn.height - 12)/2, 12, 12);
        startPointBtn.titleLabelFrame = CGRectMake(22, 0, startPointBtn.width - 22, startPointBtn.height);
        
        if (_selectedBtn.tag == 1) {
            [endPointBtn setTitle:@"选择包车类型" forState:(UIControlStateNormal)];
            [endPointBtn setImage:ImageNamed(@"enterinto_icon_content") forState:(UIControlStateNormal)];
            endPointBtn.imageViewFrame = CGRectMake(endPointBtn.width - 20, (endPointBtn.height-30)/2, 30, 30);
            endPointBtn.titleLabelFrame = CGRectMake(0, 0, startPointBtn.width - 20, startPointBtn.height);
        } else {
            endPointBtn.imageViewFrame = startPointBtn.imageViewFrame;
            endPointBtn.titleLabelFrame = startPointBtn.titleLabelFrame;
        }
        
        // 返程
        if (_useCarType == UseCarTypeOfficial && _selectedBtn.tag == 0) { // 公务
            if (!_returnBtn) {
                UIButtonCustom *returnBtn = [MyTools createButtonWithFrame:CGRectMake(endPointBtn.width - 60, 0, 60, endPointBtn.height) title:@"需返程" titleColor:textLightGrayColorPass imageName:@"n_check_icon_content" backgroundImageName:nil target:self selector:@selector(returnBtnClick:)];
                _returnBtn =returnBtn;
                returnBtn.titleLabel.font = FontSize(12);
                [returnBtn setImage:ImageNamed(@"h_check_icon_content") forState:(UIControlStateSelected)];
                returnBtn.imageViewFrame = CGRectMake(3, (returnBtn.height-12)/2, 12, 12);
                returnBtn.titleLabelFrame = CGRectMake(10, 0, returnBtn.width-10, returnBtn.height);
                returnBtn.titleLabel.textAlignment = NSTextAlignmentRight;
            }
            [endPointBtn addSubview:_returnBtn];
        } else {
            [_returnBtn removeFromSuperview];
        }
        
        
        endPointBtn.titleLabel.textAlignment = startPointBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        endPointBtn.titleLabel.font = startPointBtn.titleLabel.font = FontSize(15);
        
        [endPointView addSubview:endPointBtn];
        height = CGRectGetMaxY(endPointView.frame);
        [chooseView addSubview:endPointView];
    }
    
    if (_useCarType == UseCarTypeOfficial) { // 公务
        UIView *chooseUseCarTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, height, chooseView.width, UITableViewRowHeight)];
        
        [chooseUseCarTypeView lineVerticalWithPoint:CGPointMake(lineStart, chooseUseCarTypeView.height-UILineBorderWidth) toPoint:CGPointMake(chooseUseCarTypeView.width - lineStart, chooseUseCarTypeView.height-UILineBorderWidth) andColor:textLightGrayColorPass];
        [chooseUseCarTypeView lineVerticalWithPoint:CGPointMake(chooseUseCarTypeView.width/2, 7) toPoint:CGPointMake(chooseUseCarTypeView.width/2, 7+30) andColor:textLightGrayColorPass];
        
        // 选择用车类型
        UIButtonCustom *useCarTypeBtn = [MyTools createButtonWithFrame:CGRectMake(lineStart, 0, SCREENW/2 - lineStart - 10, chooseUseCarTypeView.height) title:@"选择用车类型" titleColor:textLightGrayColorPass imageName:@"enterinto_icon_content" backgroundImageName:nil target:self selector:@selector(useCarTypeBtnClick:)];
        [chooseUseCarTypeView addSubview:useCarTypeBtn];
        
        // 填写用车说明
        UIButtonCustom *timeBtn = [MyTools createButtonWithFrame:CGRectMake(SCREENW/2 + 10, 0, useCarTypeBtn.width, useCarTypeBtn.height) title:@"填写用车说明" titleColor:textLightGrayColorPass imageName:nil backgroundImageName:nil target:self selector:@selector(useCarDesClick:)];
        [chooseUseCarTypeView addSubview:timeBtn];
        
        useCarTypeBtn.titleLabel.textAlignment = timeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        useCarTypeBtn.titleLabelFrame = CGRectMake(0, 0, useCarTypeBtn.width - 20, useCarTypeBtn.height);
        timeBtn.titleLabelFrame = CGRectMake(0, 0, useCarTypeBtn.width, useCarTypeBtn.height);
        useCarTypeBtn.imageViewFrame = CGRectMake(useCarTypeBtn.width - 20, (useCarTypeBtn.height-30)/2, 30, 30);
        useCarTypeBtn.titleLabel.font = timeBtn.titleLabel.font = FontSize(15);
        
        height = CGRectGetMaxY(chooseUseCarTypeView.frame);
        [chooseView addSubview:chooseUseCarTypeView];
    }
    
    {
        static NSString *unSelectedImage = @"unSelectedImage";
        static NSString *selectedImage = @"selectedImage";
        static NSString *titleKey = @"titleKey";
        
        UIScrollView *carScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height, SCREENW, 56)];
        carScrollView.showsHorizontalScrollIndicator = NO;
        carScrollView.backgroundColor = textWhiteColor;
        
        NSArray *dataArr = nil;
        if (_selectedBtn.tag == 1) { // 包车
            dataArr = @[@{unSelectedImage:@"n_comfort_icon_content",selectedImage:@"h_comfort_icon_content",titleKey:@"舒适型(5座)"},@{unSelectedImage:@"n_businesstype_icon_content",selectedImage:@"h_businesstype_icon_content",titleKey:@"商务型(7座)"},@{unSelectedImage:@"n_minibus_icon_content",selectedImage:@"h_minibus_icon_content",titleKey:@"小巴(24座)"},@{unSelectedImage:@"n_coach_icon_content",selectedImage:@"h_coach_icon_content",titleKey:@"大巴(50座)"}];
        } else {
            dataArr = @[@{unSelectedImage:@"n_comfort_icon_content",selectedImage:@"h_comfort_icon_content",titleKey:@"优选型"},@{unSelectedImage:@"n_optimizationh_icon_content",selectedImage:@"h_optimizationh_icon_content",titleKey:@"舒适型"},@{unSelectedImage:@"n_businesstype_icon_content",selectedImage:@"h_businesstype_icon_content",titleKey:@"商务型"}];
        }
        
        for (int i = 0 ;i < dataArr.count; i++) {
            NSDictionary *dict = dataArr[i];
            UIButtonCustom *selectCarBtn = [MyTools createButtonWithFrame:CGRectMake(i*SCREENW/dataArr.count, 0, SCREENW/dataArr.count, carScrollView.height) title:dict[titleKey] titleColor:textGrayColorPass imageName:dict[unSelectedImage] backgroundImageName:nil target:self selector:@selector(scrollBtnClick:)];
            
            CGFloat imageWidth = 35;
            [selectCarBtn setTitleColor:textLightBlueColorPass forState:(UIControlStateSelected)];
            [selectCarBtn setImage:ImageNamed(dict[selectedImage]) forState:(UIControlStateSelected)];
            
            selectCarBtn.imageViewFrame = CGRectMake((selectCarBtn.width - imageWidth)/2, 0, imageWidth, imageWidth);

            selectCarBtn.titleLabelFrame = CGRectMake(0 , CGRectGetMaxY(selectCarBtn.imageViewFrame), selectCarBtn.width, 15);
            selectCarBtn.titleLabel.font = FontSize(13);
            selectCarBtn.titleLabel.textAlignment = NSTextAlignmentCenter;

            selectCarBtn.tag = i;
            [carScrollView addSubview:selectCarBtn];
        }
        
//        carScrollView.contentSize = CGSizeMake(dataArr.count*SCREENW/dataArr.count, carScrollView.height);
        height = CGRectGetMaxY(carScrollView.frame);
        [chooseView addSubview:carScrollView];
    }
    
    chooseView.height = height;
    [self.view addSubview:chooseView];
}

- (void)createMapView {
    _factory = [[MapFactory alloc] init:1];
    UIView* mapView = [_factory getView:CGRectMake(0, CGRectGetMaxY(_chooseView.frame), SCREENW, _bottomView.y - CGRectGetMaxY(_chooseView.frame) + 64)];
    [RACObserve(_factory, detailLocation)  subscribeNext:^(id  _Nullable x) {
        NSString *location = x;
        if (location.length > 0) {
            [_startPointBtn setTitle:location forState:(UIControlStateNormal)];
        }
    }];
    [self.view addSubview:mapView];
}

- (void)initBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENH - 114 - 64, SCREENW, 114)];
    _bottomView = bottomView;
    bottomView.backgroundColor= textWhiteColor;
    
    UILabel *moneyLabel = [MyTools createLabelWithFrame:CGRectMake(0, 10, bottomView.width, 25) text:nil textColor:textBlackColorPass font:18];
    [bottomView addSubview:moneyLabel];
    moneyLabel.attributedText = [MyTools getDifferentFontAndColorWithString:[NSString stringWithFormat:@"%@元",@"10"] containStr:@"10" font:24 color:textRedColorPass];
    
    
    UILabel *kilometerLabel = [MyTools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(moneyLabel.frame) , bottomView.width, 15) text:nil textColor:textGrayColorPass font:12];
    [bottomView addSubview:kilometerLabel];
    kilometerLabel.text = @"5.59公里，打车约15元";
    
    UIButtonCustom *commitBtn = [MyTools createButtonWithFrame:CGRectMake(0, bottomView.height - 10 - 48, 265, 48) title:@"提交申请" titleColor:textWhiteColor imageName:nil backgroundImageName:nil target:self selector:@selector(commitBtnClick:)];
    [commitBtn setBorderWithRadius:commitBtn.height/2];
    commitBtn.backgroundColor = textLightBlueColorPass;
    [bottomView addSubview:commitBtn];
    commitBtn.centerX = moneyLabel.centerX;
    
    [self.view addSubview:bottomView];
}

#pragma mark - 按钮点击
// 顶部按钮
- (void)setScrollBtn {
    NSArray * titleArray = @[@"日常",@"包车"];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 44)];
    [topView addBottomLine];
    topView.backgroundColor = textWhiteColor;
    [self.view addSubview:topView];
    
    
    
    // 创建顶部按钮
    for (int i = 0; i < titleArray.count; i++) {
        UIButtonCustom * button = [UIButtonCustom buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(topView.width/2+(i-1)*70, 0, 70, topView.height);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:textGrayColorPass forState:UIControlStateNormal];
        [button setTitleColor:TopBtnSelectedColor forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
//        [button lineVerticalWithPoint:CGPointMake(0, button.height - UILineBorderWidth) toPoint:CGPointMake(button.width, button.height - UILineBorderWidth)];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        button.tag = i;
        if (!i) {
            button.selected = YES;
            button.titleLabel.font = FontSize(18);
            _selectedBtn = button;
        } else {
            button.titleLabel.font = FontSize(15);
        }
        
        [topView addSubview:button];
    }
    
    _lineView = [UIView new];
    _lineView.frame = CGRectMake(0, 41, 30, 3);
    _lineView.centerX = _selectedBtn.centerX;
    _lineView.backgroundColor = textLightBlueColorPass;
    _lineView.layer.masksToBounds = YES;
    _lineView.layer.cornerRadius = _lineView.height/2;
    [topView addSubview:_lineView];
    
    UIButtonCustom *ruleBtn = [MyTools createButtonWithFrame:CGRectMake(topView.width - 90, 0, 90, topView.height) title:@"计费规则" titleColor:textLightGrayColorPass imageName:nil backgroundImageName:nil target:self selector:@selector(ruleBtnClick)];
    ruleBtn.titleLabel.font = FontSize(13);
    [topView addSubview:ruleBtn];
}

- (void)ruleBtnClick {
    
}

- (void)topBtnClick:(UIButtonCustom *)button {
    if (button == _selectedBtn) return;
    _selectedBtn.titleLabel.font = FontSize(15);
    _selectedBtn.selected = NO;
    button.selected = YES;
    _selectedBtn = button;
    [self createChooseView];
    // 改变线条指示的位置
    [UIView animateWithDuration:0.3 animations:^{
        button.titleLabel.font = FontSize(18);
        _lineView.centerX = button.centerX;
    }];
}

// 选择乘车人
- (void)passengerBtnClick:(UIButtonCustom *)btn {
    ChangePassengerViewController *changePassenger = [ChangePassengerViewController new];
    [[changePassenger rac_signalForSelector:@selector(rightBarButtonClickWithName:phone:)] subscribeNext:^(id  _Nullable x) {
        RACTuple *tuple = x;
        [btn setTitle:tuple.first forState:(UIControlStateNormal)];
    }];
    [self open:changePassenger];
}

- (void)timeBtnClick:(UIButtonCustom *)btn {
    
}

// 起点
- (void)startPointBtnClick:(UIButtonCustom *)btn {
    
}

// 终点
- (void)endPointBtnClick:(UIButtonCustom *)btn {
    
}

// 用车类型
- (void)useCarTypeBtnClick:(UIButtonCustom *)btn {
    OfficialUserCarTypeController *useCarType = [OfficialUserCarTypeController new];
    
    [[useCarType rac_signalForSelector:@selector(selectUseTypeModel:)] subscribeNext:^(id  _Nullable x) {
        RACTuple *tuple = x;
        _selectedModel = tuple.first;
        [btn setTitle:_selectedModel.title forState:(UIControlStateNormal)];
        [btn setTitleColor:textBlackColorPass forState:(UIControlStateNormal)];
    }];
    [self.nacController open:useCarType];
}

// 用车说明
- (void)useCarDesClick:(UIButtonCustom *)btn {
    
}

// 需返程
- (void)returnBtnClick:(UIButtonCustom *)btn {
    btn.selected = !btn.selected;
}

- (void)scrollBtnClick:(UIButtonCustom *)btn {
    if (_selectCarBtn) {
        _selectCarBtn.selected = NO;
    }
    btn.selected = YES;
    _selectCarBtn = btn;
}

- (void)commitBtnClick:(UIButtonCustom *)btn {
    
}

@end
