//
//  UILabelCustom.m
//  
//
//  Created by 邱家楗 on 15/12/21.
//  Copyright © 2015年 邱家楗. All rights reserved.
//

#import "UILabelCustom.h"

@implementation UILabelCustom

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
    _verticalAlignment = UILabelVerticalAlignmentCenter;
    _textEdgeInsets    = UIEdgeInsetsZero;
}

- (void)setVerticalAlignment:(UILabelVerticalAlignment)verticalAlignment
{
    if (_verticalAlignment != verticalAlignment)
    {
        _verticalAlignment = verticalAlignment;
        [self setNeedsDisplay];
    }
}

- (void)drawTextInRect:(CGRect)rect
{
    CGRect newRect = UIEdgeInsetsInsetRect(rect, _textEdgeInsets);
//    newRect.origin.x += _textEdgeInsets.left;
//    newRect.origin.y += _textEdgeInsets.top;
//    newRect.size.width -= _textEdgeInsets.left + _textEdgeInsets.right;
//    newRect.size.height -= _textEdgeInsets.top + _textEdgeInsets.bottom;
    
    if (((self.text && self.text.length > 0) || (self.attributedText && self.attributedText.length > 0)) &&
        _verticalAlignment > UILabelVerticalAlignmentCenter)
    {
        CGSize sz = [self sizeThatFits:newRect.size];
        if (_verticalAlignment > UILabelVerticalAlignmentCenter)
        {
            if (_verticalAlignment == UILabelVerticalAlignmentBottom)
            {
                newRect.origin.y = rect.size.height - sz.height - 1 - _textEdgeInsets.bottom;
                if (newRect.origin.y < _textEdgeInsets.top)
                    newRect.origin.y = _textEdgeInsets.top;
            }
            newRect.size.height = sz.height;
        }
    }

    [super drawTextInRect:newRect];
}

@end
