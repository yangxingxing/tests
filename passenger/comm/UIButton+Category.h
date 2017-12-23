//
//  UIButton+Category.h
//  wBaiJu
//
//  Created by 邱家楗 on 16/3/19.
//  Copyright © 2016年 邱家楗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Category)

//设置 添加照片 按钮
//- (void)setAddPhotoButtonWithSpace:(CGFloat)space;
- (void)createIndicatorWithColor:(UIColor *)color width:(float)width withlineWidth:(CGFloat)lineWidth;

//大按钮，如 登录、注册
- (void)setBigButtonWithTitle:(NSString *)title
                        color:(UIColor *)color
                       target:(id)target
                       action:(SEL)action;

@end
