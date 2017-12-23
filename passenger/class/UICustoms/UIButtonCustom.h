//
//  UIButtonCustom.h
//  系统自带UIButton在只设置backgroundColor时，touchDown时，不会变色
//
//  Created by 邱家楗 on 15/11/26.
//  Copyright © 2015年 邱家楗. All rights reserved.
//

#import "UIConsts.h"
#import "UIView+Category.h"

#import <UIKit/UIKit.h>

@interface UIButtonCustom : UIButton

//按钮 按下时，按钮的背景颜色。默认为nil
@property(nonatomic, strong) UIColor *touchDownBackColor;

//用 titleEdgeInsets  imageEdgeInsets 调imageView,titleLabel不方便 可直接用下面两属性；
//有时设置的 image size不一样时，要重新调整显得更为麻烦
//default CGRectZero
@property (nonatomic, assign) CGRect imageViewFrame;
@property (nonatomic, assign) CGRect titleLabelFrame;

//扩大点击区域
@property (nonatomic, assign) UIEdgeInsets enlargeEdge;

@end
