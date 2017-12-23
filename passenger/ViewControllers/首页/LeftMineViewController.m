//
//  LeftMineViewController.m
//  passenger
//
//  Created by 杨星星 on 2017/12/14.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "LeftMineViewController.h"
#import "SimpleCustomCell.h"
#import "MyOrderViewController.h"

@interface LeftMineViewController () <UITableViewDelegate,UITableViewDataSource> {
    UITableView *_tableView;
    
}

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation LeftMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initViews];
}


- (void)initViews {
    _tableView = [MyTools createTableViewWithFrame:CGRectMake(0, 0, LeftVCWidth, SCREENH-50) delegate:self backgroundColor:textWhiteColor rowHeight:55];
    [self.view addSubview:_tableView];
    
    [self initData];
    
    [self initHeaderView];
    [self initBottomView];
}

- (void)initHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, _tableView.width, 240)];
    
    UIButtonCustom *headerBtn = [MyTools createButtonWithFrame:CGRectMake(0, 36, 85, 85) title:nil titleColor:nil imageName:@"headportrait_bg_navbar" backgroundImageName:nil target:self selector:@selector(headerBtnClick:)];
    headerBtn.centerX = headerView.width/2;
    [headerView addSubview:headerBtn];
    
    UILabel *nameLabel = [MyTools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(headerBtn.frame) + 20, headerView.width, 20) text:@"王大锤" textColor:textBlackColorPass font:18];
    [headerView addSubview:nameLabel];
    
    UILabel *phoneLabel = [MyTools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame) + 10, nameLabel.width, 15)  text:@"1364749574" textColor:textCompanyColorPass font:12];
    [headerView addSubview:phoneLabel];
    
    UILabel *companyLabel = [MyTools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(phoneLabel.frame) + 10, phoneLabel.width, 15)  text:@"晋江市XX单位" textColor:textCompanyColorPass font:15];
    [headerView addSubview:companyLabel];
    
    headerView.height = CGRectGetMaxY(companyLabel.frame) + 40;
    _tableView.tableHeaderView = headerView;
}

- (void)initBottomView {
    UIButtonCustom *lineBtn = [MyTools createButtonWithFrame:CGRectMake(0, SCREENH - 50, LeftVCWidth, 50) title:@"热线电话：0595-888" titleColor:textGrayColorPass imageName:@"telephone_icon" backgroundImageName:nil target:self selector:@selector(lineBtnClick)];
    lineBtn.titleLabel.font = FontSize(15);
    lineBtn.backgroundColor = textWhiteColor;
    lineBtn.imageView.x = lineBtn.titleLabel.x - 27;
    
    [self.view addSubview:lineBtn];
}

// 头像
- (void)headerBtnClick:(UIButtonCustom *)btn {
    
}

// 热线电话
- (void)lineBtnClick {
    
}

static NSString *imageKey = @"image";
static NSString *titleKey = @"title";
- (void)initData {
    _dataArray = @[@{imageKey:@"orderform_icon",titleKey:@"我的订单"},
                   @{imageKey:@"wallet_icon",titleKey:@"钱包"},
                   @{imageKey:@"discountcoupon_icon",titleKey:@"优惠券"},
                   @{imageKey:@"rule_icon",titleKey:@"我的用车规则"},
                   @{imageKey:@"collect_icon",titleKey:@"约藏司机"},
                   @{imageKey:@"set_icon",titleKey:@"设置"}].mutableCopy;
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return UITableViewCellCustomLeftX;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UISectionHeaderView *headerView = [UISectionHeaderView headerWithHeight:UITableViewCellCustomLeftX];
//    headerView.backgroundColor = UITableViewBackgroundColor;
//    headerView.keepMoveSection = section;
//    return headerView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cell";
    SimpleCustomCell *customCell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!customCell) {
        customCell = [[SimpleCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        customCell.separatorAlign = SeparatorAlignNone;
        customCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    NSDictionary *dict = _dataArray[indexPath.row];
    customCell.iconImageView.image = ImageNamed(dict[imageKey]);
    customCell.customTextLabel.text  = dict[titleKey];
    customCell.iconImageView.frame = CGRectMake(24, (55-17)/2, 17, 17);
    
    return customCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    switch (indexPath.row) {
        case 0:
            [self.navController open:[MyOrderViewController new]];
            break;
            
        default:
            break;
    }
}

@end
