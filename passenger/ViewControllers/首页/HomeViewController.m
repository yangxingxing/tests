//
//  HomeViewController.m
//  passenger
//
//  Created by 杨星星 on 2017/12/13.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "HomeViewController.h"
#import "PersonalViewController.h"
#import "OfficialViewController.h"

@interface HomeViewController () <UIScrollViewDelegate> {

    UIScrollView * _scrollView;
    UIButtonCustom *_officialBtn,*_personalBtn;
    UIView *_backView;
    
    UIButtonCustom *_leftBtn,*_rightBtn;
}


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar addSubview:_leftBtn];
    [self.navigationController.navigationBar addSubview:_rightBtn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_leftBtn removeFromSuperview];
    [_rightBtn removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)updateNavUI {
    UIButtonCustom *leftBtn = [MyTools createButtonWithFrame:self.leftButton.frame title:nil titleColor:nil imageName:@"menu_icon_navbar" backgroundImageName:nil target:self selector:@selector(leftBarButtonClick)];
    _leftBtn = leftBtn;
    [self.navigationController.navigationBar addSubview:leftBtn];
    
    UIButtonCustom *rightBtn = [MyTools createButtonWithFrame:self.rightButton.frame title:nil titleColor:nil imageName:@"n_news_icon_navbar" backgroundImageName:nil target:self selector:@selector(rightBarButtonClick)];
    rightBtn.x = SCREENW - rightBtn.width;
    _rightBtn= rightBtn;
    [self.navigationController.navigationBar addSubview:rightBtn];
    
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 36)];
    titleView.backgroundColor = [UIColor colorWithHexString:@"2688c9"];
    self.navigationItem.titleView = titleView;
    UIButtonCustom *officialBtn = [MyTools createButtonWithFrame:CGRectMake(0, 0, titleView.width/2, titleView.height) title:@"公务" titleColor:[UIColor colorWithHexString:@"#86c4ed"] imageName:nil backgroundImageName:nil target:self selector:@selector(officialBtnClick:)];
    _officialBtn = officialBtn;
    [titleView addSubview:officialBtn];
    officialBtn.selected = YES;
    
    UIButtonCustom *personalBtn = [MyTools createButtonWithFrame:CGRectMake(officialBtn.width, 0, officialBtn.width, officialBtn.height) title:@"个人" titleColor:[UIColor colorWithHexString:@"#86c4ed"] imageName:nil backgroundImageName:nil target:self selector:@selector(personalBtnClick:)];
    _personalBtn = personalBtn;
    [titleView addSubview:personalBtn];
    
    [officialBtn setTitleColor:textBrownColorPass forState:(UIControlStateSelected)];
    [personalBtn setTitleColor:textBrownColorPass forState:(UIControlStateSelected)];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleView.width/2 - 2, titleView.height - 2)];
    _backView = backView;
    backView.center = officialBtn.center;
    backView.backgroundColor = textWhiteColor;
    [titleView addSubview:backView];
    [backView setBorderWithRadius:backView.height/2 borderColor:[UIColor clearColor]];
    [titleView sendSubviewToBack:backView];
    
    [titleView setBorderWithRadius:titleView.height/2 borderColor:[UIColor clearColor]];
}

- (void)leftBarButtonClick {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)rightBarButtonClick {
    
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if(self.mm_drawerController.openSide != MMDrawerSideNone){
//        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    }
//}

- (void)officialBtnClick:(UIButtonCustom *)btn {
    btn.selected = YES;
    _personalBtn.selected = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _backView.center = btn.center;
    }];
    // 改变_scrollView的偏移
    [_scrollView setContentOffset:CGPointMake(0 , 0) animated:NO];
}

- (void)personalBtnClick:(UIButtonCustom *)btn {
    btn.selected = YES;
    _officialBtn.selected = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _backView.center = btn.center;
    }];
    // 改变_scrollView的偏移
    [_scrollView setContentOffset:CGPointMake(SCREENW , 0) animated:NO];
}

#pragma mark - 主页面
- (void)createUI {
    // 创建scrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH - 44)];
    
    _scrollView.delegate = self;
    
    OfficialViewController * Official = [[OfficialViewController alloc] init];
    Official.view.frame = CGRectMake(0, 0, SCREENW, SCREENH - 64);
    
    // 把当前视图作为容器视图，将控制器作为子视图添加到当前视图中
    [self addChildViewController:Official];
    
    // 添加控制器视图到scrollView
    [_scrollView addSubview:Official.view];
    
    PersonalViewController * personal = [[PersonalViewController alloc] init];
    personal.view.frame = CGRectMake(SCREENW, 0, SCREENW, SCREENH - 64);
    personal.nacController = Official.nacController = self;
    personal.useCarType = UseCarTypePersonal;
    
    // 把当前视图作为容器视图，将控制器作为子视图添加到当前视图中
    [self addChildViewController:personal];
    
    // 添加控制器视图到scrollView
    [_scrollView addSubview:personal.view];
    
    // 设置scrollView的大小
    _scrollView.contentSize = CGSizeMake(SCREENW * 2, 0);
    // 设置按页滚动
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    // 去掉横向滑动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    // 去掉弹跳效果
    _scrollView.bounces = NO;
    
    [self.view addSubview:_scrollView];

}

@end
