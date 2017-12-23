//
//  CALayerLine.h
//  navViewController
//
//  Created by 邱家楗 on 16/1/11.
//  Copyright © 2016年 邱家楗. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CALayerLineHorizontal)
{
    CALayerLineHorizontalCustom,    //自定义位置
    CALayerLineHorizontalTop,       //线条 位于UIView顶部
    CALayerLineHorizontalCenter,    //线条 位于UIView上下中间
    CALayerLineHorizontalBottom     //线条 位于UIView底部
};

@interface CALayerLine : CALayer

@property (nonatomic) CALayerLineHorizontal lineHorizontal;

@property (nonatomic) UIEdgeInsets expandOfSupperEdgeInsets;
@end

@interface CALayerLineFocus : CALayerLine

@end

@interface UIView(LayerLine)

/**
 *  增加 View 顶部线条
 *
 *  @param borderColor 边框色
 *  @param borderWidth 边框线条粗细值
 *
 *  @return CALayerLine
 */
- (CALayerLine *)addTopLineWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

//中间线
- (CALayerLine *)addCenterLineWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

- (CALayerLine *)addCenterLineWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth Width:(CGFloat)width;

/**
 *  增加 View 底部线条
 *
 *  @param borderColor 边框色
 *  @param borderWidth 边框线条粗细值
 *
 *  @return CALayerLine
 */
- (CALayerLine *)addBottomLineWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

- (CALayerLine *)addBottomLineWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth Width:(CGFloat)width;

- (CALayerLine *)addLineWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
                                   Size:(CGSize)size
                         LineHorizontal:(CALayerLineHorizontal)lineHorizontal
                                 Name:(NSString *)layerName;

/**
 *  画文本录入框 底部U型线条
 *  @param focaled YES 为橙色 否则为浅灰色
 *  @return CALayerLineFocus
 */
- (CALayerLineFocus *)addFocusLineWithFocused:(BOOL)focused;

- (CALayerLineFocus *)addFocusLineWithFocused:(BOOL)focused Width:(CGFloat)width;

@end

