//
//  MyOrderViewController.m
//  passenger
//
//  Created by 杨星星 on 2017/12/15.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "MyOrderViewController.h"
#import "OfficalOrderCell.h"
#import "HistroyOrderViewController.h"

@interface MyOrderViewController () <UITableViewDelegate,UITableViewDataSource> {
    UITableView *_tableView;
    
    int _page;
}

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initViews];
}

- (void)updateNavUI {
    self.headerTitle = @"我的订单";
    [self.rightButton setTitle:@"历史订单" forState:(UIControlStateNormal)];
    self.rightButton.width = 70;
}

- (void)rightBarButtonClick {
    [self open:[HistroyOrderViewController new]];
}

- (void)initViews {
    _tableView = [MyTools createTableViewWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-64) delegate:self backgroundColor:UITableViewBackgroundColor rowHeight:145];
    [self.view addSubview:_tableView];
    [self initData];
}

- (void)initFootView {
    if (_dataArray.count > 0) {
        UILabel *footView = [MyTools createLabelWithFrame:CGRectMake(0, 0, SCREENW, 50) text:@"没有更多了" textColor:textLightGrayColorPass font:15];
        
        _tableView.tableFooterView = footView;
    }
}

#pragma mark - 数据
- (void)initData {
    _dataArray = [NSMutableArray array];
    _page = 1;
    
    {
        OfficalOrderModel *model = [OfficalOrderModel new];
        model.time = @"2017-12-14 16:45:32";
        model.title = @"日常用车";
        model.state = 1;
        model.startLocation = @"石泉路456号时代商务中心";
        model.endLocation = @"晋江市万达广场";
        model.orderType = @"行政执法";
        model.carType = @"舒适型";
        [_dataArray addObject:model];
    }
    {
        OfficalOrderModel *model = [OfficalOrderModel new];
        model.time = @"2017-12-14 16:45:32";
        model.title = @"日常用车";
        model.state = 2;
        model.startLocation = @"石泉路456号时代商务中心";
        model.endLocation = @"晋江市万达广场";
        model.orderType = @"行政执法";
        model.carType = @"舒适型";
        [_dataArray addObject:model];
    }
    {
        OfficalOrderModel *model = [OfficalOrderModel new];
        model.time = @"2017-12-14 16:45:32";
        model.title = @"包车";
        model.state = 3;
        model.startLocation = @"石泉路456号时代商务中心";
        model.charteredBus = @"包车4小时";
        model.orderType = @"行政执法";
        model.carType = @"舒适型";
        [_dataArray addObject:model];
    }
    
    {
        OfficalOrderModel *model = [OfficalOrderModel new];
        model.time = @"2017-12-13 15:45:32";
        model.title = @"日常用车";
        model.state = 4;
        model.startLocation = @"石泉路456号时代商务中心";
        model.endLocation = @"晋江市万达广场";
        model.orderType = @"紧急任务";
        model.carType = @"舒适型";
        [_dataArray addObject:model];
    }
    
    [self getData];
}

- (void)initRefresh {
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}

- (void)headRefresh {
    _page = 1;
    [self getData];
}

- (void)footerRefresh {
    _page++;
    [self getData];
}

- (void)getData {
    [self initFootView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UISectionHeaderView *headerView = [UISectionHeaderView headerWithHeight:5];
    headerView.keepMoveSection = section;
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
