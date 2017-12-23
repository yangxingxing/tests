//
//  HSUIScrollView.h
//  iPodDemo
//
//  Created by apple on 11-11-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "HSUIImageButton.h"

@class HSUIScrollView;


@protocol HSUIScrollViewDelegate <NSObject>
@required

//取得记录数(页数)
- (NSUInteger)scrollViewPageCount:(HSUIScrollView *)scrollView;

/**
 *  新增项目,
 *
 *  @param scrollView HSUIScrollView
 *  @param index      新增的页 从1开始

 *  @return 返回对应页要显示的UIView 要autorelease
 */
- (UIView *)scrollView:(HSUIScrollView *)scrollView PageIndex:(NSUInteger)pageIndex;

@optional

//翻页 toPageIndex从1开始
- (void)scrollView:(HSUIScrollView *)scrollView ToPageIndex:(NSUInteger)toPageIndex;


@end


@interface HSUIScrollView : UIScrollView

//加载数据
- (void)reloadData;

- (void)reloadDataFromPageIndex:(NSUInteger)fromPageIndex;

- (void)clearSubViews;

//用于取当前pageIndex所在View, 及前后页面。其它情况下无效
- (UIView *)viewWithPage:(NSUInteger)pageIndex;

@property (nonatomic, assign)NSObject<HSUIScrollViewDelegate> *dataDelegate;

/**
 *  当前页 从1开始
 */
@property (nonatomic)NSUInteger pageIndex;

- (void)setPageIndex:(NSUInteger)pageIndex Animate:(BOOL)animate;

/**
 *  总页数
 */
@property (nonatomic, readonly) NSUInteger pageCount;

//正在设置 页面，主要是因为有动画期间为YES
@property (nonatomic, readonly) BOOL setPageing;

@property (nonatomic, assign) CGFloat pageSpace; //每页间隔 default 0

@end
