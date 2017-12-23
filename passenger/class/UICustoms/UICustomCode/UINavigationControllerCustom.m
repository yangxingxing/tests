//
//  UINavigationControllerCustom.m
//  wBaijuApi
//
//  Created by 邱家楗 on 16/8/6.
//  Copyright © 2016年 tigo soft. All rights reserved.
//

#import "UINavigationControllerCustom.h"
#import "UIConsts.h"
#import "UIColor+Hex.h"

@interface UINavigationViewcontrollerManager : NSObject

+ (instancetype)share;

@property (nonatomic, strong) NSMutableArray *viewControllers;

@end

@implementation UINavigationViewcontrollerManager

+ (instancetype)share
{
    static UINavigationViewcontrollerManager *manage = nil;
    static dispatch_once_t onece;
    dispatch_once(&onece, ^{
        manage = [[self alloc]init];
    });
    return manage;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _viewControllers = [[NSMutableArray alloc]init];
    }
    return self;
}

//- (void)dealloc
//{
//    [_viewControllers release];
//    [super dealloc];
//}

@end

@interface UINavigationControllerCustom ()
<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

//@property (nonatomic, strong) UIPanGestureRecognizer *popPanGesture;
@property (nonatomic, assign) Class viewControllerPushing;
//@property (nonatomic, strong) UIView *blurBackView;

@end

@implementation UINavigationControllerCustom

//- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
//    if (self = [super init]) {
//        
//        YQWrapViewController * wrapVC = [YQWrapViewController wrapViewControllerWithViewController:rootViewController];
//        [[YQNavigationViewcontrollerManage share].viewControllers addObject:wrapVC];
//        self.viewControllers = @[wrapVC];
//    }
//    return self;
//}

//防 微信 导航栏 在导航栏 最底导插入 blurBackView
//- (UIView *)blurBackView
//{
//    if (_blurBackView == nil) {
//        _blurBackView = [UIView new];
//        CGFloat sw = [UIScreen mainScreen].bounds.size.width;
//        _blurBackView.frame = CGRectMake(0, -20, sw, 64);
//        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
//        gradientLayer.frame = CGRectMake(0, 0, sw, 64);
//        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHex:0x040012 alpha:0.76].CGColor,(__bridge id)[UIColor colorWithHex:0x040012 alpha:0.28].CGColor];
//        gradientLayer.startPoint = CGPointMake(0, 0);
//        gradientLayer.endPoint = CGPointMake(0, 1.0);
//        [_blurBackView.layer addSublayer:gradientLayer];
//        _blurBackView.userInteractionEnabled = NO;
//        _blurBackView.alpha = 0.5;
//    }
//    return _blurBackView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarHidden:YES];
    self.delegate = self;
//    UIView *v1 = self.navigationBar.subviews[0];
    //[self.navigationBar insertSubview:self.blurBackView atIndex:1];
//    [v1 insertSubview:self.blurBackView atIndex:0];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //    if (self.fullScreenPopGestureEnable) {
    //        id target = self.interactivePopGestureRecognizer.delegate;
    //        SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    //        self.popPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
    //        [self.view addGestureRecognizer:self.popPanGesture];
    //        self.popPanGesture.maximumNumberOfTouches = 1;
    //        self.interactivePopGestureRecognizer.enabled = NO;
    //    } else {
    self.interactivePopGestureRecognizer.delegate = self;
    //    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (animated && _viewControllerPushing && [viewController isMemberOfClass:_viewControllerPushing] &&
        self.viewControllers.count > 1 && viewController != self.viewControllers.lastObject)
    {
        SLog(@"viewControllerPushing...");
        return;
    }
    _viewControllerPushing = [viewController class];
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


//解决某些情况push会卡死的情况
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    _viewControllerPushing = nil;
    //    BOOL isRootVC = viewController == navigationController.viewControllers.firstObject;
    //    id target = self.interactivePopGestureRecognizer.delegate;
    //    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    //    if (self.fullScreenPopGestureEnable) {
    //        if (isRootVC) {
    //            [self.popPanGesture removeTarget:target action:action];
    //        } else {
    //            [self.popPanGesture addTarget:target action:action];
    //        }
    //    } else
    //    {
    //        [self.popPanGesture removeTarget:target action:action];
    //    }
    //    self.interactivePopGestureRecognizer.enabled = !isRootVC;  //qiujj 不能再这设置，不然外面各个ViewController不好控制
}

//修复有水平方向滚动的ScrollView时边缘返回手势失效的问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

//是否支持转屏
-(BOOL)shouldAutorotate{
    if (self.topViewController)
    {
        if ([self.topViewController respondsToSelector:@selector(viewClosed)])
        {
            //解决有些手机 横屏时，关闭 会闪屏（不会全屏）
            if ([[self.topViewController valueForKey:@"_viewClosed"] boolValue])
            {
                return NO;
            }
        }
        return [self.topViewController shouldAutorotate];
    }
    return NO;
}

//支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.topViewController)
    {
        if ([self.topViewController respondsToSelector:@selector(viewClosed)])
        {
            //解决有些手机 横屏时，关闭 会闪屏（不会全屏）
            if ([[self.topViewController valueForKey:@"_viewClosed"] boolValue])
            {
                self.topViewController.view.frame = self.view.frame;
                return UIInterfaceOrientationMaskPortrait;
            }
        }
        return [self.topViewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return self.topViewController.prefersStatusBarHidden;
}

//默认的屏幕方向
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return self.topViewController ? [self.topViewController preferredInterfaceOrientationForPresentation] : UIInterfaceOrientationPortrait;
//}

@end


/**
 *  真正意义上的展示的导航视图
 *
 *  @return 展示的导航视图
 */
#pragma mark - UINavigationControllerInternal


/**
 *  展示视图NavigationController
 */
@implementation UINavigationControllerInternal

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [[UINavigationViewcontrollerManager share].viewControllers removeLastObject];
    
//    NSLog(@"%lu",(unsigned long)[YQNavigationViewcontrollerManage share].viewControllers.count);
    UINavigationControllerInternal *na = (UINavigationControllerInternal *)self.navigationController;
    return [na popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    [[UINavigationViewcontrollerManager share].viewControllers removeAllObjects];
    
    UINavigationControllerInternal *na = (UINavigationControllerInternal *)self.navigationController;
    return [na popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UINavigationControllerInternal *na = (UINavigationControllerInternal *)self.navigationController;
    return [na popToViewController:viewController animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    viewController.hidesBottomBarWhenPushed = YES;
    UINavigationControllerInternal *na = (UINavigationControllerInternal *)self.navigationController;
    
    [[UINavigationViewcontrollerManager share].viewControllers addObject:viewController];
    [na pushViewController:viewController animated:animated];
}

@end

