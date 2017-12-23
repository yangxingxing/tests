//
//  HSUITabScrollView.m
//  navViewController
//
//  Created by 邱家楗 on 15/11/18.
//  Copyright © 2015年 邱家楗. All rights reserved.
//

#import "HSUITabScrollView.h"
#import "UIView+MaskWithPath.h"

@interface HSUITabScrollView()
<HSUIScrollViewDelegate>
{
    UIScrollView   *_topButtonsView;     //顶部按钮View
    HSUIScrollView *_scrollView;         //页面数据
    UIView         *_focusLineView;      //得到焦点 线颜色
    
    NSInteger _prePageIndex;
    
    NSMutableDictionary *_topButtons;    //顶部按钮
    NSObject<HSUITabScrollViewDelegate> *_delegate;
}

@end

@implementation HSUITabScrollView

@dynamic delegate;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self selfInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self selfInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self selfInit];
    }
    return self;
}

- (void)selfInit
{
    if (_scrollView)
        return;
    self.scrollEnabled = NO;
    self.scrollsToTop  = NO;
    
    _prePageIndex = 0;
    
    //上部按钮宽度，默认为0，为0时会按View.width / pageCount
    _topButtonWidth = 0;
    
    //上部按钮高度，默认为40 - 42
    _topButtonHeight = [WBJUIFont tableViewSingleRowHeight];
    
    _topButtonOffset = CGPointZero;

    //上部按钮 下面线条高度
    _topLineHeight = 0.5;
    
    _topFocusLineHeight = 1.5;
    
    _topButtonRound = NO;
    
    //上部按钮 下面线条颜色 默认浅灰色
    self.topLineColor   = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    
    //当前页按钮底部线颜色 默认 橙色
    self.focusLineColor = [UIColor orangeColor];
    
    _topButtonsView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self addSubview:_topButtonsView];
    _topButtonsView.backgroundColor                = self.topLineColor;
    _topButtonsView.showsHorizontalScrollIndicator = NO;
    _topButtonsView.showsVerticalScrollIndicator   = NO;
    _topButtonsView.scrollsToTop                   = NO;
    _topButtonsView.autoresizingMask               = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    
    
    _scrollView = [[HSUIScrollView alloc] initWithFrame:CGRectZero];
    [self addSubview:_scrollView];
    _scrollView.backgroundColor  = [UIColor whiteColor];
    _scrollView.dataDelegate     = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _focusLineView = [[UIView alloc] initWithFrame:CGRectZero];
    _focusLineView.backgroundColor = self.focusLineColor;
    [_topButtonsView addSubview:_focusLineView];
    
    _topButtons = [[NSMutableDictionary alloc] init];
    
#if !__has_feature(objc_arc)
    [_topButtonsView release];
    [_scrollView release];
    [_focusLineView release];
#endif

}

- (void)dealloc
{
    [_topButtons removeAllObjects];
    self.focusLineColor = nil;
    self.topLineColor   = nil;
    self.delegate       = nil;
#if !__has_feature(objc_arc)
    [_topButtons release];
    [super dealloc];
#endif
}

- (NSObject<HSUITabScrollViewDelegate> *)delegate
{
    return _delegate;
}

- (void)setDelegate:(NSObject<HSUITabScrollViewDelegate> *)delegate
{
    _delegate = delegate;
}

/**
 *  当前页 从0开始
 */
- (NSUInteger)pageIndex
{
    return _scrollView.pageIndex;
}

- (void)setPageIndex:(NSUInteger)pageIndex
{
    _scrollView.pageIndex = pageIndex;
}

/**
 *  总页数
 */
- (NSUInteger)pageCount
{
    return _scrollView.pageCount;
}


//加载数据
- (void)reloadData
{
    [self reloadDataFromPageIndex:0];
}

- (void)reloadDataFromPageIndex:(NSUInteger)fromPageIndex
{
    _prePageIndex = 0;
    
    [self clearTopButtons];
    
    [self setViewFrames];
    
    [self createTopButtons];

    [_scrollView reloadDataFromPageIndex:fromPageIndex];
}

/**
 *  计算单个按钮宽度
 *
 *  @return 按钮宽度
 */
- (CGFloat)calcTopButtonWidth
{
    CGFloat result = _topButtonWidth;
    if (result <= 0 && self.pageCount > 0)
        result = (self.frame.size.width - (_topButtonOffset.x  * 2)) / (CGFloat)self.pageCount;
    return result;
}

//移除所有的按钮
- (void)clearTopButtons
{
    [_topButtonsView scrollRectToVisible:CGRectZero animated:YES];
    
    for (UIView* view in _topButtons.allValues) {
        [view removeFromSuperview];
    }
    [_topButtons removeAllObjects];
    
    _topButtonsView.contentSize   = CGSizeMake(0, 0);
    _topButtonsView.contentOffset = CGPointMake(0, 0);
}

//创建所有按钮
- (void)createTopButtons
{
    CGFloat buttonWidth = [self calcTopButtonWidth];
    _focusLineView.frame  = CGRectMake(_topButtonOffset.x, self.topButtonHeight + self.topLineHeight - self.topFocusLineHeight ,
                                       buttonWidth, self.topFocusLineHeight);//self.topLineHeight
    
    _topButtonsView.contentSize = CGSizeMake(buttonWidth * self.pageCount, 0);
    
    CGFloat x = _topButtonOffset.x;
    BOOL customSet = _delegate && [_delegate respondsToSelector:@selector(tabScrollView:PageButton:PageIndex:)];
    
    NSInteger pageCount = self.pageCount;
    for (NSInteger i = 0; i < pageCount; i++) {
        UIButtonCustom *button = [UIButtonCustom buttonWithType:UIButtonTypeCustom];
        [_topButtonsView addSubview:button];
        [_topButtons setObject:button forKey:@(i)];
        
        button.backgroundColor = [UIColor whiteColor];        //默认为白色
        button.titleLabel.font = [WBJUIFont tableViewFont];   //设置标准字体
        [button setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        
        CGRect rect = CGRectMake(x, _topButtonOffset.y, buttonWidth, _topButtonHeight - _topButtonOffset.y);
        //先算好，方便外部直接使用
        button.frame = rect;
        
        if (_topButtonRound)
        {
            UIBezierPath *path = nil;
            
            //qiujj 小于0.8 在旧iPod 中间竖线显示不出来
            CGFloat borderWidth  = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? UIButtonBorderWidth : UIButtonBorderWidth * 2.0;
            UIColor *borderColor = UITableViewSeparatorColor;
            CGSize radii         = CGSizeMake(4, 4);
            CGRect rect          = button.bounds;
            if (i == 0)
            {
                rect.size.width += borderWidth * 0.5;
                path = [UIBezierPath bezierPathWithRoundedRect: rect
                                             byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft
                                                   cornerRadii: radii];
            }
            else
            if (i == pageCount - 1)
            {
                rect.size.width -= borderWidth;
                path = [UIBezierPath bezierPathWithRoundedRect: rect
                                             byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomRight
                                                   cornerRadii: radii];
            }
            else
            {
                rect.size.width += borderWidth * 0.5;
                path = [UIBezierPath bezierPathWithRoundedRect: rect
                                             byRoundingCorners: UIRectCornerAllCorners
                                                   cornerRadii: CGSizeMake(0, 0)];
            }

            [button setMaskWithPath: path
                    withBorderColor: borderColor
                        borderWidth: borderWidth];
        }
        if (customSet)
        {
            [_delegate tabScrollView:self PageButton:button PageIndex:i + 1];
        }
        
        button.frame = rect;
        x += buttonWidth;
        
        [button addTarget:self
                   action:@selector(buttonClick:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    [_focusLineView.superview bringSubviewToFront:_focusLineView];
}

//按钮单击事件， 切换页面
- (void)buttonClick:(UIButton *)sender
{
    UIButton *preButton = (UIButton*)[_topButtons objectForKey:@(self.pageIndex - 1)];
    if (preButton == sender || _scrollView.setPageing)  //_scrollView.setPageing 要判断，不然按钮点快，会导致 线条错位
        return;
    
//    if (preButton)
//        preButton.selected = NO;
    
    NSInteger index = [_topButtons.allValues indexOfObject:sender];
    
    if (index != NSNotFound)
    {
//        sender.selected = YES;
        NSNumber *page = _topButtons.allKeys[index];
        [_scrollView setPageIndex:[page intValue] + 1 Animate:YES];
    }
}

//重新布局控件
- (void)setViewFrames
{
    _topButtonsView.backgroundColor = self.topLineColor;
    
    CGRect rect = self.frame;
    CGFloat h   = self.topButtonHeight + self.topLineHeight;
    _topButtonsView.frame = CGRectMake(0, 0, rect.size.width, h);
    
    CGFloat buttonWidth = [self calcTopButtonWidth];
    CGRect r = _focusLineView.frame;
    r = CGRectMake(r.origin.x, h - self.topFocusLineHeight,
                   buttonWidth, self.topFocusLineHeight);
    _focusLineView.frame  = r;
    _focusLineView.backgroundColor = self.focusLineColor;
    
    //导航栏透明时， + self.bounds.origin.y 为-64
    _scrollView.frame = CGRectMake(0, h, rect.size.width, rect.size.height - h + self.bounds.origin.y);
    CGFloat contentInsetBottom = _scrollView.contentInset.bottom;
    if (self.contentInset.bottom != 0)
    {
        contentInsetBottom = self.contentInset.bottom;
    }
    //让页面 向上 偏移0.5，主要是为了，不要让UITableViewCustom 的tableHeaderView的线条与topLine重加变粗
    UIEdgeInsets edgeInsets = _scrollView.contentInset;
    if (self.topLineHeight > 0)
        edgeInsets.top    = -0.5;
    edgeInsets.bottom = contentInsetBottom;
    _scrollView.contentInset = edgeInsets;
    
    for (NSNumber *page in _topButtons.allKeys) {
        UIButton *button = (UIButton*)[_topButtons objectForKey:page];
        button.frame = CGRectMake(page.intValue * buttonWidth + _topButtonOffset.x,
                                  _topButtonOffset.y, buttonWidth, self.topButtonHeight - _topButtonOffset.y);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setViewFrames];
}

- (UIScrollView*)scrollView
{
    return _scrollView;
}

//用于取当前pageIndex所在View, 及前后页面。其它情况下无效
- (UIView *)viewWithPage:(NSUInteger)pageIndex
{
    return [_scrollView viewWithPage:pageIndex];
}

- (UIButton*)buttonWithPage:(NSUInteger)pageIndex
{
    return [_topButtons objectForKey:@(pageIndex - 1)];
}

#pragma mark HSUIScrollView Delegate
//取得记录数(页数)
- (NSUInteger)scrollViewPageCount:(HSUIScrollView*)scrollView
{
    return _delegate ? [_delegate tabScrollViewPageCount:self] : 0;
}

- (UIView*)scrollView:(HSUIScrollView*)scrollView PageIndex:(NSUInteger)index
{
    return _delegate ? [_delegate tabScrollView:self PageIndex:index] : nil;
}

//翻页 toPageIndex从1开始
- (void)scrollView:(HSUIScrollView *)scrollView ToPageIndex:(NSUInteger)toPageIndex
{
    //if (_prePageIndex == toPageIndex)
    //    return;
    
    NSInteger prePageIndex = _prePageIndex;
    UIButton *preButton = nil;
    if (_prePageIndex > 0)
        preButton = (UIButton*)[_topButtons objectForKey:@(_prePageIndex - 1)];
    _prePageIndex = toPageIndex;
    
    if (preButton)
        preButton.selected = NO;
    
    UIButton *button = (UIButton*)[_topButtons objectForKey:@(toPageIndex - 1)];
    if (button)
        button.selected = YES;
    
    [UIView animateWithDuration:0.25 animations:^{

        //如果按钮看不到，则把按钮移动可显示位置
        CGFloat x = (toPageIndex - 1.0) * [self calcTopButtonWidth];
        CGFloat dec = x - _topButtonsView.contentOffset.x + 1.0;
        if (dec < 0 || dec > self.frame.size.width)
        {
            dec = x + [self calcTopButtonWidth] - _topButtonsView.frame.size.width;
            if (dec < 0)
                dec = 0;
            _topButtonsView.contentOffset = CGPointMake(dec, 0);
        }
        
        //设置焦点线位置
        CGRect rect = _focusLineView.frame;
        rect.origin.x = (toPageIndex - 1) * [self calcTopButtonWidth] + _topButtonOffset.x;
        _focusLineView.frame = rect;
    }];

    if (_delegate && [_delegate respondsToSelector:@selector(tabScrollView:ToPageIndex:PrePageIndex:)])
        [_delegate tabScrollView:self ToPageIndex:toPageIndex PrePageIndex:prePageIndex];
}


@end
