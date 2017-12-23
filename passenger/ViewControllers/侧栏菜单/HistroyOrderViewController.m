//
//  HistroyOrderViewController.m
//  passenger
//
//  Created by 杨星星 on 2017/12/15.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "HistroyOrderViewController.h"
#import "OfficalOrderCell.h"

@interface HistroyOrderViewController () <UITableViewDelegate,UITableViewDataSource> {
    UITableView *_officialTableView; // 公务
    UITableView *_personalTableView;
    UIScrollView *_scrollView;
    
    UIView * _lineView;
    UIButtonCustom *_selectedBtn;
    
    int _page1,_page2;
}

@property (nonatomic,strong) NSMutableArray *officialDataArray; // 公务订单
@property (nonatomic,strong) NSMutableArray *personalDataArray; // 个人订单
@property (nonatomic ,strong) NSMutableArray * buttonArray; //

@end

@implementation HistroyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
//    [self initViews];
}

- (void)updateNavUI {
    self.headerTitle = @"历史订单";
}

#pragma mark - 主页面
- (void)createUI {
    // 创建scrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, SCREENW, _officialTableView.height)];
    
    _scrollView.delegate = self;
    
    // 添加控制器视图到scrollView
    [_scrollView addSubview:_officialTableView];
    
    // 添加控制器视图到scrollView
    [_scrollView addSubview:_personalTableView];
    
    // 设置scrollView的大小
    _scrollView.contentSize = CGSizeMake(SCREENW * 2, 0);
    // 设置按页滚动
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = YES;
    // 去掉横向滑动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    // 去掉弹跳效果
    _scrollView.bounces = NO;
    
    [self.view addSubview:_scrollView];
    
    [self setScrollBtn];
}

- (void)setScrollBtn {
    NSArray * titleArray = @[@"公务订单",@"个人订单"];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 44)];
    [topView addBottomLine];
    topView.backgroundColor = textWhiteColor;
    [self.view addSubview:topView];
    
    CGFloat width = (topView.width/2 - 60);
    // 创建顶部按钮
    for (int i = 0; i < titleArray.count; i++) {
        UIButtonCustom * button = [UIButtonCustom buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(topView.width/2+(i-1)*width, 0, width, topView.height);
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
        [self.buttonArray addObject:button];
        
        [topView addSubview:button];
    }
    _lineView = [UIView new];
    _lineView.frame = CGRectMake(0, 41, 30, 3);
    _lineView.centerX = _selectedBtn.centerX;
    _lineView.backgroundColor = textLightBlueColorPass;
    _lineView.layer.masksToBounds = YES;
    _lineView.layer.cornerRadius = _lineView.height/2;
    [topView addSubview:_lineView];
}

- (void)initViews {
    _officialTableView = [MyTools createTableViewWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-64-44) delegate:self backgroundColor:UITableViewBackgroundColor rowHeight:UITableViewRowHeight];
    
    _personalTableView = [MyTools createTableViewWithFrame:CGRectMake(SCREENW, 0, SCREENW, _officialTableView.height) delegate:self backgroundColor:UITableViewBackgroundColor rowHeight:UITableViewRowHeight];
    
    [self createUI];
    [self initData];
}

- (void)initOfficialFooterView {
    if (_officialDataArray.count > 0) {
        UILabel *footView = [MyTools createLabelWithFrame:CGRectMake(0, 0, SCREENW, 50) text:@"没有更多了" textColor:textLightGrayColorPass font:15];
        
        _officialTableView.tableFooterView = footView;
    }
}

- (void)initPersonalFooterView {
    if (_personalDataArray.count > 0) {
        UILabel *footView = [MyTools createLabelWithFrame:CGRectMake(0, 0, SCREENW, 50) text:@"没有更多了" textColor:textLightGrayColorPass font:15];
        
        _personalTableView.tableFooterView = footView;
    }
}

#pragma mark - 通过按钮改变视图
- (void)topBtnClick:(UIButtonCustom *)button {
    _selectedBtn.titleLabel.font = FontSize(15);
    _selectedBtn.selected = NO;
    button.selected = YES;
    _selectedBtn = button;
    // 改变线条指示的位置
    [UIView animateWithDuration:0.3 animations:^{
        button.titleLabel.font = FontSize(18);
        _lineView.centerX = button.centerX;
    }];
    // 改变_scrollView的偏移
    [_scrollView setContentOffset:CGPointMake(SCREENW * button.tag , 0) animated:NO];
}

#pragma mark - scrollView的滑动反向关联按钮
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        int index = scrollView.contentOffset.x / SCREENW;
        for (UIButton * btn in self.buttonArray) {
            if (btn.selected == YES) {
                btn.selected = NO;
                btn.titleLabel.font = FontSize(15);
            }
        }
        UIButtonCustom * btn = self.buttonArray[index];
        btn.selected = YES;
        _selectedBtn = btn;
        [UIView animateWithDuration:0.3 animations:^{
            btn.titleLabel.font = FontSize(18);
            _lineView.centerX = btn.centerX;
        }];
    }
}

#pragma mark - 数据
- (void)initData {
    _officialDataArray = [NSMutableArray array];
    _personalDataArray = [NSMutableArray array];
    _page1 = _page2 = 1;
    
    {
        OfficalOrderModel *model = [OfficalOrderModel new];
        model.time = @"2017-12-14 16:45:32";
        model.title = @"日常用车";
        model.state = 3;
        model.startLocation = @"石泉路456号时代商务中心";
        model.endLocation = @"晋江市万达广场";
        model.orderType = @"行政执法";
        model.carType = @"舒适型";
        [_officialDataArray addObject:model];
    }
    {
        OfficalOrderModel *model = [OfficalOrderModel new];
        model.time = @"2017-12-14 16:45:32";
        model.title = @"日常用车";
        model.state = 4;
        model.startLocation = @"深圳市讯美科技广场一号楼";
        model.endLocation = @"深圳市世界之窗";
        model.orderType = @"行政执法";
        model.carType = @"舒适型";
        [_officialDataArray addObject:model];
    }
    {
        OfficalOrderModel *model = [OfficalOrderModel new];
        model.time = @"2017-12-14 16:45:32";
        model.title = @"包车";
        model.state = 5;
        model.startLocation = @"石泉路456号时代商务中心";
        model.charteredBus = @"包车4小时";
        model.carType = @"舒适型";
        [_personalDataArray addObject:model];
    }
    
    {
        OfficalOrderModel *model = [OfficalOrderModel new];
        model.time = @"2017-12-13 15:45:32";
        model.title = @"日常用车";
        model.state = 6;
        model.startLocation = @"石泉路456号时代商务中心";
        model.endLocation = @"晋江市万达广场";
        model.carType = @"舒适型";
        [_personalDataArray addObject:model];
    }
    
    [self getData];
    [self initRefresh];
}

- (void)initRefresh {
    _officialTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(officialHeadRefresh)];
    _officialTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(officialFooterRefresh)];
    
    _personalTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(personalHeadRefresh)];
    _personalTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(personalFooterRefresh)];
}

- (void)officialHeadRefresh {
    _page1 = 1;
    [self getData];
}

- (void)officialFooterRefresh {
    _page1++;
    [self getData];
}

- (void)personalHeadRefresh {
    _page2 = 1;
    [self getData];
}

- (void)personalFooterRefresh {
    _page2++;
    [self getData];
}

- (void)getData {
    [self initOfficialFooterView];
    [self initPersonalFooterView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self officialEndRefresh];
        [self personalEndRefresh];
    });
}

- (void)officialEndRefresh {
    [_officialTableView.mj_header endRefreshing];
    [_officialTableView.mj_footer endRefreshing];
}

- (void)personalEndRefresh {
    [_personalTableView.mj_header endRefreshing];
    [_personalTableView.mj_footer endRefreshing];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _officialTableView) {
        return _officialDataArray.count;
    } else {
        return _personalDataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145;
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
    static NSString *cellStr = @"OfficalOrderCell";
    OfficalOrderCell *customCell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!customCell) {
        customCell = [[OfficalOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        customCell.separatorAlign = SeparatorAlignNone;
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (tableView == _officialTableView) {
        customCell.model = _officialDataArray[indexPath.row];
    } else {
        customCell.model = _personalDataArray[indexPath.row];
    }
    
    
    return customCell;
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray arrayWithCapacity:2];
    }
    return _buttonArray;
}

@end
