//
//  UIButtonCustom.m
//  navViewController
//
//  Created by 邱家楗 on 15/11/26.
//  Copyright © 2015年 邱家楗. All rights reserved.
//

#import "UIButtonCustom.h"

@interface UIButtonCustom()
{
    UIColor *_saveBackColor;
    CGFloat _saveAlpha;
    BOOL _sendActioning;
}

@end


@implementation UIButtonCustom

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self selfInit];
    }
    return self;
}

- (void)selfInit
{
    self.exclusiveTouch  = YES;
    _saveAlpha       = self.alpha;
    _imageViewFrame  = CGRectZero;
    _titleLabelFrame = CGRectZero;
    _enlargeEdge     = UIEdgeInsetsZero;
}

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_saveBackColor)
        [_saveBackColor release];
#endif
    _saveBackColor = nil;
    
    self.touchDownBackColor = nil;
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


-(BOOL)canChangeBackgroundColor
{
    return self.backgroundColor &&
      (self.backgroundColor != [UIColor clearColor] || (self.touchDownBackColor && self.touchDownBackColor != [UIColor clearColor])) &&
    ![self backgroundImageForState:UIControlStateNormal];
}

-(void)resetBackgroundColor
{
    if (_saveBackColor && [self canChangeBackgroundColor])
    {
        self.backgroundColor = _saveBackColor;
#if !__has_feature(objc_arc)
        if (_saveBackColor)
            [_saveBackColor release];
#endif
    }
    _saveBackColor = nil;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
#if !__has_feature(objc_arc)
    if (_saveBackColor)
        [_saveBackColor release];
#endif
    _saveBackColor = nil;
}

- (void)setAlpha:(CGFloat)alpha
{
    [super setAlpha:alpha];
    _saveAlpha = alpha;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    super.alpha = enabled ? _saveAlpha : _saveAlpha * 0.5;
}

- (void)setTouchDownBackColor
{
    [self resetBackgroundColor];
    _saveBackColor = nil;
    
    if (![self canChangeBackgroundColor])
        return;
    
    _saveBackColor = self.backgroundColor;
    if (_touchDownBackColor)
        self.backgroundColor = _touchDownBackColor;
    else
        if (_saveBackColor)
        {
#if !__has_feature(objc_arc)
            [_saveBackColor retain];
#endif
            CGFloat r, g, b, a;
            [_saveBackColor getRed:&r green:&g blue: &b alpha: &a];
            
            [super setBackgroundColor: [UIColor colorWithRed: r * 0.9 green: g * 0.9
                                                        blue: b * 0.9 alpha: a]];
        }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_sendActioning)
    {
        SLog(@"button sendActioning...");
        return;
    }
    [super touchesBegan:touches withEvent:event];
    [self setTouchDownBackColor];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self resetBackgroundColor];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];

    CGFloat dec = 50.0;
    if (point.x < -dec || point.y < -dec ||
        point.x - touch.view.bounds.size.width > dec ||
        point.y - touch.view.bounds.size.height > dec)
    {
        [self resetBackgroundColor];
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self resetBackgroundColor];
}


- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if (_sendActioning)
    {
        SLog(@"send Actioning2... ")
    }
    _sendActioning = YES;
    [super sendAction:action to:target forEvent:event];
    _sendActioning = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!CGRectEqualToRect(_imageViewFrame, CGRectZero))
    {
        self.imageView.frame = _imageViewFrame;
    }
    
    if (!CGRectEqualToRect(_titleLabelFrame, CGRectZero))
    {
        self.titleLabel.frame = _titleLabelFrame;
    }
}

- (CGRect)enlargedRect
{
    CGRect r = self.bounds;
    r.origin.x -= _enlargeEdge.left;
    r.origin.y -= _enlargeEdge.top;
    r.size.width += _enlargeEdge.left + _enlargeEdge.right;
    r.size.height += _enlargeEdge.top + _enlargeEdge.bottom;
    return r;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (UIEdgeInsetsEqualToEdgeInsets(_enlargeEdge, UIEdgeInsetsZero))
    {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect rect = [self enlargedRect];
    return CGRectContainsPoint(rect, point);
}


@end

