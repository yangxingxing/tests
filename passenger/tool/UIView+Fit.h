//
//  UIView+Fit.h
//  testtest
//
//  Created by Mac on 15/3/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSUITextField.h"
#import "UITableViewCustom.h"
#import "UIButtonCustom.h"
//#import "UIAlertViewCustom.h"
#import "UIView+Category.h"

@interface UIView (Fit)

#pragma mark UIView

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

- (void)changeY:(CGFloat)y;
- (void)changeX:(CGFloat)x;
- (void)changeWidth:(CGFloat)width;
- (void)changeHeight:(CGFloat)height;
- (void)changePoint:(CGPoint)Point;
- (void)changeSize:(CGSize)size;

#pragma mark UIView
//自适应全屏
-(void)fullRectWithSelfName:(NSString*)selfName superView:(UIView*)supView;
-(void)fullRect;
//旋转
-(void)transformCGAffineTransformMakeRotationWithRotation:(CGFloat)angle;
//line
-(CAShapeLayer*)lineVerticalWithPoint:(CGPoint)point toPoint:(CGPoint)toPoint;

-(CAShapeLayer*)lineVerticalWithPoint:(CGPoint)point toPoint:(CGPoint)toPoint andColor:(UIColor *)color;
-(CAShapeLayer*)lineVerticalWithPoint:(CGPoint)point toPoint:(CGPoint)toPoint andColor:(UIColor *)color lineWidth:(float)lineWidth;

//画虚线
+(void)drawDashLine:(UIImageView *)imageView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;
//扫描区域边框
-(CAShapeLayer*)lineBoardWithFrame:(CGRect)frame andColor:(UIColor *)color lineWidth:(float)lineWidth;

#pragma mark UITableView
+(instancetype)tableViewWithFrame:(CGRect)frame delegate:(id<UITableViewDataSource,UITableViewDelegate>)delegate supView:(UIView*)superView;


#pragma mark UIScrollView
+(UIScrollView*)scrowllViewWithFrame:(CGRect)frame supView:(UIView*)superView page:(int)page delegate:(id<UIScrollViewDelegate>)delegate;

#pragma mark UICollectionView
+(UICollectionView*)collectionViewWithFrame:(CGRect)frame flowLayout:(UICollectionViewFlowLayout*)flowLayout delegate:(id<UICollectionViewDataSource,UICollectionViewDelegate>)delegate supView:(UIView*)superView registerClass:(Class)classname reuseIdentifier:(NSString*)reuseIdentifier;

#pragma mark HSUITextField
+(instancetype)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder maxLen:(int)maxLen inputEmoji:(BOOL)inputEmoji numberOnly:(BOOL)numberOnly delegate:(id<HSUITextFieldDelegate>)delegate supView:(UIView*)superView;

//显示最大宽度
-(void)limitMaxWidth:(float)width;
//显示最大高度
-(void)limitMaxHeight:(float)height;

-(void)addScaleAnimation;//添加动画，放大后再变小
-(void)addScaleAnimationWithCompletion:(dispatch_block_t)completion;

/**
 *  增加 View 顶部线条
 *
 *  @param borderColor 边框色
 *  @param borderWidth 边框线条粗细值
 *
 */
- (void)addTopLineWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
- (void)addTopLine;

/**
 *  增加 View 底部线条
 *
 *  @param borderColor 边框色
 *  @param borderWidth 边框线条粗细值
 */
- (void)addBottomLineWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
- (void)addBottomLine;

@end

@interface UIButton (Fit)

#pragma mark UIButton
+ (instancetype)buttonCustomWithFrame:(CGRect)frame image:(UIImage*)image supView:(UIView*)superView;

+ (instancetype)buttonCustomWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius title:(NSString*)title fontSize:(CGFloat)fontSize titleColor:(UIColor*)titleColor supView:(UIView*)superView;

+ (instancetype)buttonCustomWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius title:(NSString*)title fontSize:(CGFloat)fontSize titleColor:(UIColor*)titleColor titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets image:(UIImage*)image imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets supView:(UIView*)superView;


@end
