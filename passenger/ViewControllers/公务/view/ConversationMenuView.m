//
//  ConversationMenuView.m
//  wBaiJu
//
//  Created by Apple on 14-11-21.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "ConversationMenuView.h"

@interface ConversationMenuView ()

@property (nonatomic, copy) ConversationMenuClick menuClickBlock;

@end

@implementation ConversationMenuView


-(void)setMenuClick:(ConversationMenuClick)menuClick  buttons:(NSArray<NSDictionary *> *)buttons
{
    self.menuClickBlock = menuClick;
    __weak typeof(self) wself = self;
//    NSInteger count = sizeof(ConversationMenuKeys) / sizeof(ConversationMenuKeys[0]);
    NSInteger count = buttons.count;
    for (NSInteger i = 0; i < count; i++) {
        NSDictionary *dic = buttons[i];
        [self addItemWithTitle:dic[@"title"]
                         block:^(NSInteger tag) {
                             if (wself && wself.menuClickBlock)
                             {
                                 wself.menuClickBlock(tag);
                                 wself.menuClickBlock = nil;
                             }
                         } tag:i
                         image:ImageNamed(dic[@"image"])];
    }
}

@end
