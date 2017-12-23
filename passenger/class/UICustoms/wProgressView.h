//
//  wProgressView.h
//  wBaiJu
//
//  Created by 邱家楗 on 14-7-23.
//  Copyright (c) 2014年 tigo soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wProgressView : UIView

//模态显示  inViewWindow, 使导航栏也不能点
+ (void)showInfo:(NSString *)info inViewWindow:(UIView *)view;


//非模态显示, 需要自已移除显示  fullView  为YES    与closeInView结事使用
+ (void)showInfo:(NSString *)info InView:(UIView *)inView;

//非模态显示, 需要自已移除显示  FullView 为YES时,inView区域不能点
+ (void)showInfo:(NSString *)info InView:(UIView *)inView FullView:(BOOL)fullView;

//关闭 某个View 中的ProgressView
+ (void)closeInView:(UIView *)inView;

//关闭所有显示ProgressView
+ (void)closeAllViews;

//-(void)show:(NSString*)sInfo InView:(UIView*)inView FullView:(BOOL)fullView;

@end

@interface wShowInfoView : UILabel

@property (nonatomic, assign) float showInfoTime;

- (void)showInfo:(NSString *)sInfo font:(UIFont *)font;

- (void)closeView;

+ (void)showInfo:(NSString *)info;


+ (void)showInfoGray:(NSString *)info;


@end
