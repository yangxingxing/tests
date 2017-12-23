//
//  OfficialUserCarTypeController.m
//  passenger
//
//  Created by 杨星星 on 2017/12/18.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "OfficialUserCarTypeController.h"


@interface OfficialUserCarTypeController () <UITableViewDelegate,UITableViewDataSource> {
    UITableView *_tableView;
    UseCarTypeModel *_selectedModel;
}

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation OfficialUserCarTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)updateNavUI {
    self.headerTitle = @"用车类型";
    [self.rightButton setTitle:@"确定" forState:(UIControlStateNormal)];
}

- (void)rightBarButtonClick {
    if (!_selectedModel) {
        [MyTools showMsg:@"请选择用车类型" target:self handler:nil];
        return;
    }
    [self selectUseTypeModel:_selectedModel];
    [self close];
}


- (void)initViews {
    _tableView = [MyTools createTableViewWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-64) delegate:self backgroundColor:UITableViewBackgroundColor rowHeight:UITableViewRowHeight];
    [self.view addSubview:_tableView];
    
    [self initData];
}

- (void)initData {
    _dataArray = [NSMutableArray array];
    
    {
        UseCarTypeModel *model = [UseCarTypeModel new];
        model.title = @"行政执法";
        model.detail = @"1、行政执法行政执法公务执勤公务执勤\n2、微服私访微服私访行政执法行政执法行政执法\n3、行政执法行政执法行政执法行政执法行政执法行政执法行政执法行政执法行政执法行政执法行政执法行政执法行政执法";
        model.height = [model.detail boundingRectWithSize:CGSizeMake(SCREENW - 2 * leftSpace, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FontSize(13)} context:nil].size.height;
        [_dataArray addObject:model];
    }
    
    {
        UseCarTypeModel *model = [UseCarTypeModel new];
        model.title = @"公务执勤";
        model.detail = @"公务执勤公务执勤公务执勤公务执勤";
        model.height = [model.detail boundingRectWithSize:CGSizeMake(SCREENW - 65, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FontSize(13)} context:nil].size.height;
        [_dataArray addObject:model];
    }
    
    {
        UseCarTypeModel *model = [UseCarTypeModel new];
        model.title = @"微服私访";
        model.detail = @"行政执法行政执法公务执勤微服私访微服私访微服私访微服私访微服私访微服私访";
        model.height = [model.detail boundingRectWithSize:CGSizeMake(SCREENW - 2 * leftSpace, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FontSize(13)} context:nil].size.height;
        [_dataArray addObject:model];
    }
    
    [_tableView reloadData];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UseCarTypeModel *model = _dataArray[indexPath.row];
    return model.height + 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UISectionHeaderView *headerView = [UISectionHeaderView headerWithHeight:UITableViewCellCustomLeftX];
    headerView.backgroundColor = UITableViewBackgroundColor;
    headerView.keepMoveSection = section;
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cell";
    UseCarTypeCell *customCell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!customCell) {
        customCell = [[UseCarTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        customCell.separatorAlign = SeparatorAlignNone;
    }
    customCell.model = _dataArray[indexPath.row];
    
    return customCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UseCarTypeModel *model = _dataArray[indexPath.row];
    _selectedModel.selected = NO;
    model.selected = YES;
    _selectedModel = model;
    [_tableView reloadData];
}

- (void)selectUseTypeModel:(UseCarTypeModel *)model {}

@end
