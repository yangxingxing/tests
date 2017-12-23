//
//  BaseViewController.h
//  114SD
//
//  Created by 杨星星 on 2017/3/23.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BaseModel.h"

@interface BaseViewController : UIViewController <DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

//左按钮
@property(nonatomic,strong) UIButtonCustom * leftButton;
//标题
@property(nonatomic,strong) UILabelCustom *titleLabel;
//右按钮
@property(nonatomic,strong) UIButtonCustom *rightButton;

@property (nonatomic,copy) NSString *headerTitle;

@property (nonatomic, readonly) BOOL viewAppeared;  //viewController 已经显示

@property(nonatomic,strong) UIColor *navColor;

//响应事件
-(void)leftBarButtonClick;
-(void)rightBarButtonClick;

- (void)open:(UIViewController *)VC;

- (void)open:(UIViewController *)VC animated:(BOOL)animated;

- (void)openViewWithClass:(Class)viewClass WithNib:(BOOL)withNib;

- (void)close;

- (void)closeWithAnimated:(BOOL)animated;

- (void)closeToViewController:(Class)target;

- (void)closeKeybord;

- (void)updateNavUI;

- (void)closeHud:(MBProgressHUD *)hud;
//计算出当前View除状态栏，导航栏 高度可用高区域，IOS6直接反回self.view.frame
- (CGRect)selfFullRect;

@property (nonatomic,strong) BaseViewController *owner;

@end
