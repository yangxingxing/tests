//
//  UIBezierPath+Shapes.m
//  不规则UIView UIBezierPath
//
//  Created by qiujj on 2014-09-05.
//  Copyright (c) 2014 qiujj. All rights reserved.
//

#import "UIBezierPath+Shapes.h"

@implementation UIBezierPath (Shapes)

+ (CGRect)maximumSquareFrameThatFits:(CGRect)frame;
{
    CGFloat a = MIN(frame.size.width, frame.size.height);
    return CGRectMake(frame.size.width/2 - a/2, frame.size.height/2 - a/2, a, a);
}

+ (instancetype)userShape:(CGRect)originalFrame
{
    CGRect frame = [self maximumSquareFrameThatFits:originalFrame];
    
    UIBezierPath* bezierPath = [self bezierPath];
	[bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.59723 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.53216 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.63225 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.46466 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.61268 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.51696 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.61807 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47851 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.68031 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.39072 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.65233 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.44503 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.67410 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.42087 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.67176 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33167 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.68857 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35062 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.67176 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34552 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.66244 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.22404 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.67176 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.30267 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.67152 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.25499 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.64114 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15016 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.66195 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.18321 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.65526 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.16545 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.57835 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.12980 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.62793 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.13586 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.59533 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.13924 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50277 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.10892 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.55205 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.11518 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.53038 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.10965 * CGRectGetHeight(frame))];
	[bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50277 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.10878 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50036 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.10887 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.50197 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.10878 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.50116 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.10886 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49633 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.10878 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.49901 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.10885 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.49772 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.10878 * CGRectGetHeight(frame))];
	[bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49639 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.10902 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.33297 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.22218 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.42912 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.11156 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.35757 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15397 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.32734 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33167 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.32385 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.24746 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.32734 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.30267 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.31879 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.39072 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.32734 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34552 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.31053 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35062 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.36685 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.46466 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.32500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.42087 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.34677 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.44503 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.40188 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.53216 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.38103 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47851 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.38642 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.51696 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.40552 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56864 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40525 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55453 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.40565 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.54816 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.39466 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.59685 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40548 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.57555 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.40570 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.58629 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.28634 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65952 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.37374 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.61687 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.32572 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.64261 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.13051 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.71866 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.23439 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.68183 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.14996 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.70863 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.05796 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.77326 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.11105 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.72870 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.05796 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.75592 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.05796 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.87769 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.05796 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.79061 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.05796 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.87769 * CGRectGetHeight(frame))];
	[bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49475 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.87769 * CGRectGetHeight(frame))];
	[bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50470 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.87769 * CGRectGetHeight(frame))];
	[bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.94992 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.87769 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.94992 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.78465 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.94992 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.87769 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.94992 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.80199 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.86894 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.73004 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.94992 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.76730 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.88839 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.74008 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.71311 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66711 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.84948 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.72001 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.76505 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.68941 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.60650 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.59849 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.67477 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65065 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.62824 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.61915 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.59391 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56652 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.59918 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.59153 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.59399 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.58424 * CGRectGetHeight(frame))];
	[bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.59757 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.53216 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.59383 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.54590 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.59430 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55378 * CGRectGetHeight(frame))];
	[bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    return bezierPath;
}


+ (instancetype)martiniShape:(CGRect)originalFrame
{
    CGRect frame = [self maximumSquareFrameThatFits:originalFrame];
    
    UIBezierPath* bezierPath = [self bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.33980 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.99174 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.35471 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.98285 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.34475 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.98872 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.34935 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.98462 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.46691 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.94635 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.39206 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.97052 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.42994 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.95972 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50127 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.89428 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.50294 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.93333 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.50324 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.93221 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.47934 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48717 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.49420 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.75856 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.48655 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62288 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.45734 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.44393 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.47838 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.46920 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.47255 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.45603 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.16428 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.20750 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.35906 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36587 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.26184 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.28648 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.15320 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.19354 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.16040 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.20436 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.15664 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.20107 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.29889 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.19354 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.20176 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.19354 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.25033 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.19354 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.30104 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.18650 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.29961 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.19119 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.30032 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.18885 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.28597 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.17821 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.29604 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.18361 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.29131 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.17917 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.26643 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.17965 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.27974 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.17710 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.27297 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.17908 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.18842 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.09291 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.21686 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.18396 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.17498 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.13771 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.20113 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.06899 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.19098 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.08438 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.19543 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.07577 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.20197 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.03639 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.21061 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05770 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.21021 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04776 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.20014 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.01653 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.19775 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.03056 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.19238 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.02389 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.20622 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.01653 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.20217 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.01653 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.20419 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.01653 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.26086 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04176 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.21808 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.03887 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.23599 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04483 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.32572 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.07827 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.28981 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.03818 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.31259 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05373 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.32127 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15045 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.33827 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.10174 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.33652 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.12710 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.31470 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.17645 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.31626 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15812 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.30828 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.16529 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.34288 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.19198 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.32111 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.18760 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.32943 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.19194 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.85274 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.19471 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.51283 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.19249 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.68279 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.19369 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.87303 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.19471 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.85817 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.19474 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.86360 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.19471 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.85907 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.20696 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.86625 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.20068 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.86277 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.20395 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.55737 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.45244 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.75854 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.28883 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.65802 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37072 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54495 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47493 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.54995 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.45846 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.54548 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.46444 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.53465 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.64813 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.54201 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.53269 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.53739 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.59036 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.52367 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.90977 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.53051 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.73532 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.52772 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.82257 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54174 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.93805 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.52297 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.92467 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.52709 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.93346 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.62181 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.96534 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.56864 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.94648 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.59556 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.95510 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.67679 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.99174 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.64069 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.97271 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.65850 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.98284 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.33980 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.99174 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.56446 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.99174 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.45213 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.99174 * CGRectGetHeight(frame))];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    return bezierPath;
}

+ (instancetype)beakerShape:(CGRect)originalFrame
{
    CGRect frame = [self maximumSquareFrameThatFits:originalFrame];
    
    UIBezierPath* bezierPath = [self bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.89190 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.77619 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.88494 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.77738 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.88969 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.77689 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.88738 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.77738 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.76291 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.77738 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.73976 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.75427 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.75012 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.77738 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.73976 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.76703 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.76291 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.73115 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.73976 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.74150 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.75012 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.73115 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.86154 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.73115 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.80844 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.64991 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.80078 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65130 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.80603 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65076 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.80347 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65130 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.67874 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65130 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.65560 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62819 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.66596 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65130 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.65560 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.64096 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.67874 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.60507 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.65560 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.61542 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.66596 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.60507 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.77914 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.60507 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.72683 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.52505 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.72503 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.52522 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.72623 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.52510 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.72565 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.52522 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.60300 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.52522 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.57985 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.50211 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.59021 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.52522 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.57985 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.51488 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.60300 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47900 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.57985 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48934 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.59021 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47900 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.69674 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47900 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.63128 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37884 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.63071 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35425 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54619 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35425 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.52304 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33114 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.53340 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35425 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.52304 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34391 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54619 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.30803 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.52304 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.31837 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.53340 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.30803 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.62963 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.30803 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.62696 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.19259 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54619 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.19259 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.52304 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.16947 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.53340 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.19259 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.52304 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.18224 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54619 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.14636 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.52304 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15671 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.53340 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.14636 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.62595 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.14636 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.67084 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.01163 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.62461 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.09553 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.62442 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05885 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.33609 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.01179 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.38337 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.17174 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.39107 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.06571 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.38277 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.10648 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.38526 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37784 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.11743 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.77851 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.20277 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.98578 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.05262 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.88643 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.09646 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.99201 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.81752 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.98640 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.89190 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.77619 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.92945 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.98593 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.97211 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.88501 * CGRectGetHeight(frame))];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    return bezierPath;
}

//
+ (instancetype)starShape:(CGRect)originalFrame
{
    CGRect frame = [self maximumSquareFrameThatFits:originalFrame];
    
    UIBezierPath* bezierPath = [self bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame),
                                         CGRectGetMinY(frame) + 0.05000 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.67634 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.30729 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.97553 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.39549 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.78532 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.64271 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.79389 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.95451 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.85000 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.20611 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.95451 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.21468 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.64271 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.02447 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.39549 * CGRectGetHeight(frame))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.32366 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.30729 * CGRectGetHeight(frame))];
    [bezierPath closePath];
    
    return bezierPath;
}

/*
+ (instancetype)beakerShape:(CGRect)originalFrame Left:(BOOL)left
{
    CGRect rect = originalFrame;
    rect.origin = CGPointZero;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
    CGFloat radius     = 4;
    CGFloat marginLeft = left ? 6 : 0;//留出上下左右的边距
    CGFloat marginRight= left ? 0 : 6;
    CGFloat marginTop  = 1;   //marginTop 如果为0, height 比较大时,上面线会比较粗
    CGFloat marginBottom = 0;
    
    CGFloat triangleSize = 10;//等边三角形的边长
    CGFloat triangleMarginTop = 6;//等边三角形距离圆角的距离
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    // 移动到初始点  左上角
    [bezierPath moveToPoint:CGPointMake(radius + marginLeft, marginTop)]; //margin

    // 绘制第1条线和第1个1/4圆弧  右上角
    [bezierPath addLineToPoint:CGPointMake(width - radius - marginRight, marginTop)];  //margin
    [bezierPath addArcWithCenter:CGPointMake(width - radius - marginRight, radius + marginTop) //margin
                          radius:radius
                      startAngle:-0.5 * M_PI
                        endAngle:0.0
                       clockwise:YES];
    //CGContextAddArc(context, width - radius-margin, radius+margin, radius, -0.5 * M_PI, 0.0, 0);
    //[bezierPath addLineToPoint:CGPointMake(width, marginTop + radius)];  //margin
    //[bezierPath addLineToPoint:CGPointMake(width, 0)];
    //[bezierPath addLineToPoint:CGPointMake(radius + marginLeft, 0)];
    // 闭合路径
    //CGContextClosePath(context);
    //[bezierPath closePath];
    // 绘制第2条线和第2个1/4圆弧
    //[bezierPath moveToPoint:CGPointMake(width - marginRight, marginTop + radius)];  //margin
    
    [bezierPath addLineToPoint:CGPointMake(width - marginRight, marginTop + radius)]; //margin
    //[bezierPath addLineToPoint:CGPointMake(width,          height - radius)];  //-margin
    
    if (!left) {
        //绘制右边三角形
        [bezierPath addLineToPoint:CGPointMake(width - marginRight, marginTop + radius + triangleMarginTop)];
        [bezierPath addLineToPoint:CGPointMake(width , marginTop + radius + triangleMarginTop + triangleSize * 0.5)];
        [bezierPath addLineToPoint:CGPointMake(width - marginRight, marginTop + radius+triangleMarginTop + triangleSize)];
    }
    [bezierPath addLineToPoint:CGPointMake(width - marginRight, height - radius)];  //-margin

    //右下角
    //[bezierPath moveToPoint:CGPointMake(width - marginRight, height - radius)];    // - margin
    [bezierPath addArcWithCenter:CGPointMake(width - radius - marginRight, height - radius)  // - margin   - margin
                          radius:radius
                      startAngle:0.0
                        endAngle:0.5 * M_PI
                       clockwise:YES];
    //CGContextAddArc(context, width - radius - margin, height - radius - margin, radius, 0.0, 0.5 * M_PI, 0);
    [bezierPath addLineToPoint:CGPointMake(width - marginRight - radius, height)];
    //[bezierPath addLineToPoint:CGPointMake(width, height)];
    //[bezierPath addLineToPoint:CGPointMake(width, height - radius)];      // - margin
    
    
    //左下角
    // 绘制第3条线和第3个1/4圆弧
    //[bezierPath moveToPoint:CGPointMake(width - marginRight - radius, height - marginTop)];
    //[bezierPath addLineToPoint:CGPointMake(width - marginRight - radius, height)];
    //[bezierPath addLineToPoint:CGPointMake(marginLeft, height)];
    [bezierPath addLineToPoint:CGPointMake(marginLeft + radius, height - marginBottom)];
    
    
    //[bezierPath moveToPoint:CGPointMake(marginLeft, height)];                     // - margin
    [bezierPath addArcWithCenter:CGPointMake(radius + marginLeft, height - marginBottom - radius)  // - margin
                          radius:radius
                      startAngle:0.5 * M_PI
                        endAngle:M_PI
                       clockwise:YES];
    //CGContextAddArc(context, radius+margin, height - radius - margin, radius, 0.5 * M_PI, M_PI, 0);
    [bezierPath addLineToPoint:CGPointMake(marginLeft, height - marginBottom - radius)];  // - margin
    //[bezierPath addLineToPoint:CGPointMake(0, height)];
    //[bezierPath addLineToPoint:CGPointMake(marginLeft, height)];
    
    
    // 绘制第4条线和第4个1/4圆弧
    //[bezierPath moveToPoint:CGPointMake(marginLeft, height - radius)];         // - margin
    //[bezierPath addLineToPoint:CGPointMake(0,       height - radius)];         //- margin
    //[bezierPath addLineToPoint:CGPointMake(0,       radius + marginTop)];
    
    //[bezierPath addLineToPoint:CGPointMake(marginLeft, radius + marginTop)];
    
    if (left) {
        //绘制左边三角形
        [bezierPath addLineToPoint:CGPointMake(marginLeft,  marginTop + radius + triangleMarginTop + triangleSize)];
        [bezierPath addLineToPoint:CGPointMake(0 ,          marginTop + radius + triangleMarginTop + triangleSize * 0.5)];
        [bezierPath addLineToPoint:CGPointMake(marginLeft , marginTop + radius + triangleMarginTop)];
    }
    //[bezierPath moveToPoint:CGPointMake(marginLeft, radius + marginTop)];
    [bezierPath addArcWithCenter:CGPointMake(radius + marginLeft, marginTop + radius)
                          radius:radius
                      startAngle:M_PI
                        endAngle:1.5 * M_PI
                       clockwise:YES];
    //CGContextAddArc(context, radius + margin, margin + radius, radius, M_PI, 1.5 * M_PI, 0);
    //[bezierPath addLineToPoint:CGPointMake(marginLeft, radius + marginTop)];
    //[bezierPath addLineToPoint:CGPointMake(marginLeft, radius + marginTop + 1)];
    //[bezierPath addLineToPoint:CGPointMake(0, 0)];
    //[bezierPath addLineToPoint:CGPointMake(0, radius + marginTop)];
    
    [bezierPath closePath];
    
    //
    return bezierPath;
}
*/

+ (instancetype)beakerShape:(CGRect)originalFrame
               ShapesBeaker:(ShapesBeaker)shapesBeaker
                     Offset:(CGFloat)offset
                BorderWidth:(CGFloat)borderWidth
{
    return [self beakerShape:originalFrame
                ShapesBeaker:shapesBeaker
                      Offset:offset
                 BorderWidth:borderWidth
                      Radius:4
                TriangleSize:10];
}

+ (instancetype)beakerShape:(CGRect)originalFrame
               ShapesBeaker:(ShapesBeaker)shapesBeaker
                     Offset:(CGFloat)offset
                BorderWidth:(CGFloat)borderWidth
                     Radius:(CGFloat)radius
               TriangleSize:(CGFloat)triangleSize
{
    CGRect rect = originalFrame;
    rect.origin = CGPointZero;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
    //CGFloat radius       = radiusRect ? 4 : 0; //4
    CGFloat marginLeft   = shapesBeaker == sbLeft   ? 6 : borderWidth * 0.5;   //留出上下左右的边距
    CGFloat marginRight  = shapesBeaker == sbRight  ? 6 : borderWidth * 0.5;
    CGFloat marginTop    = shapesBeaker == sbTop    ? 6 : borderWidth * 0.5;   //
    CGFloat marginBottom = shapesBeaker == sbBottom ? 6 : borderWidth * 0.5;
    
    //CGFloat triangleSize = 10;//等边三角形的边长
    
    UIBezierPath* bezierPath = [self bezierPath];
    // 移动到初始点  左上角
    [bezierPath moveToPoint:CGPointMake(radius + marginLeft, marginTop)]; //margin
    
    //绘制上边三角形
    if (shapesBeaker == sbTop) {
        [bezierPath addLineToPoint:CGPointMake(offset, marginTop)];
        [bezierPath addLineToPoint:CGPointMake(offset + (triangleSize * 0.5), 0)];
        [bezierPath addLineToPoint:CGPointMake(offset + triangleSize,         marginTop)];
    }
    
    // 绘制第1条线和第1个1/4圆弧  右上角
    [bezierPath addLineToPoint:CGPointMake(width - radius - marginRight, marginTop)];  //margin
    [bezierPath addArcWithCenter:CGPointMake(width - radius - marginRight, radius + marginTop) //margin
                          radius:radius
                      startAngle:-0.5 * M_PI
                        endAngle:0.0
                       clockwise:YES];

    
    [bezierPath addLineToPoint:CGPointMake(width - marginRight, marginTop + radius)];   //margin
    
    //绘制右边三角形
    if (shapesBeaker == sbRight) {
        [bezierPath addLineToPoint:CGPointMake(width - marginRight, offset + marginTop)];
        [bezierPath addLineToPoint:CGPointMake(width ,              offset + marginTop + triangleSize * 0.5)];
        [bezierPath addLineToPoint:CGPointMake(width - marginRight, offset + marginTop + triangleSize)];
    }
    [bezierPath addLineToPoint:CGPointMake(width - marginRight, height - radius - marginBottom)];  //-margin
    
    //右下角
    [bezierPath addArcWithCenter:CGPointMake(width - radius - marginRight, height - radius - marginBottom)  // - margin   - margin
                          radius:radius
                      startAngle:0.0
                        endAngle:0.5 * M_PI
                       clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(width - marginRight - radius, height - marginBottom)];
    
    //绘制下边三角形
    if (shapesBeaker == sbBottom) {
        [bezierPath addLineToPoint:CGPointMake(offset + triangleSize,       height - marginBottom)];
        [bezierPath addLineToPoint:CGPointMake(offset + triangleSize * 0.5, height)];
        [bezierPath addLineToPoint:CGPointMake(offset,                      height - marginBottom)];
    }
    
    //左下角
    [bezierPath addLineToPoint:CGPointMake(marginLeft + radius, height - marginBottom)];
    [bezierPath addArcWithCenter:CGPointMake(radius + marginLeft, height - marginBottom - radius)  // - margin
                          radius:radius
                      startAngle:0.5 * M_PI
                        endAngle:M_PI
                       clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(marginLeft, height - marginBottom - radius)];  // - margin

    
    //绘制左边三角形
    if (shapesBeaker == sbLeft) {
        [bezierPath addLineToPoint:CGPointMake(marginLeft,  offset + marginTop + triangleSize)];
        [bezierPath addLineToPoint:CGPointMake(0 ,          offset + marginTop + triangleSize * 0.5)];
        [bezierPath addLineToPoint:CGPointMake(marginLeft , offset + marginTop)];
    }

    [bezierPath addArcWithCenter:CGPointMake(radius + marginLeft, marginTop + radius)
                          radius:radius
                      startAngle:M_PI
                        endAngle:1.5 * M_PI
                       clockwise:YES];
    
    [bezierPath closePath];
    
    //
    return bezierPath;
}

+ (instancetype)stars:(NSUInteger)numberOfStars shapeInFrame:(CGRect)originalFrame
{
    // divide the original frame into equally sized frames
    CGFloat w = originalFrame.size.width/numberOfStars;
    CGRect babyFrame = CGRectMake(0, 0, w, originalFrame.size.height);
    UIBezierPath* bezierPath = [self bezierPath];
    
    for (int i=0; i < numberOfStars; i++) {
        // get the star shape
        UIBezierPath* startPath = [UIBezierPath starShape:babyFrame];
        // move it to the desired location
        [startPath applyTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, i*w, 0)];
        // add the path
        [bezierPath appendPath:startPath];
    }
    
    return bezierPath;
}

//直线 五角星
+ (instancetype)starPathWithWidth:(CGFloat)width borderWidth:(CGFloat)borderWidth
{
    borderWidth *= 0.5;
    CGFloat arm = width;
    UIBezierPath *starPath = [self bezierPath];
    [starPath moveToPoint:   CGPointMake(arm*0.00 + borderWidth, arm*0.35 + borderWidth)];
    [starPath addLineToPoint:CGPointMake(arm*0.35 + borderWidth, arm*0.35 + borderWidth)];
    [starPath addLineToPoint:CGPointMake(arm*0.50 + borderWidth, arm*0.00 + borderWidth)];
    [starPath addLineToPoint:CGPointMake(arm*0.65 + borderWidth, arm*0.35 + borderWidth)];
    [starPath addLineToPoint:CGPointMake(arm*1.00 + borderWidth, arm*0.35 + borderWidth)];
    [starPath addLineToPoint:CGPointMake(arm*0.75 + borderWidth, arm*0.60 + borderWidth)];
    [starPath addLineToPoint:CGPointMake(arm*0.85 + borderWidth, arm*1.00 + borderWidth)];
    [starPath addLineToPoint:CGPointMake(arm*0.50 + borderWidth, arm*0.75 + borderWidth)];
    [starPath addLineToPoint:CGPointMake(arm*0.15 + borderWidth, arm*1.00 + borderWidth)];
    [starPath addLineToPoint:CGPointMake(arm*0.25 + borderWidth, arm*0.60 + borderWidth)];
    [starPath addLineToPoint:CGPointMake(arm*0.00 + borderWidth, arm*0.35 + borderWidth)];
    return starPath;
}

//曲线五角星
+ (instancetype)starCurvePathWithWidth:(CGFloat)width borderWidth:(CGFloat)borderWidth
{
    borderWidth *= 0.5;
    CGFloat arm = width;
    UIBezierPath *starPath = [self bezierPath];
    
    [starPath moveToPoint:        CGPointMake(arm*0.00 + borderWidth, arm*0.35 + borderWidth)];
    
    [starPath addQuadCurveToPoint:CGPointMake(arm*0.50 + borderWidth, arm*0.00 + borderWidth)     //注 终点
                     controlPoint:CGPointMake(arm*0.40 + borderWidth, arm*0.35 + borderWidth)];  //注 控制点  中间点
    
    [starPath addQuadCurveToPoint:CGPointMake(arm*1.00 + borderWidth, arm*0.35 + borderWidth)
                     controlPoint:CGPointMake(arm*0.60 + borderWidth, arm*0.35 + borderWidth)];
    
    [starPath addQuadCurveToPoint:CGPointMake(arm*0.85 + borderWidth, arm*1.00 + borderWidth)
                     controlPoint:CGPointMake(arm*0.70 + borderWidth, arm*0.55 + borderWidth)];
    
    [starPath addQuadCurveToPoint:CGPointMake(arm*0.15 + borderWidth, arm*1.00 + borderWidth)
                     controlPoint:CGPointMake(arm*0.50 + borderWidth, arm*0.70 + borderWidth)];
    
    [starPath addQuadCurveToPoint:CGPointMake(arm*0.00 + borderWidth, arm*0.35 + borderWidth)
                     controlPoint:CGPointMake(arm*0.30 + borderWidth, arm*0.55 + borderWidth)];
    
    //    [starPath addLineToPoint:CGPointMake(arm*0.35 + borderWidth, arm*0.35 + borderWidth)];
    //    [starPath addLineToPoint:CGPointMake(arm*0.50 + borderWidth, arm*0.0 + borderWidth)];
    
    //    [starPath addLineToPoint:CGPointMake(arm*0.65 + borderWidth, arm*0.35 + borderWidth)];
    //    [starPath addLineToPoint:CGPointMake(arm*1.00 + borderWidth, arm*0.35 + borderWidth)];
    
    //    [starPath addLineToPoint:CGPointMake(arm*0.75 + borderWidth, arm*0.60 + borderWidth)];
    //    [starPath addLineToPoint:CGPointMake(arm*0.85 + borderWidth, arm*1.00 + borderWidth)];
    
    //    [starPath addLineToPoint:CGPointMake(arm*0.50 + borderWidth, arm*0.75 + borderWidth)];
    //    [starPath addLineToPoint:CGPointMake(arm*0.15 + borderWidth, arm*1.00 + borderWidth)];
    
    //    [starPath addLineToPoint:CGPointMake(arm*0.25 + borderWidth, arm*0.60 + borderWidth)];
    //    [starPath addLineToPoint:CGPointMake(arm*0.00 + borderWidth, arm*0.35 + borderWidth)];
    return starPath;
}

@end
