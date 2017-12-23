//
//  ChangePassengerViewController.m
//  passenger
//
//  Created by 杨星星 on 2017/12/16.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "ChangePassengerViewController.h"
#import "SimpleCustomCell.h"

@interface ChangePassengerViewController () <UITableViewDelegate,UITableViewDataSource> {
    UITableView *_tableView;
    
}

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (retain, nonatomic) HSUITextField *phoneTxt;          //手机号码
@property (retain, nonatomic) HSUITextField *nameTxt;            //姓名

@end

@implementation ChangePassengerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)rightBarButtonClick {
    if (_nameTxt.text.length == 0) {
        [MyTools showMsg:@"请输入乘车人姓名！" target:self handler:^{
            [_nameTxt becomeFirstResponder];
        }];
        return;
    }
    if (_phoneTxt.text.length == 0) {
        [MyTools showMsg:@"请输入乘车人手机号码！" target:self handler:^{
            [_phoneTxt becomeFirstResponder];
        }];
        return;
    }
    [self rightBarButtonClickWithName:_nameTxt.text phone:_phoneTxt.text];
    [self close];
}

- (void)rightBarButtonClickWithName:(NSString *)name phone:(NSString *)phone {}

- (void)updateNavUI {
    self.headerTitle = @"更换乘车人";
    [self.rightButton setImage:ImageNamed(@"confirm_icon_content") forState:(UIControlStateNormal)];
}

- (void)initViews {
    _tableView = [MyTools createTableViewWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-64) delegate:self backgroundColor:UITableViewBackgroundColor rowHeight:UITableViewRowHeight];
    [self.view addSubview:_tableView];
    
    [self initData];
    [self initTextField];
}

- (void)initData {
    _dataArray = [NSMutableArray arrayWithObjects:@"personage_icon_content",@"phone_icon_content", nil];
}

- (void)initTextField {
    _phoneTxt = [MyTools createHSUITexfielfWithFrame:CGRectMake(60, 0, SCREENW - 60, _tableView.rowHeight)
                                                text:SStringEmpty
                                         placeHolder:@"请输入手机号码"
                                             decimal:0
                                            delegate:self
                                                font:[WBJUIFont tableViewFont]
                                              maxLen:11
                                     clearButtonMode:UITextFieldViewModeAlways
                                          numberOnly:YES
                                           textColor:textBlackColor];
    
    _nameTxt = [MyTools createHSUITexfielfWithFrame:_phoneTxt.frame
                                              text:SStringEmpty
                                       placeHolder:@"请输入姓名"
                                           decimal:0
                                          delegate:self
                                              font:[WBJUIFont tableViewFont]
                                            maxLen:30
                                   clearButtonMode:UITextFieldViewModeAlways
                                        numberOnly:NO
                                         textColor:textBlackColor];
    
    [_tableView reloadData];
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
    SimpleCustomCell *customCell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!customCell) {
        customCell = [[SimpleCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        customCell.separatorAlign = SeparatorAlignLeft;
    }
    customCell.iconImageView.frame = CGRectMake(20, (UITableViewRowHeight-30)/2, 30, 30);
    customCell.iconImageView.image = ImageNamed(_dataArray[indexPath.row]);
    if (indexPath.row == 0) {
//        customCell lineVerticalWithPoint:cg toPoint:<#(CGPoint)#>
        [customCell addSubview:_nameTxt];
    } else if (indexPath.row == 1) {
        [customCell addSubview:_phoneTxt];
    }
    return customCell;
}


@end
