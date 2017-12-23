//
//  UIView+MaskWithPath.h
//  
//
//  Created by qiujj on 14-9-5.
//  Copyright (c) 2014年 qiujj. All rights reserved.
//

#import "UIBezierPath+Shapes.h"
#import "CALayerLine.h"

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface UIView(MaskWithPath)

- (CAShapeLayer *)setMaskWithPath:(UIBezierPath *)path withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

- (CAShapeLayer *)setMaskWithPath:(UIBezierPath *)path FillColor:(UIColor *)fillColor withBorderColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth;

//fillColor [UIColor clearColor]
- (CAShapeLayer *)setBorderWithPath:(UIBezierPath *)path withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth Name:(NSString*)layerName;

- (CAShapeLayer *)setBorderWithPath:(UIBezierPath *)path withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth Name:(NSString *)layerName fillColor:(UIColor *)fillColor ToIndex:(NSUInteger)toIndex;


@end
