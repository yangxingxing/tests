//
//  OfficaialView.m
//  passenger
//
//  Created by 杨星星 on 2017/12/14.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "OfficaialView.h"
#import "Carousel.h"
#import "OfficalOrderCell.h"

@interface OfficaialView () <UITableViewDelegate,UITableViewDataSource> {
    UITableView *_tableView;
    // 轮播
    Carousel * _cyclePlaying;
    
    UILabel *_orderLabel; // 未审核订单
}

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation OfficaialView



- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
//    CGRectMake(0, 0, SCREENW, SCREENH-64-64*ScreenRate)
    _tableView = [MyTools createTableViewWithFrame:CGRectMake(0, 0, SCREENW, self.height-64*ScreenRate) delegate:self backgroundColor:UITableViewBackgroundColor rowHeight:145];
    [self addSubview:_tableView];
    
    [self initData];
    [self initHeaderView];
    
    [self initBottomView];
}

- (void)initHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 200)];
    [self createCyclePlay];
    [headerView addSubview:_cyclePlaying];
    
    UIView *waitReviewOrderView = [self waitReviewOrder];
    waitReviewOrderView.y = CGRectGetMaxY(_cyclePlaying.frame) + 5;
    [headerView addSubview:waitReviewOrderView];
    
    headerView.height = CGRectGetMaxY(waitReviewOrderView.frame) + 10;
    //设置头视图
    _tableView.tableHeaderView = headerView;
}

static CGFloat rightImageWidth = 25;
// 未审核订单
- (UIView *)waitReviewOrder {
    UIButtonCustom *waitReviewOrderView = [[UIButtonCustom alloc] initWithFrame:CGRectMake(10, 5, SCREENW - 2*10, 50*ScreenRate)];
    waitReviewOrderView.backgroundColor = textWhiteColor;
    waitReviewOrderView.layer.cornerRadius = 3;
    
    [waitReviewOrderView setLayerShadow:textGrayColorPass offset:CGSizeMake(0.5, 1) radius:0.5];
    waitReviewOrderView.layer.shadowOpacity = 0.5;
    
    UILabel *reviewLabel = [MyTools createLabelWithFrame:CGRectMake(10, 0, (waitReviewOrderView.width - 20 - rightImageWidth)/2, waitReviewOrderView.height) text:@"审核订单" textColor:textBlackColorPass font:15];
    reviewLabel.textAlignment = NSTextAlignmentLeft;
    [waitReviewOrderView addSubview:reviewLabel];
    
    UILabel *orderLabel = [MyTools createLabelWithFrame:CGRectMake(waitReviewOrderView.width - rightImageWidth - reviewLabel.width, 0, reviewLabel.width, waitReviewOrderView.height) text:@"没有待审核订单" textColor:textLightGrayColorPass font:13];
    orderLabel.textAlignment = NSTextAlignmentRight;
    [waitReviewOrderView addSubview:orderLabel];
    _orderLabel = orderLabel;
    
    UIImageView *imageView = [MyTools createImageViewWithFrame:CGRectMake(waitReviewOrderView.width - rightImageWidth, 0, rightImageWidth, rightImageWidth) imageName:@"enterinto_icon_content"];
    imageView.centerY = orderLabel.centerY;
    [waitReviewOrderView addSubview:imageView];
    
    return waitReviewOrderView;
}

- (void)createCyclePlay {
    //轮播
    _cyclePlaying = [[Carousel alloc]initWithFrame:CGRectMake(0, 0, SCREENW, 150*ScreenRate)];
    //需要pageControl
    _cyclePlaying.needPageControl = YES;
    _cyclePlaying.pageControlColor = [textBlackColor colorWithAlphaComponent:0.8];
    _cyclePlaying.pageIndicatorTintColor = textWhiteColor;
    //需要无限轮播
    _cyclePlaying.infiniteLoop = YES;
    //设置pageControl的位置
    _cyclePlaying.pageControlPositionType = PAGE_CONTROL_POSITION_TYPE_MIDDLE;
    // 取出图片接口
    // 设置图片
    _cyclePlaying.imageUrlArray = @[@""];
    _cyclePlaying.placeHolderImageName = @"banner";
    // 设置标题
    //    _cyclePlaying.titleArray = title;
    // 将模型传给滚动视图
    _cyclePlaying.modelArray = nil;
}

// 用车申请
- (void)initBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 64*ScreenRate - 64, SCREENW, 64*ScreenRate)];
    [bottomView addTopLine];
    bottomView.backgroundColor = textWhiteColor;
    
    UIButtonCustom *reviewBtn = [MyTools createButtonWithFrame:CGRectMake(0, 0, 355*ScreenRate, 44*ScreenRate) title:@"用车申请" titleColor:textWhiteColor imageName:nil backgroundImageName:nil target:self selector:@selector(reviewbtnClick)];
    reviewBtn.center = CGPointMake(bottomView.width/2, bottomView.height/2);
    [reviewBtn setBorderWithRadius:reviewBtn.height/2 borderColor:textWhiteColor];
    reviewBtn.backgroundColor = textBrownColorPass;
    [bottomView addSubview:reviewBtn];
    
    [self addSubview:bottomView];
}

- (void)reviewbtnClick {
    
}

#pragma mark - 数据
- (void)initData {
    _dataArray = [NSMutableArray array];
    
    {
        OfficalOrderModel *model = [OfficalOrderModel new];
        model.time = @"2017-12-14 16:45:32";
        model.title = @"日常用车";
        model.state = 1;
        model.startLocation = @"石泉路456号时代商务中心";
        model.endLocation = @"晋江市万达广场";
        [_dataArray addObject:model];
    }
    {
        OfficalOrderModel *model = [OfficalOrderModel new];
        model.time = @"2017-12-14 16:45:32";
        model.title = @"日常用车";
        model.state = 2;
        model.startLocation = @"石泉路456号时代商务中心";
        model.endLocation = @"晋江市万达广场";
        [_dataArray addObject:model];
    }
    {
        OfficalOrderModel *model = [OfficalOrderModel new];
        model.time = @"2017-12-14 16:45:32";
        model.title = @"包车";
        model.state = 3;
        model.startLocation = @"石泉路456号时代商务中心";
        model.charteredBus = @"包车4小时";
        [_dataArray addObject:model];
    }
    
    {
        OfficalOrderModel *model = [OfficalOrderModel new];
        model.time = @"2017-12-13 15:45:32";
        model.title = @"日常用车";
        model.state = 4;
        model.startLocation = @"石泉路456号时代商务中心";
        model.endLocation = @"晋江市万达广场";
        [_dataArray addObject:model];
    }
}

- (void)getData {
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UISectionHeaderView *headerView = [UISectionHeaderView headerWithHeight:30];
    headerView.backgroundColor = UITableViewBackgroundColor;
    headerView.keepMoveSection = section;
    headerView.text = @"您的新订单";
    headerView.textColor = textLightGrayColorPass;
    headerView.textEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    headerView.font = FontSize(14);
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cell";
    OfficalOrderCell *customCell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!customCell) {
        customCell = [[OfficalOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        customCell.separatorAlign = SeparatorAlignNone;
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    customCell.model = _dataArray[indexPath.row];
    
    return customCell;
}

@end
