//
//  SplanshViewController.m
//  114SDShop
//
//  Created by 杨星星 on 2017/5/22.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "SplanshViewController.h"
#import "GuidePageView.h"
#import <ReactiveObjC.h>
#import "HomeViewController.h"
#import "LoginViewModel.h"

@interface SplanshViewController (){
    int _failCount;
}

@property(nonatomic,strong) GuidePageView * guidePageView;
//@property(nonatomic,strong) HomeTabBarViewController *home;
//
@property (nonatomic, strong) UIImageView *backImageView;
//
//@property (nonatomic, strong) AMapLocation *amap;

@end

@implementation SplanshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _amap = [AMapLocation new];
    //添加引导页
    [self addGuidePageView];
}

- (void)initViews {
    _backImageView = [MyTools createImageViewWithFrame:self.view.bounds imageName:@"white_launchImage.jpg"];
    _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backImageView.autoresizingMask = UIAutoSizeMaskAll;
    [self.view addSubview:_backImageView];
}

#pragma mark - 引导页
-(void)addGuidePageView
{
    BOOL firstLaunch  = [[[NSUserDefaults standardUserDefaults] objectForKey:APPFirstLaunch] boolValue];
    if (!firstLaunch) {
    
        NSArray * imageArray = @[@"splashScreen1",@"splashScreen2"];
        
        self.guidePageView = [[GuidePageView alloc]initWithFrame:self.view.bounds imageArray:imageArray];
        [self.view addSubview:self.guidePageView];
        
        //需要记录已经是第一次运行过
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:APPFirstLaunch];
        
        //跳转按钮
        @weakify(self)
        [[self.guidePageView rac_signalForSelector:@selector(removeBtnClick)] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self.guidePageView removeFromSuperview];
            [LoginViewModel openHome];
        }];
    } else {
        [LoginViewModel openHome];
//        [self initViews];
    }
}

- (void)excuteLogin {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setBool:NO forKey:APPIsLogin];
//
//    User *user = [User standardUserInfo];
//    if (user.UserId && user.UserId.length > 0) {
//        [self openIMLogin:user.UserId];
//    } else {
//        [LoginViewModel openLogin];
//    }
}


@end
