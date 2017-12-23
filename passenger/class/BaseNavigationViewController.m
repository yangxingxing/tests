//
//  BaseNavigationViewController.m
//  114SD
//
//  Created by 杨星星 on 2017/3/25.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController () {
    UIView *_bottomView;
}

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 重写这个方法的目的是拦截所有push进来的控制器
 
 @param viewController 即将push进来的控制器
 @param animated 是否有动画效果
 */
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count > 0) {
        // 这是push进来的控制器器不是第一个控制器
        viewController.hidesBottomBarWhenPushed = YES; // 自动隐藏tabbar
        // 设置返回状态的按钮
//        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"header_back_icon" highImage:@"header_back_icon_highlight"];
        
        NSArray *array = self.viewControllers;
        UIViewController *lastVC = array.lastObject;
        
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    NSArray *array = self.viewControllers;
    UIViewController *lastVC = array.lastObject;
    UIViewController *lastSecondVC;
    if (array.count >= 2) {
        lastSecondVC = array[array.count-2];
    }
    
    return [super popViewControllerAnimated:animated];
}

- (void)messageCreateBottomView {
    if (!_bottomView) {
        CGFloat height = 50;
        CGFloat width  = SCREENW;
        CGFloat btnImgHeight = 25;
        NSArray *imageArray = @[@"orange_message",@"message_my_order"];
        NSArray *titleArray = @[@"消息",@"收藏"];
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENH - height, width, height)];
        for (int i = 0; i<titleArray.count; i++) {
            UIButtonCustom *btn = [UIButtonCustom buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = textWhiteColor;
            btn.frame = CGRectMake(i*width/titleArray.count, 0, width/titleArray.count, height);
            
            btn.imageViewFrame = CGRectMake((btn.width - btnImgHeight)/2, 5, btnImgHeight, btnImgHeight);
            btn.titleLabelFrame = CGRectMake(0, CGRectGetMaxY(btn.imageViewFrame)+2, btn.width, 16);
            [btn setImage:ImageNamed(imageArray[i]) forState:UIControlStateNormal];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:GrayColor forState:UIControlStateNormal];
            btn.titleLabel.font = FontSize(14);
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.tag = i + 1000;
            [btn addTopLineWithBorderColor:textLightGrayColor borderWidth:UILineBorderWidth];
            [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:btn];
        }
        _bottomView = bottomView;
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:_bottomView];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    NSArray *array = self.viewControllers;
//    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
//    {
//        NSLog(@"clicked navigationbar back button");
//    }
//}

@end
