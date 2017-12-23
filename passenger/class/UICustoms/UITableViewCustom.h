//
//  UITableViewCustom.h
//  wBaiJu
//
//  Created by 邱家楗 on 15/10/14.
//  Copyright © 2015年 邱家楗. All rights reserved.
//

#import "UIConsts.h"
#import "WBJUIFont.h"
#import "UITableViewCellCustom.h"

#import <UIKit/UIKit.h>

//style 不为 UITableViewStyleGrouped 时，创建 tableFooterView, tableHeaderView
//注： tableHeaderView height 为 UILineBorderWidth

@interface UITableViewCustom : UITableView

//初始化
- (void)initSelf;

@end

//style: UITableViewStyleGrouped
@interface UITableViewCustomGroup : UITableViewCustom

@end
