//
//  StarRateView.h
//
//  五角星 评分控件
//  Created by 邱家楗 on 16/6/24.
//  Copyright © 2016年 qiujj. All rights reserved.
//


//用Layer实现画星星
//星星 分 直线五角星 与 曲线五角星， 直线五角星也可扩展五个角为圆角

//商城星星的大小
#define starsBigSize  13
#define starsSmallSize  11

#import <UIKit/UIKit.h>

@interface StarLayer : CAShapeLayer

+ (instancetype)starWithColor:(UIColor *)color frame:(CGRect)frame
                    lineWidth:(CGFloat)lineWidth starCurve:(BOOL)starCurve;

- (void)setStarCurve:(BOOL)starCurve lineWidth:(CGFloat)lineWidth;

@property (nonatomic, assign) BOOL starCurve;

@end

@class StarRateView;
@protocol StarRateViewDelegate <NSObject>

@optional
- (void)starRateView:(StarRateView *)rateView didUpdateRating:(CGFloat)rating;

@end

@interface StarRateView : UIView

// Rating to be used with StarRateView (0.0 to 5.0)
@property (nonatomic, assign) CGFloat rating;

- (void)setRating:(CGFloat)rating animation:(BOOL)animation;

// 用户能修改 默认NO
@property (nonatomic, assign) BOOL canRate;

@property (nonatomic, assign) BOOL isInteger;

// Rating step when user can rate (0.0 to 1.0)
@property (nonatomic, assign) CGFloat step;

// Number of stars to display  default 5
@property (nonatomic, assign) NSUInteger starCount;

// Star Normal, Fill & Border Colors
@property (nonatomic, strong) UIColor *starNormalColor;
@property (nonatomic, strong) UIColor *starFillColor;

@property (nonatomic, assign) CGFloat starSize;        //default 30
@property (nonatomic, assign) CGFloat padding;         //default 1

// 曲线五角星 default NO （NO直级五角星）
@property (nonatomic, assign) BOOL starCurve;

// StarRateViewDelegate, register in order to listen to rating changes
#if ! __has_feature(objc_arc)
@property (nonatomic, assign) id<StarRateViewDelegate> delegate;
#else
@property (nonatomic, weak)   id<StarRateViewDelegate> delegate;
#endif

// Class Helper for Rate View instantiation
+ (instancetype)rateViewWithRating:(CGFloat)rating starCurve:(BOOL)starCurve;

+ (instancetype)rateViewWithRating:(CGFloat)rating starSize:(CGFloat)starSize starCurve:(BOOL)starCurve;

@end
