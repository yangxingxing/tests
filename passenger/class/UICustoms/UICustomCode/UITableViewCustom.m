//
//  UITableViewCustom.m
//  wBaiJu
//
//  Created by 邱家楗 on 15/10/14.
//  Copyright © 2015年 邱家楗. All rights reserved.
//

#import "UITableViewCustom.h"
#import "UITableViewCellCustom.h"

@implementation UITableViewCustom


-(id)init
{
    self = [super init];
    if (self)
    {
        [self initSelf];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initSelf];
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        [self initSelf];
    }
    return self;
}


-(void)initSelf
{
    //self.separatorColor = UITableViewSeparatorColor;
    self.rowHeight    = [WBJUIFont tableViewRowHeight];
    if ([self respondsToSelector:@selector(keyboardDismissMode)])
    {
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; //滚动时自动关闭键盘
    }
    
    if (self.style != UITableViewStyleGrouped)  //qiujj 分组时不要创建 Footer，否则，最上面会有多余空间
    {
        //当数据不够显示一屏时，不会显示 下面空行
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 0.0)];
        footer.backgroundColor = self.separatorColor;
        self.tableFooterView = footer;

        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, UILineBorderWidth)];
        header.backgroundColor = self.separatorColor;
        self.tableHeaderView = header;
        
#if ! __has_feature(objc_arc)
        [footer release];
        [header release];
#endif

//        if (params.sysVer >= 7.0)
//        {
            //IOS7
            //self.backgroundColor = UITableViewBackgroundColor;
//        }
    }
    else
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)  //IOS6 分组时，下面属性为默认
    {
        self.sectionHeaderHeight = 0.0;  //UITableViewSplitRowHeight; 如果设置值，首行header会比较高
        self.sectionFooterHeight = 0.0;  //UITableViewSplitRowHeight;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //IOS8 使 separator线 受separatorInset 控制，详见UITableViewCellCustom
    if ([self respondsToSelector:@selector(setLayoutMargins:)])
        self.layoutMargins = UIEdgeInsetsZero;
    
//    if ([self respondsToSelector:@selector(preservesSuperviewLayoutMargins)])
//        self.preservesSuperviewLayoutMargins = NO;
}

@end


@interface UITableViewCustomGroup()
<UITableViewDataSource, UITableViewDelegate>

@end


@implementation UITableViewCustomGroup

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    return self;
}

-(void)initSelf
{
    [super initSelf];
    self.dataSource = self;
    self.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [UITableViewCellCustom cellWithTableView:tableView CellStyle:UITableViewCellStyleSubtitle];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WBJUIFont tableViewRowHeight]; //UITableViewRowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return UITableViewSplitRowHeight;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
// qiujj 默认不要 有HeaderView, IOS6 会多一条灰
//    CGFloat h = UITableViewSplitRowHeight;
//    if (section > 0)
//        h = UITableViewSplitRowHeight * 2.0;
//    UISectionHeaderView *header = [UISectionHeaderView headerWithHeight:h];
//    return header;
}

@end
