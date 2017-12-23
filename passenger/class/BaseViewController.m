//
//  BaseViewController.m
//  114SD
//
//  Created by 杨星星 on 2017/3/23.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (id)init
{
    self = [super init];
    if (self) {
        _viewAppeared = NO;
    }
    return self;
}

- (void)updateNavUI {
    
}

- (void)initViews {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = textWhiteColor;
    [self createRootNav];
    [self updateNavUI];
    [self initViews];
    // 全屏幕支持侧滑
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    panGesture.delegate = self; // 设置手势代理，拦截手势触发
    [self.view addGestureRecognizer:panGesture];
    
    // 禁止系统自带的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)createRootNav
{
    //设置导航不透明
    self.navigationController.navigationBar.translucent = NO;
     //[textLightGrayColor colorWithAlphaComponent:0.5];
    //方法一：修改状态栏的颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    // 去掉导航分割线
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    //左按钮
    self.leftButton = [UIButtonCustom buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(0, 0, 44, 44);
    self.leftButton.imageViewFrame = CGRectMake(0, 12, 20, 20);
    [self.leftButton setImage:[UIImage imageNamed:@"arrow_left_white"] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    [self.leftButton addTarget:self action:@selector(leftButtonClik:) forControlEvents:UIControlEventTouchUpInside];
    //标题
    self.titleLabel = [[UILabelCustom alloc] initWithFrame:CGRectMake(0, 0, 150*ScreenRate, 30)];
    self.titleLabel.text = _headerTitle ? _headerTitle : SStringEmpty;
    self.titleLabel.textColor = ConfirmBtnBackgroundColor;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.navigationItem.titleView = self.titleLabel;
    //右按钮
    self.rightButton = [UIButtonCustom buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(0, 0, 44, 44);
    self.rightButton.titleLabel.font = FontSize(15);
//    self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(12, 24, 12, 0);
    [self.rightButton setTitleColor:textWhiteColor forState:(UIControlStateNormal)];
    [self.rightButton addTarget:self action:@selector(rightButtonClik:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 1;
    if (self.navColor) {
        [self.leftButton setImage:[UIImage imageNamed:@"arrow_left_black"] forState:UIControlStateNormal];
        //设置导航条的颜色
        self.navigationController.navigationBar.barTintColor = self.navColor;//[UIColor colorWithHexString:@"EBECEE" alpha:1];
        self.titleLabel.textColor = textBlackColor;
    } else {
        [self.leftButton setImage:[UIImage imageNamed:@"arrow_left_white"] forState:UIControlStateNormal];
        //设置导航条的颜色
        self.navigationController.navigationBar.barTintColor = MainColor;
        self.titleLabel.textColor = textWhiteColor;
    }
    
    // 去掉第一个页面的返回按钮
    NSArray *array = self.navigationController.viewControllers;
    if (array.count <= 1) {
        [self.leftButton setImage:nil forState:(UIControlStateNormal)];
    }
    // 去掉导航栏分割线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //设置导航条的颜色
    self.navigationController.navigationBar.barTintColor = MainColor;
    self.navigationController.navigationBar.alpha = 1;
//    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.toolbarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    _viewAppeared = YES;
    [super viewDidAppear:animated];
}

- (void)setHeaderTitle:(NSString *)headerTitle {
    _headerTitle = headerTitle;
    self.titleLabel.text = headerTitle;
}

- (void)leftButtonClik:(UIButton *)btn {
    [self leftBarButtonClick];
}

- (void)rightButtonClik:(UIButton *)btn {
    [self rightBarButtonClick];
}

-(void)leftBarButtonClick {
    [self closeWithAnimated:YES];
};

-(void)rightBarButtonClick {};

- (void)open:(BaseViewController *)VC {
    [self pushVC:VC animated:YES];
}

- (void)open:(BaseViewController *)VC animated:(BOOL)animated {
    [self pushVC:VC animated:animated];
}

- (void)pushVC:(BaseViewController *)VC animated:(BOOL)animated {
    if ([VC isKindOfClass:[BaseViewController class]]) {
        VC.owner = self;
    }
    
    [self.navigationController pushViewController:VC animated:animated];
}

- (void)openViewWithClass:(Class)viewClass WithNib:(BOOL)withNib
{
    return [self openViewWithClass:viewClass Animation:true WithNib:withNib];
}

- (void)openViewWithClass:(Class)viewClass Animation:(BOOL)doAnimation WithNib:(BOOL)withNib {
    BaseViewController *subView = nil;
    if (withNib)
    {
        subView = [[viewClass alloc] initWithNibName:NSStringFromClass(viewClass)
                                              bundle:[NSBundle mainBundle]];
    }
    else
    {
        subView = [[viewClass alloc] init];
    }
    [self open:subView];
}

- (void)close {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeWithAnimated:(BOOL)animated {
    [self.navigationController popViewControllerAnimated:animated];
}

- (void)closeToViewController:(Class)target {
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController *control in viewControllers) {
        if ([control isKindOfClass:target]) {
            [self.navigationController popToViewController:control animated:NO];
        }
    }
}

- (void)closeKeybord
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self closeKeybord];
}

- (void)closeHud:(MBProgressHUD *)hud {
//    __weak typeof(self) wself = self;
    [hud hideAnimated:YES];
    hud = nil;
}

//计算出当前View除状态栏，导航栏 高度可用高区域，IOS6直接反回self.view.frame
- (CGRect)selfFullRect
{
    CGRect rect = self.view.frame;
    //IOS7 及后版本才透明
    /*
     if (self.navigationController.navigationBar.translucent &&
     !self.navigationController.navigationBarHidden)
     {
     CGFloat topHeight = self.navigationController.navigationBar.frame.size.height;
     UIApplication *app = [UIApplication sharedApplication];
     if (!app.statusBarHidden)
     {
     topHeight += app.statusBarFrame.size.height;
     topHeight -= [self.view convertRect:self.view.bounds toView:self.view.window].origin.y; //20 开启个人热点
     }
     rect.origin.y    = topHeight;
     rect.size.height -= topHeight;
     }
     */
    //+ 状态栏 高度，应该在64，开启个人热点时，也是
    CGFloat topHeight = self.navigationController.navigationBar.subviews[0].frame.size.height; //
    rect.origin.y    = topHeight;
    rect.size.height -= topHeight;
    
    //    rect = [self.view convertRect:self.view.bounds toView:self.view.window];
    
    return rect;
}

@end
