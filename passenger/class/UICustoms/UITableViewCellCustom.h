//
//  UITableViewCellCustom.h
//  wBaiJu
//
//  Created by Apple on 14-12-22.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "WBJUIFont.h"
#import "UILabelCustom.h"

#import <UIKit/UIKit.h>


//UITableViewCell 左空白位置
#define UITableViewCellCustomLeftX 9

//#define UITableViewCellCustomImageToTextWidth 20

//UITableViewCell 分隔线对齐方式
typedef NS_ENUM(NSInteger, SeparatorAlign)
{
    SeparatorAlignImageView,   //与ImageView 左对齐, 如果没有设置image 则与textLabel 左对齐
    SeparatorAlignTextLabel,   //与textLabel 左对齐
    SeparatorAlignLeft,        //左对齐， x 从0 开始
    SeparatorAlignNone,        //不显示线条
    SeparatorAlignCustom,      //用户自定义， 在Cell layoutSubview 不处理;如果子类自行设置，一定要设为Custom,否则会死循环
};

@interface UITableViewCell (UITableViewCellCategory)

- (void)setAccessoryView;  //>

//设置Cell默认选中UIView
+ (void)setTableViewCellSelectedBackView:(UIView *)selectedBackView;

//设置UITableViewCellAccessoryDisclosureIndicator 图片
+ (void)setTableViewCellAccessoryDisclosureIndicatorImage:(UIImage *)image;

//返回Cell默认返回UIView   default  nil
+ (UIView *)tableViewCellSelectedBackView;

@end

@interface UITableViewCell (UITableView)

//创建UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView CellStyle:(UITableViewCellStyle)cellStyle;

+ (instancetype)cellWithTableView:(UITableView *)tableView CellStyle:(UITableViewCellStyle)cellStyle
                        cellIdent:(NSString *)cellIdent;

//取得UITableViewCell 的UITableView
- (UITableView *)tableView;

@end

@interface UITableViewCellCustom : UITableViewCell

//Highlighted 时，一些UIView 的backgroundColor 保持不变
- (void)setUnChangeBackgroundColorWithViewOnHighlighted:(UIView *)view;

//自动取消 选中 default YES
@property (nonatomic) BOOL autoCancelSelected;

//separator线, 分隔线对齐方式,且IOS7 才有效  default SeparatorAlignImageView
@property (nonatomic) SeparatorAlign separatorAlign;

//图标 缩减, 与cell行高 缩减 默认 14
@property (nonatomic) CGFloat imageWidthDec;

@end

typedef NS_ENUM(NSInteger, UISectionViewType)
{
    UISectionViewTypeHeader,
    UISectionViewTypeFooter
};

//textEdgeInsets  = UIEdgeInsetsMake(0, UITableViewCellCustomLeftX, 0, UITableViewCellCustomLeftX);
@interface UISectionHeaderView : UILabelCustom

+ (UISectionHeaderView *)headerWithHeight:(CGFloat)height;

//timeFont lineHeight + 8
+ (UISectionHeaderView *)standardHeader;

//timeFont lineHeight + 8
+ (CGFloat)standardHeaderHeight;

- (instancetype)initWithWidth:(CGFloat)width Height:(CGFloat)height;

//UITableView sectionHeaderView 不悬停处理
//赋UITableView section, 告诉此View 不悬停， default NSUIntegerMax
@property (nonatomic, assign) NSUInteger keepMoveSection;
@property (nonatomic, assign) UISectionViewType sectionViewType;


@end
