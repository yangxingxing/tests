//
//  ConversationMenuView.h
//  wBaiJu
//
//  Created by Apple on 14-11-21.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBJDropDownMenu.h"

typedef NS_ENUM(NSInteger, ConversationMenus)
{
    cmConversationFirst,
    cmConversationSecond,
    cmConversationThird,
    cmConversationForth,
    cmConversationFifth
};

typedef void (^ConversationMenuClick)(ConversationMenus menu);


@interface ConversationMenuView: WBJDropDownMenu

//设置 点击 事件
- (void)setMenuClick:(ConversationMenuClick)menuClick buttons:(NSArray<NSDictionary *> *)buttons;


@end
