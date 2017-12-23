//
//
//
//  Created by apple on 11-11-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "HSUIScrollView.h"
#import "UIView+Category.h"
#import <QuartzCore/QuartzCore.h>

@interface HSUIScrollView()
{
    NSMapTable *_loadViews;
    int _unLoadItem;
    BOOL _zoomScaleing;
}

@end

@implementation HSUIScrollView


- (void)doInit
{
    if (_loadViews)
        return;
    
    _pageIndex = 0;
    _dataDelegate = nil;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator   = NO;
    self.pagingEnabled = YES;
    _loadViews  = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory
                                        valueOptions:NSPointerFunctionsWeakMemory];
#if !__has_feature(objc_arc)
    [_loadViews retain];
#endif
    _unLoadItem = 0;
    _setPageing = NO;
    _pageSpace  = 0;
    //scrollview 与 右滑手势冲突问题解决
    [self screenEdgePanGestureRecognizerWithScrollView:self];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self doInit];
    }
    return self;       
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;   
}


- (void)dealloc {
    
    _dataDelegate = nil;
    [_loadViews removeAllObjects];
    
#if !__has_feature(objc_arc)
    [_loadViews release];
#endif
    _loadViews = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif

}


- (NSUInteger)pageCount
{
    NSUInteger count = 0;
    if (_dataDelegate && self.superview)
        count = [_dataDelegate scrollViewPageCount:self];
    return count;
}


- (UIView*)viewWithPage:(NSUInteger)pageIndex
{
    return [_loadViews objectForKey:@(pageIndex)];
}

- (void)loadPageWithPageIndex:(NSUInteger)aPageIndex
{
    NSUInteger dataCount = self.pageCount;
    if (aPageIndex <= 0 || aPageIndex > dataCount)
        return;
    
    //if (_loadViews.count >= dataCount)
    //    return;
    
    UIView *pageView = nil;

    id val = [_loadViews objectForKey:@(aPageIndex)];
    if (val && [val isKindOfClass:[UIView class]])
        pageView = (UIView*)val;
    
    if (!pageView && _dataDelegate)
        pageView = [_dataDelegate scrollView:self PageIndex:aPageIndex];
    if (pageView)
    {
        if (pageView.frame.size.height > [UIScreen mainScreen].bounds.size.height * 0.5 && [pageView isKindOfClass:[UIScrollView class]])
        {
            ((UIScrollView*)pageView).scrollsToTop = aPageIndex == _pageIndex;
        }
        
        [_loadViews setObject:pageView forKey:@(aPageIndex)];
        [self addSubview:pageView];
        CGRect r = self.bounds;
        r.origin.y = 0.0;
        r.origin.x = [self leftWithPage:aPageIndex offset:NO];
        r.size.width -= _pageSpace;
        pageView.frame = r;
    }
}

- (CGFloat)leftWithPage:(NSInteger)page offset:(BOOL)offset
{
    //注：bounds 因为UIScrollView 一页是以bounds来处理的
    return (self.bounds.size.width) * (page - 1) + (offset ? 0 : _pageSpace * 0.5);
}

- (CGFloat)contentWidthWithFrame:(CGRect)bounds    //注： frame
{
    NSInteger count = [self pageCount];
    return bounds.size.width * count; // - _pageSpace
}

- (void)setPageSpace:(CGFloat)pageSpace
{
    _pageSpace = pageSpace;
    [self setFrame:self.frame];
}

- (CGRect)updateBoundsWithFrame:(CGRect)frame
{
    CGRect bounds = self.bounds;
    //    bounds.origin.x =  _pageSpace * 0.5;
    bounds.size.width = frame.size.width + _pageSpace;
    [super setBounds:bounds];
    return bounds;
}

- (void)setFrame:(CGRect)frame
{
    CGRect bounds = [self updateBoundsWithFrame:frame];
    //横竖屏切换时，要重新设置 contentSize
    CGFloat contentWidth = [self contentWidthWithFrame:bounds];
    NSUInteger pageIndex = _pageIndex;
    [super setFrame:frame];
    
    if (self.contentSize.width != contentWidth)
    {
        BOOL savePageing = _setPageing;
        _setPageing = YES;
        super.contentSize = CGSizeMake(contentWidth , 0); //会触发 setContentOffset
        if (_pageIndex > 0)
        {
            //            NSUInteger pageIndex = _pageIndex;
            CGFloat toX = [self leftWithPage:pageIndex offset:YES];
            [super setContentOffset:CGPointMake(toX, 0) animated:NO];
            //            _pageIndex = pageIndex;
        }
        _setPageing = savePageing;
    }
    
    if (pageIndex > 0)
    {
        [self setPageIndex:pageIndex Offset:NO Animate:NO];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (NSNumber *pageNum in _loadViews) {
        UIView *pageView = [_loadViews objectForKey:pageNum];
        CGRect r = self.bounds;
        r.origin.y = 0.0;
        r.origin.x = [self leftWithPage:pageNum.integerValue offset:NO];
        r.size.width -= _pageSpace;
        
//        CGRect rect = pageView.frame;
//        rect.origin.y    = 0;
//        rect.size.height = self.frame.size.height;
        pageView.frame = r;
        if (self.contentInset.bottom != 0 && [pageView isKindOfClass:[UIScrollView class]])
        {
            UIScrollView *sc = (UIScrollView*)pageView;
            UIEdgeInsets edgeInsets = sc.contentInset;
            edgeInsets.bottom = self.contentInset.bottom;
            sc.contentInset = edgeInsets;
        }
    }
}

- (void)resetZoomScaleWithView:(UIView*)subView
{
    if (subView && [subView isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scollV = (UIScrollView*)subView;
        if (scollV.zoomScale > 1)
            [scollV setZoomScale:1 animated:YES];
    }
}


- (void)resetZoomScale:(NSUInteger)aPageIndex
{
    UIView * subView = [_loadViews objectForKey:@(aPageIndex)];
    
    if (subView)
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            [self resetZoomScaleWithView:subView];
        }
        else
        if (subView.subviews.count > 0)
        {
            UIView *firtView = [subView.subviews firstObject];
            if (CGSizeEqualToSize(subView.frame.size, firtView.frame.size))
                [self resetZoomScaleWithView:firtView];
        }
    }
}


- (void)loadCurrentPageItem
{
    NSUInteger pageCnt = self.pageCount;
    NSInteger prePage = _pageIndex - 1;
    if (prePage < 1)
        prePage = 1;
    
    NSInteger nextPage = 1;
    if (pageCnt > 1)
    {
        nextPage = _pageIndex + 1;
        if (nextPage > pageCnt)
            nextPage = pageCnt;
    }

    [self loadPageWithPageIndex:_pageIndex];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.16 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //unsigned savePage = _pageIndex;
        [self loadPageWithPageIndex:prePage];
        [self resetZoomScale:prePage];
        //if (_pageIndex != savePage)
        //    self.pageIndex = savePage;
    });
    
    if (_pageIndex != nextPage)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.19 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self loadPageWithPageIndex:nextPage];
            [self resetZoomScale:nextPage];
            
            if (_loadViews.count > 3)
            {
//                NSArray *allKeys = _loadViews.allKeys;
                for (NSNumber *pageNum in _loadViews) {
                    NSInteger val = [pageNum integerValue];
                    if (val < prePage - 1 || val > nextPage + 1)
                    {
                        id val = [_loadViews objectForKey:pageNum];
                        if (val && [val isKindOfClass:[UIView class]])
                        {
                            UIView *v = (UIView*)val;
                            [v removeFromSuperview];
                            //[_loadViews removeObjectForKey:pageNum];
                        }
                    }
                }
            }
        });
}

- (void)setPageIndex:(NSUInteger)aPageIndex
{
    [self setPageIndex:aPageIndex Offset:true Animate:YES];
}

- (void)setPageIndex:(NSUInteger)pageIndex Animate:(BOOL)animate
{
    [self setPageIndex:pageIndex Offset:true Animate:animate];
}

- (void)setPageIndex:(NSUInteger)aPageIndex Offset:(BOOL)reSetOffset Animate:(BOOL)animate
{
    if (_setPageing || aPageIndex == _pageIndex || aPageIndex > self.pageCount)
        return;
    BOOL doAnimate = NO;
    @try {
        _setPageing = YES;
        
        if (aPageIndex <= 0)
            aPageIndex = 1;
        
        if (_dataDelegate && [_dataDelegate respondsToSelector:@selector(scrollView:ToPageIndex:)])
            [_dataDelegate scrollView:self ToPageIndex:aPageIndex];
        
        _pageIndex = aPageIndex;
        
        [self loadCurrentPageItem];
        if (!reSetOffset)
        {
            return;
        }
        CGRect r = self.frame;
        CGFloat toX = [self leftWithPage:_pageIndex offset:YES];
        
        CGPoint offset = self.contentOffset;
        CGFloat dec = toX - offset.x;
        if (dec < 0)
            dec = -dec;
        
        doAnimate = animate && dec >= r.size.width;
        
        if (_pageIndex > 0 && doAnimate)
        {
//            [self setContentOffset:CGPointMake(toX, 0) animated:YES];
//            CGFloat x = toX;
//            if (x > r.size.width)
//                x = x - r.size.width;
            
            //self.contentOffset = CGPointMake(x, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                //self.contentOffset = CGPointMake(toX, 0);
                [super setContentOffset:CGPointMake(toX, 0) animated:YES];
            }completion:^(BOOL finished) {
                _setPageing = NO;
            }];
        }
        else
            if (offset.x != toX) //!animate &&
            {
                //[UIView animateWithDuration:0.3 animations:^{
                //IOS7 微佰聚 聊天查看图片，不是从第一张开始，会有偏移 y = -44
                offset.x = toX;
                //self.contentOffset = offset;
                [super setContentOffset:offset animated:NO];
                //}];
            }
        
        //[self resetZoom];

    }

    @finally {
        if (!doAnimate)
            _setPageing = NO;
    }
}


- (void)reloadData
{
    [self reloadDataFromPageIndex:0];
}

- (void)reloadDataFromPageIndex:(NSUInteger)fromPageIndex
{
    _zoomScaleing = NO;
    _unLoadItem ++;
    NSInteger count = [self pageCount];
    @try {
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollsToTop = NO;
        [self clearSubViews];
        [self updateBoundsWithFrame:self.frame];
        self.contentSize = CGSizeMake([self contentWidthWithFrame:self.bounds] , 0);
    }
    @finally {
        _unLoadItem--;
    }
    _pageIndex = 0;
    NSUInteger page = 0;
    if (count > 0)
    {
        if (fromPageIndex == 0)
            page = 1;
        else
        if (fromPageIndex > 0 && fromPageIndex <= count)
            page = fromPageIndex;
    }
    
    [self setPageIndex:page  Offset:page > 1 Animate:NO];
}

- (void)clearSubViews
{
    _unLoadItem ++;
    @try {
        
        [self scrollRectToVisible:CGRectZero animated:YES];
        self.contentSize = CGSizeMake(0, 0);
        [_loadViews removeAllObjects];
        for (UIView* view in self.subviews) {
            [view removeFromSuperview];
        }
        
        self.contentSize = CGSizeMake(0, 0);
        self.contentOffset = CGPointMake(0, 0);
        
    }
    @finally {
        _unLoadItem --;
    }

}

- (void)setContentOffset:(CGPoint)contentOffset
{
    CGPoint prePoint = self.contentOffset;

    [super setContentOffset:contentOffset];
    if (_unLoadItem > 0)
        return;

    //qiujj round 是最好的, floor ceil 都会有些问题
    NSInteger prePage = round(prePoint.x / self.bounds.size.width) + 1;
    NSInteger page    = round(contentOffset.x / self.bounds.size.width) + 1;
    
    if (prePage != page)
    {
        [self setPageIndex:page Offset:NO Animate:NO];
    }
    //self.pageIndex = page;
}



@end
