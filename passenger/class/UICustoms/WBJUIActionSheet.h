//
//  WBJUIActionSheet.h
//
//
//  Created by 邱家楗 on 16/5/18.
//  Copyright © 2016年 邱家楗. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WBJUIActionSheetBlock)(NSInteger tag);

@interface WBJUIActionSheet : UIView

@property (nonatomic, copy) dispatch_block_t closeViewBlock;

//初始化 Title：标题 cancelButtonTitle：最底下取消按钮 标题，此为必录项
- (instancetype) initWithTitle:(NSString *)title
             cancelButtonTitle:(NSString *)cancelButtonTitle;

- (void)addItemWithTitle:(NSString *)title block:(WBJUIActionSheetBlock)block tag:(NSInteger)tag;

- (void)addItemWithTitle:(NSString *)title block:(WBJUIActionSheetBlock)block tag:(NSInteger)tag titleColor:(UIColor *)titleColor;

//显示在inView.window
- (void)showInView:(UIView *)inView;

@end
