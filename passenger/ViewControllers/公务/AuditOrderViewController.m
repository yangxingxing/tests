//
//  AuditOrderViewController.m
//  passenger
//
//  Created by 杨星星 on 2017/12/19.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "AuditOrderViewController.h"
#import "AuditOrderCell.h"
#import "ConversationMenuView.h"
#import <ReactiveObjC.h>
#import "OfficialHistoryOrderViewController.h"
#import "OfficialDetailOrderViewController.h"
#import "RejectReasonView.h"

@interface AuditOrderViewController () <UITableViewDelegate,UITableViewDataSource,AuditOrderCellCustomDelegate> {
    UITableView *_tableView;
    
    UIButtonCustom *_selectBtn;
    
    RejectReasonView *_rejectView;
}

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation AuditOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)rightBarButtonClick {
    OfficialHistoryOrderViewController *officialHistoryOrder = [OfficialHistoryOrderViewController new];
    
    [self open:officialHistoryOrder];
}

- (void)updateNavUI {
    self.headerTitle = @"审批";
    [self.rightButton setTitle:@"审批历史" forState:(UIControlStateNormal)];
    self.rightButton.width = 70;
}


- (void)initViews {
    _tableView = [MyTools createTableViewWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-64-66) delegate:self backgroundColor:UITableViewBackgroundColor rowHeight:150];
    [self.view addSubview:_tableView];
    
    [self initHeaderView];
    [self initBottomView];
    [self initData];
}

- (void)initHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 130)];
    headerView.backgroundColor = textWhiteColor;
    
    UIView *financeView = [self createLimitViewWithTitle:@"财政额度" limit:@"0.0元" remain:@"已用0.0元/剩余0.0元"];
    [headerView addSubview:financeView];
    [financeView addBottomLineWithBorderColor:UITableViewSeparatorColor borderWidth:0.5];
    
    UIView *unitView = [self createLimitViewWithTitle:@"单位额度" limit:@"0.0元" remain:@"已用0.0元/剩余0.0元"];
    unitView.y = CGRectGetMaxY(financeView.frame);
    [headerView addSubview:unitView];
    
    _tableView.tableHeaderView = headerView;
}

- (UIView *)createLimitViewWithTitle:(NSString *)title limit:(NSString *)limit remain:(NSString *)remain {
    UIView *limitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 65)];
    
    UILabel *titleLabel = [MyTools createLabelWithFrame:CGRectMake(15, 15, 200, 15) text:title textColor:textBlackColorPass font:15];
    [limitView addSubview:titleLabel];
    
    UILabel *limitLabel = [MyTools createLabelWithFrame:CGRectMake(titleLabel.x, CGRectGetMaxY(titleLabel.frame)+10, 150, titleLabel.height) text:limit textColor:textLightGrayColorPass font:15];
    limitLabel.adjustsFontSizeToFitWidth = YES;
    [limitView addSubview:limitLabel];
    
    UILabel *remainLabel = [MyTools createLabelWithFrame:CGRectMake(limitView.width - 15 - 200, 0, 200, titleLabel.height) text:remain textColor:textLightGrayColorPass font:15];
    remainLabel.centerY = limitView.height/2;
    [limitView addSubview:remainLabel];
    
    titleLabel.textAlignment = limitLabel.textAlignment = NSTextAlignmentLeft;
    remainLabel.textAlignment = NSTextAlignmentRight;
    
    return limitView;
}

- (void)initBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENH - 64 - 66, SCREENW, 66)];
    bottomView.backgroundColor = textWhiteColor;
    
    UIButtonCustom *approveBtn = [MyTools createButtonWithFrame:CGRectMake(bottomView.width - 85, 0, 85, bottomView.height) title:@"批准" titleColor:textWhiteColor imageName:nil backgroundImageName:nil target:self selector:@selector(approveBtnClick:)];
    approveBtn.backgroundColor = MainColor;
    [bottomView addSubview:approveBtn];
    
    UIButtonCustom *rejectBtn = [MyTools createButtonWithFrame:CGRectMake(approveBtn.x - approveBtn.width, 0, approveBtn.width, approveBtn.height) title:@"驳回" titleColor:textLightGrayColorPass imageName:nil backgroundImageName:nil target:self selector:@selector(rejectBtnClick:)];
    rejectBtn.backgroundColor = [UIColor colorWithHexString:@"d6d6d6"];
    [bottomView addSubview:rejectBtn];
    
    rejectBtn.titleLabel.font = approveBtn.titleLabel.font = FontSize(18);
    
    UIButtonCustom *selectBtn = [MyTools createButtonWithFrame:CGRectMake(0, 0, rejectBtn.x, approveBtn.height) title:@"共0项,已选0项" titleColor:textLightGrayColorPass imageName:@"n_check_icon_content" backgroundImageName:nil target:self selector:@selector(selectBtnClick:)];
    _selectBtn = selectBtn;
    [selectBtn setImage:ImageNamed(@"h_check_icon_content") forState:(UIControlStateSelected)];
    
    selectBtn.imageViewFrame = CGRectMake(15, (selectBtn.height-20)/2, 20, 20);
    selectBtn.titleLabelFrame = CGRectMake(45, 0, selectBtn.width - 45 - 10, selectBtn.height);
    selectBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    selectBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    selectBtn.titleLabel.font = FontSize(15);
    [bottomView addSubview:selectBtn];
    
    [self.view addSubview:bottomView];
}

#pragma mark - 数据
- (void)initData {
    _dataArray = [NSMutableArray array];
    
    {
        OfficalOrderModel *model = [OfficalOrderModel new];
        model.time = @"2017-12-14 16:45:32";
        model.name = @"陈师傅";
        model.phone = @"13866666666";
        model.state = 1;
        model.startLocation = @"石狮市标";
        model.endLocation = @"晋江市飞机场";
        model.money = @"23.8";
        model.orderType = @"行政执法";
        model.carType = @"舒适型";
        model.isReturn = YES;
        [_dataArray addObject:model];
    }
    {
        OfficalOrderModel *model = [OfficalOrderModel new];
        model.time = @"2017-12-14 16:45:32";
        model.name = @"李师傅";
        model.phone = @"13866666666";
        model.state = 2;
        model.startLocation = @"石泉路456号时代商务中心";
        model.charteredBus = @"包车三小时";
        model.money = @"200";
        model.orderType = @"紧急任务";
        model.carType = @"舒适型";
        [_dataArray addObject:model];
    }
    {
        OfficalOrderModel *model = [OfficalOrderModel new];
        model.time = @"2017-12-14 16:45:32";
        model.name = @"李师傅";
        model.phone = @"13866666666";
        model.state = 2;
        model.startLocation = @"石泉路456号时代商务中心";
         model.endLocation = @"晋江市区";
        model.money = @"200";
        model.orderType = @"微服私访";
        model.isReturn = YES;
        [_dataArray addObject:model];
    }
    {
        OfficalOrderModel *model = [OfficalOrderModel new];
        model.time = @"2017-12-14 16:45:32";
        model.name = @"李师傅";
        model.phone = @"13866666666";
        model.state = 2;
        model.startLocation = @"石泉路456号时代商务中心";
        model.endLocation = @"晋江市区";
        model.money = @"200";
        model.orderType = @"微服私访";
        model.carType = @"舒适型";
        [_dataArray addObject:model];
    }
    [self updateSelectBtnWithNum:0];
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
    return UITableViewCellCustomLeftX;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UISectionHeaderView *headerView = [UISectionHeaderView headerWithHeight:UITableViewCellCustomLeftX];
    headerView.backgroundColor = UITableViewBackgroundColor;
    headerView.keepMoveSection = section;
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cell";
    AuditOrderCell *customCell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!customCell) {
        customCell = [[AuditOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        customCell.separatorAlign = SeparatorAlignLeft;
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    customCell.model = _dataArray[indexPath.row];
    customCell.delegate = self;
    return customCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OfficialDetailOrderViewController *detailOrder = [OfficialDetailOrderViewController new];
    detailOrder.type = DetailOrderIsApproval;
    detailOrder.model = _dataArray[indexPath.row];
    
    __weak typeof(self) wSelf = self;
    // 驳回
    [[detailOrder rac_signalForSelector:@selector(rejectBtnClick:)] subscribeNext:^(id  _Nullable x) {
        [wSelf detailUpdateDataWithIndexPath:indexPath];
    }];
    
    // 批准
    [[detailOrder rac_signalForSelector:@selector(approveBtnClick:)] subscribeNext:^(id  _Nullable x) {
        [wSelf detailUpdateDataWithIndexPath:indexPath];
    }];
    
    [self open:detailOrder];
}

- (void)detailUpdateDataWithIndexPath:(NSIndexPath *)indexPath {
    [_dataArray removeObjectAtIndex:indexPath.row];
    [_tableView reloadSection:0 withRowAnimation:(UITableViewRowAnimationAutomatic)];
    _selectBtn.selected = NO;
    [self reloadDataWithSelect:NO];
}

#pragma mark - AuditOrderCellCustomDelegate
- (void)selectBtnClickWithCell:(AuditOrderCell *)cell {
    int selectNum = 0;
    for (OfficalOrderModel *model in _dataArray) {
        if (model.isSelect) {
            selectNum++;
        }
    }
    [self updateSelectBtnWithNum:selectNum];
}

- (void)PayTypeBtnClickWithCell:(AuditOrderCell *)cell btn:(UIButtonCustom *)btn {
    ConversationMenuView *menuView = [[ConversationMenuView alloc] init];
    
    NSArray *buttons = @[@{@"title":@"财政支付",@"image":[btn.titleLabel.text isEqualToString:@"财政支付"] ? @"h_check_icon_content": @"n_check_icon_full_white"},
                      @{@"title":@"单位支付",@"image":[btn.titleLabel.text isEqualToString:@"单位支付"] ? @"h_check_icon_content": @"n_check_icon_full_white"}];

    [menuView setMenuClick:^(ConversationMenus menu) {
        NSDictionary *dict = buttons[menu];
        [btn setTitle:dict[@"title"] forState:(UIControlStateNormal)];
        cell.model.payType = (int)btn.tag + 1;
    } buttons:buttons];
    
    CGRect rectInTableView = [_tableView rectForRowAtIndexPath:[_tableView indexPathForCell:cell]];
//    CGRect rectInSuperView = [_tableView convertRect:rectInTableView toView:[_tableView superview]];
    
    CGFloat w = 120;
    CGFloat y = rectInTableView.origin.y + 135 + 64 - _tableView.contentOffset.y;
    
    // 关闭
    [[menuView rac_signalForSelector:@selector(closeWithAnimation:)] subscribeNext:^(id  _Nullable x) {
        btn.selected = NO;
    }];
    
    menuView.beakerOffset = w-15;
    [menuView showInView:_tableView origin:CGPointMake(SCREENW - w - 5, y)
                   width:w];
}

- (void)updateSelectBtnWithNum:(int)num {
    _selectBtn.selected = _dataArray.count > 0 && _dataArray.count == num;
    [_selectBtn setTitle:[NSString stringWithFormat:@"共%ld项,已选%d项",_dataArray.count,num] forState:(UIControlStateNormal)];
}

// 批准
- (void)approveBtnClick:(UIButtonCustom *)btn {
    [self updateData];
}

// 驳回
- (void)rejectBtnClick:(UIButtonCustom *)btn {
    if (_rejectView) {
        [_rejectView removeFromSuperview];
    }
    _rejectView = [RejectReasonView new];
    __weak typeof(self) wSelf = self;
    [[_rejectView rac_signalForSelector:@selector(confirmBtnClickWithText:)] subscribeNext:^(id  _Nullable x) {
        [wSelf updateData];
        [_rejectView removeFromSuperview];
        _rejectView = nil;
    }];
    [[_rejectView rac_signalForSelector:@selector(cancelBtnClick)] subscribeNext:^(id  _Nullable x) {
        [_rejectView removeFromSuperview];
        _rejectView = nil;
    }];
}

// 更新
- (void)updateData {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (OfficalOrderModel *model in _dataArray) {
        if (model.isSelect) {
            [tempArr addObject:model];
        }
    }
    if (tempArr.count > 0) {
        [_dataArray removeObjectsInArray:tempArr];
        [_tableView reloadSection:0 withRowAnimation:(UITableViewRowAnimationAutomatic)];
        [self updateSelectBtnWithNum:0];
    }
}

- (void)selectBtnClick:(UIButtonCustom *)btn {
    btn.selected = !btn.selected;
    [self reloadDataWithSelect:btn.selected];
}

// 刷新选中
- (void)reloadDataWithSelect:(BOOL)select {
    for (OfficalOrderModel *model in _dataArray) {
        model.isSelect = select;
    }
    [_tableView reloadData];
    [self updateSelectBtnWithNum:select ? (int)_dataArray.count : 0];
}

@end
