//
//  UIZoomScaleView.m
//  
//
//  Created by 邱家楗 on 16/3/25.
//  Copyright © 2016年 tigo soft. All rights reserved.
//

#import "UIZoomScaleView.h"

#import "UIView+Category.h"

@interface UIZoomScaleView ()

@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) BOOL autoLayout;  //有调用过layoutImageView 才会设为YES

@end

@implementation UIZoomScaleView

@dynamic canZoomScale;

- (void)setCanZoomScale:(BOOL)canZoomScale
{
    if (canZoomScale)
    {
        self.maximumZoomScale = 2.5;
    }
    else
    {
        if (self.zoomScale > 1)
        {
            [self setZoomScale:1 animated:YES];
        }
        self.maximumZoomScale = 1;
    }
}

- (BOOL)canZoomScale
{
    return self.maximumZoomScale > self.minimumZoomScale;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIImageView *zoomImageView = (UIImageView *)[self viewForZoomingInScrollView: scrollView];
    if (!zoomImageView)
    {
        return;
    }
    
    CGRect frame = zoomImageView.frame;
    
    //当视图不能填满整个屏幕时，让其居中显示
    UIView *superView = self;
    frame.origin.x = (CGRectGetWidth(superView.frame) > CGRectGetWidth(frame)) ? (CGRectGetWidth(superView.frame) - CGRectGetWidth(frame))/2 : 0;
    frame.origin.y = (CGRectGetHeight(superView.frame) > CGRectGetHeight(frame)) ? (CGRectGetHeight(superView.frame) - CGRectGetHeight(frame))/2 : 0;
    if (fabs(scrollView.zoomScale - 1.0) < FLT_EPSILON) {
        frame.size = _imageSize;
        scrollView.contentSize = frame.size;
    }
    
    zoomImageView.frame = frame;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]])
            return view;
    }
    
    return nil;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.minimumZoomScale       = 1;
        self.maximumZoomScale       = 2.5;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        self.backgroundColor                = [UIColor clearColor];
        
        self.pagingEnabled = NO;
        self.delaysContentTouches = YES;
        self.canCancelContentTouches = YES;
        self.bounces = YES;
        self.bouncesZoom = YES;
        
        self.delegate = self;
        
        _autoLayout = NO;
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                   action:@selector(doubleClickAction:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        _doubleTap = doubleTap;
#if ! __has_feature(objc_arc)
        [doubleTap release];
#endif
    }
    return self;
}

-(void)dealloc
{
    _doubleTap = nil;
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)doubleClickAction:(UITapGestureRecognizer *)tap
{
    if (self.isZooming || !self.canZoomScale)return;
    CGFloat zoomScale = self.zoomScale;
    
    if(zoomScale < 1.0 + FLT_EPSILON) {
        CGPoint loc = [tap locationInView: self];
        CGRect rect = CGRectMake(loc.x - 0.5, loc.y - 0.5, 1, 1);
        
        [self zoomToRect:rect animated:YES];
    }else {
        [self setZoomScale:1 animated:YES];
    }
//    CGFloat zs = self.zoomScale;
//    zs = (zs <= 1.0) ? 2.0 : 1.0;
//    CGPoint location = [tap locationInView:self];
//    [self scrollRectToVisible:CGRectMake(location.x, location.y, 20, 20) animated:FALSE];
//    
//    location.x = location.x * zs;
//    location.y = location.y * zs;
//    [UIView animateWithDuration:0.2 animations:^{
//        self.zoomScale = zs;
//        
//        [self scrollRectToVisible:CGRectMake(location.x, location.y, 20, 20) animated:FALSE];
//    }];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (self.canZoomScale && _autoLayout)
    {
        [self layoutImageView];  //横竖屏转换时要用到
    }
}

- (void)layoutImageView {
    
    _autoLayout = YES;
    
    UIImageView *imageView = (UIImageView *)[self viewForZoomingInScrollView: self];
    
    if (nil == self.superview || nil == imageView || self.zooming || self.zoomScale > 1)
        return;
    
    _imageSize = imageView.image.size;
    
    CGSize full = self.superview.frame.size; //screen.bounds
    [UIView layoutImageSize:_imageSize showSize:full returnBlock:^(CGSize newImageSize, CGRect rect, BOOL smallImage) {
        
        _imageSize      = newImageSize;
        imageView.frame = rect;
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.contentSize = _imageSize;
        
        //设置缩放范围
        self.minimumZoomScale = 1;
        CGFloat scale1 = _imageSize.width < full.width ? (full.width / _imageSize.width) : 0;
        CGFloat scale2 = _imageSize.height < full.height ? (full.height / _imageSize.height) : 0;
        
        self.maximumZoomScale = MAX(smallImage ?  MIN(scale1, scale2) : MAX(scale1, scale2), 2.5);
    }];
}

@end
