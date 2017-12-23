//
//  HSUITabScrollView.h
//
//
//  Created by 邱家楗 on 15/11/18.
//  Copyright © 2015年 邱家楗. All rights reserved.
//

#import "HSUIScrollView.h"
#import "WBJUIFont.h"
#import "UIButtonCustom.h"
#import "UIConsts.h"

@class HSUITabScrollView;

@protocol HSUITabScrollViewDelegate <UIScrollViewDelegate>

@required
//取得记录数(页数)
- (NSUInteger)tabScrollViewPageCount:(HSUITabScrollView *)scrollView;

/**
 *  新增项目,
 *
 *  @param scrollView HSUIScrollView
 *  @param index      新增的页 从1开始
 
 *  @return 返回对应页要显示的UIView 要autorelease
 */
- (UIView *)tabScrollView:(HSUITabScrollView *)scrollView PageIndex:(NSUInteger)pageIndex;

//可通过此方法，设置按钮属性
- (void)tabScrollView:(HSUITabScrollView *)scrollView PageButton:(UIButton *)pageButton
           PageIndex:(NSUInteger)pageIndex;

@optional

//翻页 toPageIndex从1开始  PrePageIndex 为上页PageIndex
- (void)tabScrollView:(HSUITabScrollView *)scrollView ToPageIndex:(NSUInteger)toPageIndex
         PrePageIndex:(NSUInteger)prePageIndex;


@end

//导航栏 透明时，顶部会被导航栏盖掉
@interface HSUITabScrollView : UIScrollView


/**
 *  上部按钮宽度，默认为0，为0时会按View.width / pageCount
 *  如果用户自已赋值 > 0时，且 pageCount * topButtonWidth > View.width时，上部按钮可以左右划动
 */
@property (nonatomic) CGFloat topButtonWidth;

/**
 *  上部按钮高度，默认为40-42 = [WBJUIFont tableViewSingleRowHeight] 
 */
@property (nonatomic) CGFloat topButtonHeight;

//上部按钮偏移位置 默认CGPointZero
@property (nonatomic) CGPoint topButtonOffset;

//按钮圆角显示 默认为NO
@property (nonatomic) BOOL topButtonRound;

/**
 *  上部按钮 下面线条高度，默认0.5
 */
@property (nonatomic) CGFloat topLineHeight;

@property (nonatomic) CGFloat topFocusLineHeight; //default 1.5

/**
 *  上部按钮 下面线条颜色 默认浅灰色
 */
@property (nonatomic, strong) UIColor *topLineColor;

/**
 *  当前页按钮底部线颜色 默认 橙色
 */
@property (nonatomic, strong) UIColor *focusLineColor;

@property (nonatomic, assign) NSObject<HSUITabScrollViewDelegate> *delegate;

@property (nonatomic, assign) NSUInteger pageIndex;        //当前页 从1开始
@property (nonatomic, readonly) NSUInteger pageCount;      //总页数


//加载数据
- (void)reloadData;

- (void)reloadDataFromPageIndex:(NSUInteger)fromPageIndex;

//用于取当前pageIndex所在View, 及前后页面。其它情况下无效
- (UIView *)viewWithPage:(NSUInteger)pageIndex;

//获取页面对应的按钮
- (UIButton *)buttonWithPage:(NSUInteger)pageIndex;

- (UIScrollView *)scrollView;

@end
