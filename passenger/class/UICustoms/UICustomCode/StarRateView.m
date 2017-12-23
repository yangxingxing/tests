//
//  StarRateView.m
//
//  五角星 评分控件
//  Created by 邱家楗 on 16/6/24.
//  Copyright © 2016年 qiujj. All rights reserved.
//

#import "StarRateView.h"
#import <math.h>
#import "UIBezierPath+Shapes.h"


@interface StarRateLayer : CALayer

// Number of stars to display  default 5
@property (nonatomic, assign) NSUInteger starCount;

@property (nonatomic, assign) CGFloat starSize;        //default 30
@property (nonatomic, assign) CGFloat padding;         //default 0.5

@property (nonatomic, strong) UIColor *starColor;

// 曲线五角星 default NO
@property (nonatomic, assign) BOOL starCurve;

@property (nonatomic, strong) NSMutableArray *stars;

#if ! __has_feature(objc_arc)
@property (nonatomic, assign)   UIView *superView;
#else
@property (nonatomic, weak)   UIView *superView;
#endif


- (instancetype)initWithStarSize:(CGFloat)starSize starCount:(NSUInteger)starCount
                       starCurve:(BOOL)starCurve starColor:(UIColor*)starColor
                       superView:(UIView *)superView;
@end

@interface StarRateView ()

@property (nonatomic, strong) StarRateLayer *starRateNormalLayer;
@property (nonatomic, strong) StarRateLayer *starRateFillLayer;

@end

@implementation StarLayer

+ (instancetype)starWithColor:(UIColor *)color frame:(CGRect)frame lineWidth:(CGFloat)lineWidth starCurve:(BOOL)starCurve
{
    StarLayer *starLayer = [[self alloc] initWithColor:color
                                 frame:frame lineWidth:lineWidth starCurve:starCurve];
#if ! __has_feature(objc_arc)
    [starLayer autorelease];
#endif
    return starLayer;
}

- (instancetype)initWithColor:(UIColor *)color frame:(CGRect)frame lineWidth:(CGFloat)lineWidth starCurve:(BOOL)starCurve
{
    if(self = [super init])
    {
        self.lineWidth = lineWidth;
        if (lineWidth > 1)
        {
            self.lineCap   = kCALineCapRound;
            self.lineJoin  = kCALineJoinRound;
        }
        else
        {
            self.lineCap   = kCALineCapButt;
            self.lineJoin  = kCALineJoinMiter;
        }
        self.contentsScale = [[UIScreen mainScreen] scale];
        
        self.frame = frame;
        
        [self setStarCurve:starCurve lineWidth:lineWidth];
        [self updateWithColor:color];
    }
    
    return self;
}

- (void)setStarCurve:(BOOL)starCurve lineWidth:(CGFloat)lineWidth
{
    self.lineWidth = lineWidth;
    self.starCurve = starCurve;
    
    UIBezierPath *starPath;
    if (starCurve)
    {
        starPath = [UIBezierPath starCurvePathWithWidth:self.frame.size.width - self.lineWidth
                                            borderWidth:self.lineWidth];
    }
    else
    {
        starPath = [UIBezierPath starPathWithWidth:self.frame.size.width - self.lineWidth
                                       borderWidth:self.lineWidth];
    }
    self.path = starPath.CGPath;
}

- (void)updateWithColor:(UIColor*)color
{
    self.fillColor   = color.CGColor;
    self.strokeColor = color.CGColor;
    self.borderColor = color.CGColor;
}

@end


@implementation StarRateLayer

#define DefaultStarNormalColor [UIColor lightGrayColor]
#define DefaultStarFillColor   [UIColor orangeColor]

#define DefaultStarSize 30.0
#define DefaultPadding  1.0
#define DefaultStarCount 5
#define MinimumRating   0.0
#define MaximumRating   5.0

#pragma mark
#pragma mark<View Initializers>
#pragma mark


- (instancetype)initWithStarSize:(CGFloat)starSize starCount:(NSUInteger)starCount
                       starCurve:(BOOL)starCurve starColor:(UIColor*)starColor
                      superView:(UIView *)superView
{
    self = [super init];
    if (self)
    {
        [self selfInitWithStarSize:starSize starCount:starCount starCurve:starCurve
                         starColor:starColor uperView: superView];
    }
    return self;
}

- (void)selfInitWithStarSize:(CGFloat)starSize starCount:(NSUInteger)starCount
                 starCurve:(BOOL)starCurve starColor:(UIColor*)starColor uperView:(UIView *)superView
{
    if (_stars)
        return;
    
    self.backgroundColor = [UIColor clearColor].CGColor;
    
    _starCount = starCount;
    _starCurve = starCurve;
    
    _starSize  = starSize;
    _padding   = DefaultPadding;
    _superView = superView;       //在创建星星前要赋值，这样初始化后， StarRateView .size才会有值
    
    self.stars     = [NSMutableArray arrayWithCapacity:_starCount];
    self.starColor = starColor;  //创建星星
}

- (void)dealloc
{
    self.superView = nil;  //非ARC时，要清除
    
    [self.stars makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.stars removeAllObjects];
    
    self.starColor = nil;
    self.stars     = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)updateSuperViewSize
{
    if (_superView && _superView.frame.size.width != self.frame.size.width)
    {
        CGRect rect = _superView.frame;
        rect.size = self.frame.size;
        _superView.frame = rect;
    }
}

-(void)updateRateView
{
    // Update frame for self to accommodate desired width for _starCount stars
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [self calcViewWidth], _starSize);
    [self updateSuperViewSize];
    
    // Check if stars have been added to self previously or not
    if([self.stars count] == 0)
    {
        // If not, add _starCount stars to self with desired frames
        for (int i = 1 ; i <= _starCount; i++)
        {
            CGRect rect = CGRectMake([self calcStarLeftWithIndex:i], 0, _starSize, _starSize);
            StarLayer* star = [StarLayer starWithColor:_starColor
                                                 frame:rect
                                             lineWidth:[self calcStarLineWidth]
                                             starCurve:self.starCurve];
            star.masksToBounds = YES;
            [self addSublayer:star];
            [self.stars addObject:star];
        }
    }
}

//计算 星星 边框线
- (CGFloat)calcStarLineWidth
{
    return _starCurve ? ceil(_starSize / 7.0) : 0;
}

//计算 某个星星的 x
- (CGFloat)calcStarLeftWithIndex:(NSUInteger)index
{
    return index<= 0 ? 0 : (index - 1) * (_starSize +_padding);
}

#pragma mark
#pragma mark<Property Setters>
#pragma mark


- (void) setStarCount:(NSUInteger)numberOfStars
{
    if (numberOfStars <= 0 || _starCount == numberOfStars) {
        return;
    }
    
    _starCount = numberOfStars;
    [self buildStars];
}

- (void)buildStars
{
    [self.stars makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.stars removeAllObjects];
    [self updateRateView];
}

-(void)setStarColor:(UIColor*)starColor
{
    _starColor = starColor;
    if (!starColor)
        return;
    [self updateRateView];
    
    // Update Stars appearance for color
    for(NSInteger i = 1 ; i <= self.stars.count; i++)
    {
        StarLayer* star = (StarLayer*)self.stars[i - 1];
        [star updateWithColor: starColor];
    }
}

- (void)setStarCurve:(BOOL)starCurve
{
    if (_starCurve == starCurve)
    {
        return;
    }
    [self updateRateView];
    _starCurve = starCurve;
    [self updateStarsSize];
}

-(void)setStarSize:(CGFloat)starSize
{
    if (starSize <= 0 || _starSize == starSize)
    {
        return;
    }
    
    _starSize = starSize;
    [self updateStarsSize];
}

- (void)updateStarsSize
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [self calcViewWidth], _starSize);
    [self updateSuperViewSize];
    
    // Update Stars appearance for size
    for(NSInteger i = 1 ; i <= self.stars.count; i++)
    {
        StarLayer* star = (StarLayer*)self.stars[i - 1];
        star.frame = CGRectMake([self calcStarLeftWithIndex:i], 0, _starSize, _starSize);
        [star setStarCurve:_starCurve lineWidth:[self calcStarLineWidth]];
    }
}

- (CGFloat)calcViewWidth
{
    return _starCount * _starSize + (_starCount - 1) * _padding;
}

-(void)setPadding:(CGFloat)padding {
    
    if (padding >= 0.0) {
        _padding = padding;
        [self updateRateView];
        [self updateStarsSize];
    }
}

@end

@implementation StarRateView

+ (instancetype)rateViewWithRating:(CGFloat)rating starCurve:(BOOL)starCurve
{
    StarRateView *rateView = [[self alloc] initWithRating:rating starSize:DefaultStarSize starCurve:starCurve];
#if ! __has_feature(objc_arc)
    [rateView autorelease];
#endif
    return rateView;
}

+ (instancetype)initWithRating:(CGFloat)rating andStarCount:(NSUInteger) count starCurve:(BOOL)starCurve
{
    StarRateView *rateView = [[self alloc] initWithRating:rating andStarCount:count starCurve:starCurve];
#if ! __has_feature(objc_arc)
    [rateView autorelease];
#endif
    return rateView;
}

+ (instancetype)rateViewWithRating:(CGFloat)rating starSize:(CGFloat)starSize starCurve:(BOOL)starCurve
{
    StarRateView *rateView = [[self alloc] initWithRating:rating starSize:starSize starCurve:starCurve];
#if ! __has_feature(objc_arc)
    [rateView autorelease];
#endif
    return rateView;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self selfInitWithRating:0 starSize:DefaultStarSize starCount:DefaultStarCount starCurve:NO];
    }
    return self;
}

- (instancetype)initWithRating:(CGFloat)rating starSize:(CGFloat)starSize starCurve:(BOOL)starCurve
{
    self = [super init];
    if (self)
    {
        [self selfInitWithRating:rating starSize:starSize starCount:DefaultStarCount starCurve:starCurve];
    }
    return self;
}

- (instancetype)initWithRating:(CGFloat)rating andStarCount:(NSUInteger) count starCurve:(BOOL)starCurve
{
    self = [super init];
    if (self)
    {
        [self selfInitWithRating:rating starSize:DefaultStarSize starCount:count starCurve:starCurve];
    }
    return self;
}


- (instancetype)initWithRating:(CGFloat)rating andFrame:(CGRect)newFrame starCurve:(BOOL)starCurve
{
    if(self = [super initWithFrame:newFrame])
    {
        [self selfInitWithRating:rating starSize:DefaultStarSize starCount:DefaultStarCount starCurve:starCurve];
    }
    return self;
}

- (void)selfInitWithRating:(CGFloat)rating starSize:(CGFloat)starSize starCount:(NSUInteger)starCount
                 starCurve:(BOOL)starCurve
{
    if (_starRateNormalLayer)
        return;
    
    self.backgroundColor = [UIColor clearColor];
    
    // Check Rating Max / Min
    if(_rating > MaximumRating)
    {
        _rating = MaximumRating;
    }
    else
    if(_rating < MinimumRating)
    {
        _rating = MinimumRating;
    }
    
    
    //_step          = 0.0;
    //_canRate       = NO;
    _starRateNormalLayer = [[StarRateLayer alloc] initWithStarSize:starSize starCount:starCount starCurve:starCurve
                                                         starColor:DefaultStarNormalColor superView:self];
    
    _starRateFillLayer   = [[StarRateLayer alloc] initWithStarSize:starSize starCount:starCount starCurve:starCurve
                                                         starColor:DefaultStarFillColor superView:nil];
    _starRateFillLayer.position      = CGPointZero;
    _starRateFillLayer.anchorPoint   = CGPointZero;
    _starRateFillLayer.masksToBounds = YES;

    [self.layer addSublayer:_starRateNormalLayer];
    [_starRateNormalLayer addSublayer:_starRateFillLayer];
    

    //Call setRating: so that view's UI gets updated
    self.rating = rating;
}

- (void)dealloc
{
    self.starRateNormalLayer = nil;
    self.starRateFillLayer   = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)setRating:(CGFloat)rating
{
    [self setRating:rating animation:NO];
}

#define StarAnimationName @"StarAnimation"

- (void)setRating:(CGFloat)rating animation:(BOOL)animation
{
    if (_isInteger) {
        rating = floor(rating) + 1;
    }
    if (rating < 0){
        rating = 0;
    }
    else
    if (rating > self.starCount) {
        rating = self.starCount;
    }
    
    BOOL changed = _rating != rating;
    _rating = rating;
    
    CGRect toRect   = _starRateFillLayer.frame;
    toRect.size.width   = [self calcWidthWithRating:_rating];
//    if (animation)
//    {
//        CALayer 改变 frame bounds 等默认已经开启动画
//        CABasicAnimation *frameAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
//        
//        frameAnimation.fromValue = [NSNumber numberWithFloat:_starRateFillLayer.bounds.size.width];
//        frameAnimation.toValue   = [NSNumber numberWithFloat:toRect.size.width];
//        
//        frameAnimation.beginTime = 0;
//        frameAnimation.duration  = 1.2;
//        frameAnimation.delegate  = self;
//        
//        [_starRateFillLayer addAnimation:frameAnimation forKey:nil];

//    }
//    else
//    {
//        _starRateFillLayer.frame = toRect;
//    }
    
    [CATransaction begin];
    
    //显式事务默认开启动画效果,kCFBooleanTrue关闭
    [CATransaction setValue: animation ? (id)kCFBooleanFalse : (id)kCFBooleanTrue
                     forKey: kCATransactionDisableActions];
    
    //动画执行时间
    //        [CATransaction setValue:[NSNumber numberWithFloat:0.2f] forKey:kCATransactionAnimationDuration];
    [CATransaction setAnimationDuration:0.25];
    
    _starRateFillLayer.frame = toRect;
    
    [CATransaction commit];
    
    // Notify the delegate object about rating change
    if(changed && [_delegate respondsToSelector:@selector(starRateView:didUpdateRating:)])
        [_delegate starRateView:self didUpdateRating:_rating];
}

//计算比率显示宽度
- (CGFloat)calcWidthWithRating:(CGFloat)rating
{
    NSUInteger index = ceilf(rating);
    if (rating == index)
{
        index ++;
}
    CGFloat rate = rating - floorf(rating);
    CGFloat width = [_starRateNormalLayer calcStarLeftWithIndex:index] + rate * _starRateNormalLayer.starSize;
    return width;
}

- (void) setStep:(CGFloat)step
{
    if (step < 0.0f) {
        _step = 0.0f;
    }
    else if (step > 1.0f) {
        _step = 1.0f;
    }
    else {
        _step = step;
    }
}

-(void)setFrame:(CGRect)frame
{
    // Check if frame asked to set is more
    if(_starRateNormalLayer && (frame.size.width != [_starRateNormalLayer calcViewWidth] || frame.size.height != _starRateNormalLayer.starSize))
    {
        frame.size.width = [_starRateNormalLayer calcViewWidth];
        frame.size.height = _starRateNormalLayer.starSize;
    }
    
    [super setFrame:frame];
}

- (NSUInteger)starCount
{
    return _starRateNormalLayer.starCount;
}
    
- (void)setStarCount:(NSUInteger)starCount
    {
    [_starRateNormalLayer setStarCount:starCount];
    [_starRateFillLayer setStarCount:starCount];
    [self setRating:self.rating animation:NO];
    }

- (UIColor *)starNormalColor
{
    return _starRateNormalLayer.starColor;
}

-(void)setStarNormalColor:(UIColor*)starNormalColor
{
    [_starRateNormalLayer setStarColor:starNormalColor];
}

- (UIColor *)starFillColor
    {
    return _starRateFillLayer.starColor;
}

-(void)setStarFillColor:(UIColor*)starFillColor
{
    [_starRateFillLayer setStarColor:starFillColor];
    }
    
- (CGFloat)starSize
{
    return _starRateNormalLayer.starSize;
}

- (void)setStarSize:(CGFloat)starSize
{
    [_starRateNormalLayer setStarSize:starSize];
    [_starRateFillLayer setStarSize:starSize];
    [self setRating:self.rating animation:NO];
}

- (CGFloat)padding
{
    return [_starRateNormalLayer padding];
}

- (void)setPadding:(CGFloat)padding
{
    [_starRateNormalLayer setPadding:padding];
    [_starRateFillLayer setPadding:padding];
    [self setRating:self.rating animation:NO];
}

- (BOOL)starCurve
    {
    return _starRateNormalLayer.starCurve;
    }
    
- (void)setStarCurve:(BOOL)starCurve
{
    [_starRateNormalLayer setStarCurve:starCurve];
    [_starRateFillLayer setStarCurve:starCurve];
    [self setRating:self.rating animation:NO];
}

#pragma mark
#pragma mark <UIResponder Methods>
#pragma mark

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self handleTouches:touches];
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self handleTouches:touches];
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self handleTouches:touches];
}

-(void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self handleTouches:touches];
}

-(void)handleTouches:(NSSet*)touches
{
    if(_canRate)
    {
        CGPoint location = [[touches anyObject] locationInView:self];
//        RVLog(@"%@", NSStringFromCGPoint(location));
        // Compute location
        float x = location.x;
        if(x < 0.0f)
            x = 0.0f;
        else if(x > self.frame.size.width)
            x = self.frame.size.width - (self.starCount - 1) * self.padding;
        else if (self.step) {
            //            float div = (self.frame.size.width * self.step) / _starCount;
            //            x = (x / div) + self.step;
            //            x = div * (int)x;
            float div = (self.frame.size.width - (self.starCount - 1) * self.padding) * (self.step / self.starCount);
            float p = (int)(x / (self.starSize + self.padding));
            float q = x - p * (self.starSize + self.padding);
            if (q > self.starSize) {
                x = p * self.starSize + self.starSize;
            } else {
                x = p * self.starSize + q;
            }
            x = (x / div) + self.step;
            x = div * (int)x;
        }
        //self.rating = x / _starSize;
        [self setRating:x / (self.starSize + self.padding) animation:YES];
    }
}

#pragma mark
#pragma mark <Auto Layout Helpers>
#pragma mark

- (CGSize)intrinsicContentSize {
    return CGSizeMake([_starRateNormalLayer calcViewWidth], self.starSize);
}

@end
