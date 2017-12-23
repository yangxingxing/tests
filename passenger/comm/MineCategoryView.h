//
//  MineCategoryView.h
//  114SD
//
//  Created by 杨星星 on 2017/3/27./Users/yangxingxing/Desktop/114SD/114SD/ViewControllers/Mine/MineCategoryView.h
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "BaseView.h"

typedef NS_ENUM(NSInteger, ImageLocation) {
    ImageLocationTop,
    ImageLocationLeft,
    ImageLocationBottom,
    ImageLocationRight,
    ImageLocationNone,
};


typedef void (^BtnClickBlock)(NSInteger tag);

@interface MineCategoryView : BaseView

// 积分
//@property (nonatomic,strong) UILabelCustom *levelLabel;

@property (nonatomic,copy,readonly) BtnClickBlock btnClcik;

@property (nonatomic,strong) UIButtonCustom *selectedBtn;

- (void)btnClickWithTag:(NSInteger)tag; // 手动选中

/**
 

 
 @return self
 */

/**
 分栏按钮

 @param frame 位置大小
 @param items 图片和描述数组
 @param showSeparated 是否需要中间分隔线
 @param color 颜色
 @param btnClcik 点击
 @param location 图片位置
 @param btnHeight 图片高度
 @param fontSize 字体大小
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame withItems:(NSArray *)items showSeparatedLine:(BOOL)showSeparated textColor:(UIColor *)color btnClcik:(BtnClickBlock)btnClcik imageLocation:(ImageLocation)location btnHeight:(CGFloat)btnHeight fontSize:(UIFont *)fontSize lineColor:(UIColor *)lineColor btnSpace:(CGFloat)btnSpace selectedTextColor:(UIColor *)selectedTextColor;

- (instancetype)initWithFrame:(CGRect)frame withItems:(NSArray *)items showSeparatedLine:(BOOL)showSeparated textColor:(UIColor *)color btnClcik:(BtnClickBlock)btnClcik imageLocation:(ImageLocation)location btnHeight:(CGFloat)btnHeight fontSize:(UIFont *)fontSize lineColor:(UIColor *)lineColor btnSpace:(CGFloat)btnSpace selectedTextColor:(UIColor *)selectedTextColor backColor:(UIColor *)backColor selectedBackColor:(UIColor *)selectedBackColor lineWidth:(float)lineWid selectedTag:(NSInteger)tag;

@end
