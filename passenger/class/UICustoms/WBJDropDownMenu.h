//
//  WBJDropDownMenu.h
//
//
//  Created by 邱家楗 on 16/12/1.
//  Copyright © 2016年 邱家楗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCustom.h"
#import "UITableViewCellCustom.h"
#import "UIBezierPath+Shapes.h"
#import "UIView+MaskWithPath.h"
//#import "wParams.h"

typedef void (^WBJDropDownMenuBlock)(NSInteger tag);

@interface WBJDropDownMenu : UIView

@property (nonatomic, readonly) UITableViewCustom *tableView;

@property (nonatomic, assign) ShapesBeaker shapesBeaker;      //箭头方向 默认sbTop
@property (nonatomic, assign) CGFloat beakerOffset;           //箭头显示位置 默width - 28
@property (nonatomic, assign) CGFloat imageWidthDec;          //default tableView.rowHeight - 20
@property (nonatomic, copy)   UIColor *titleColor;            //default whiteColor
@property (nonatomic, readonly) BOOL showAnimateing;          //正在显示，还在处理动画


- (void)addItemWithTitle:(NSString *)title block:(WBJDropDownMenuBlock)block tag:(NSInteger)tag;

- (void)addItemWithTitle:(NSString *)title block:(WBJDropDownMenuBlock)block tag:(NSInteger)tag
                   image:(UIImage *)image;

//需要 子类设置 cell图片，title
- (void)setItem:(UITableViewCellCustom *)cell IndexPath:(NSIndexPath *)indexPath;

//显示在inView.window
- (void)showInView:(UIView *)view origin:(CGPoint)origin width:(CGFloat)width;

//beakerView 箭头 显示的位置
- (void)showInView:(UIView *)view beakerView:(UIView *)beakerView width:(CGFloat)width;

//关闭
-(void)closeWithAnimation:(BOOL)animation;

@end
