//
//  LoginViewModel.m
//  passenger
//
//  Created by 杨星星 on 2017/12/13.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "LoginViewModel.h"
//#import "LoginViewController.h"
#import "BaseNavigationViewController.h"
#import "HomeViewController.h"
#import "MMDrawerController.h" // 抽屉类

@implementation LoginViewModel

+ (void)openHome {
    HomeViewController *homeVC = [HomeViewController new];
    BaseNavigationViewController *homeNav = [[BaseNavigationViewController alloc ]initWithRootViewController:homeVC];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    window.rootViewController = homeNav;
    
    LeftMineViewController * leftVC = [[LeftMineViewController alloc] init];
    leftVC.navController = homeVC;
    
    // 实例化抽屉
    MMDrawerController * drawerVC = [[MMDrawerController alloc] initWithCenterViewController:homeNav leftDrawerViewController:leftVC];
    // 设置抽屉打开和关闭的手势模式
    drawerVC.openDrawerGestureModeMask  = MMOpenDrawerGestureModeAll;
    drawerVC.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    drawerVC.showsShadow = NO;
    // 设置距离边界的距离
    drawerVC.maximumLeftDrawerWidth = LeftVCWidth;
    window.rootViewController = drawerVC;
}

+ (void)openLogin {
//    BaseNavigationViewController *loginNav = [[BaseNavigationViewController alloc ]initWithRootViewController:[LoginViewController new]];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    window.rootViewController = loginNav;
}

@end
