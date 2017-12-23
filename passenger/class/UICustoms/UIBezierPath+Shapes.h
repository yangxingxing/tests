//
//  UIBezierPath+Shapes.h
//  不规则UIView UIBezierPath
//
//  Created by qiujj on 2014-09-05.
//  Copyright (c) 2014 qiujj. All rights reserved.
//

#import <UIKit/UIKit.h>

//箭头方向
typedef enum ShapesBeaker{
    sbLeft,    //左
    sbRight,   //右
    sbTop,     //上
    sbBottom   //下
} ShapesBeaker;

@interface UIBezierPath (Shapes)

+ (instancetype)userShape:(CGRect)originalFrame;
+ (instancetype)martiniShape:(CGRect)originalFrame;
+ (instancetype)beakerShape:(CGRect)originalFrame;

//标注框，主要用于微佰聚 聊天界面 内容显示
+ (instancetype)beakerShape:(CGRect)originalFrame
               ShapesBeaker:(ShapesBeaker)shapesBeaker
                     Offset:(CGFloat)offset
                BorderWidth:(CGFloat)borderWidth;

//radius: 圆角 triangleSize: 三角形大小
+ (instancetype)beakerShape:(CGRect)originalFrame
               ShapesBeaker:(ShapesBeaker)shapesBeaker
                     Offset:(CGFloat)offset
                BorderWidth:(CGFloat)borderWidth
                     Radius:(CGFloat)radius
               TriangleSize:(CGFloat)triangleSize;

+ (instancetype)starShape:(CGRect)originalFrame;
+ (instancetype)stars:(NSUInteger)numberOfStars shapeInFrame:(CGRect)originalFrame;

//直线 五角星  ★
+ (instancetype)starPathWithWidth:(CGFloat)width borderWidth:(CGFloat)borderWidth;

//曲线五角星 注 borderWidth > 0 才有效
+ (instancetype)starCurvePathWithWidth:(CGFloat)width borderWidth:(CGFloat)borderWidth;

@end
