//
//  UILabelCustom.h
//
//  UILabel 增加verticalAlignment 控制 上下居中、靠上对齐、靠下对齐
//          增加textEdgeInsets    控制 四周的边距
//  Created by 邱家楗 on 15/12/21.
//  Copyright © 2015年 邱家楗. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UILabelVerticalAlignment) {
    UILabelVerticalAlignmentCenter  = 0,
    UILabelVerticalAlignmentTop     = 1,
    UILabelVerticalAlignmentBottom  = 2,
};

//默认UILabel 只有 上下居中
@interface UILabelCustom : UILabel

//上下居中类型 默认 上下居中
@property (nonatomic, assign) UILabelVerticalAlignment  verticalAlignment;

//边缘处理，留边距时，可简少代码处理
@property (nonatomic, assign) UIEdgeInsets textEdgeInsets;                // default is UIEdgeInsetsZero

@end
