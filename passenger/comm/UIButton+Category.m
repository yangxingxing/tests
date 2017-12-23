//
//  UIButton+Category.m
//  wBaiJu
//
//  Created by 邱家楗 on 16/3/19.
//  Copyright © 2016年 邱家楗. All rights reserved.
//

#import "UIButton+Category.h"
#import "WBJUIFont.h"

@implementation UIButton (Category)

- (void)createIndicatorWithColor:(UIColor *)color width:(float)width withlineWidth:(CGFloat)lineWidth{
    
    //画箭头
    CGMutablePathRef linePath = CGPathCreateMutable();
    CAShapeLayer * lineShape = [CAShapeLayer layer];
    lineShape.lineWidth = lineWidth;
    lineShape.lineCap = kCALineCapRound;
    
    lineShape.strokeColor = [color CGColor];
    CGPathMoveToPoint(linePath, NULL, 0, 0);
    CGPathAddLineToPoint(linePath, NULL, width, width);
    //    CGPathAddLineToPoint(linePath, NULL, 8, 0);
    CGPathMoveToPoint(linePath, NULL, width, width);
    CGPathAddLineToPoint(linePath, NULL, width*2, 0);
    lineShape.path = linePath;
    CGPathRelease(linePath);
    //    [self.layer addSublayer:lineShape];
    CGPathRef bound = CGPathCreateCopyByStrokingPath(lineShape.path, nil, lineShape.lineWidth, kCGLineCapButt, kCGLineJoinMiter, lineShape.miterLimit);
    lineShape.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    lineShape.position = CGPointMake(self.layer.bounds.size.width/2, self.layer.bounds.size.height/2);
    [self.layer addSublayer:lineShape];
    //    return layer;
//    return lineShape;
}

- (void)setBigButtonWithTitle:(NSString *)title
                        color:(UIColor *)color
                       target:(id)target
                       action:(SEL)action
{
    CGFloat sr = [WBJUIFont screenRate];
    self.frame = CGRectMake(9 * sr, 26 * sr, SCREENW - 18 * sr, [WBJUIFont buttonHeight]);
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.backgroundColor    = color;
    self.layer.cornerRadius = 3.0 * sr;
    self.titleLabel.font    = [WBJUIFont tableViewFont];
}
@end
