//
//  UISearchBar+Category.h
//  DishOrder iPad
//
//  Created by 邱家楗 on 16/3/30.
//
//

#import "UIConsts.h"
#import "UIView+Category.h"
#import "UIImageCategory.h"

#import <UIKit/UIKit.h>

@interface UISearchBar(Category)

//设置圆角，并清除背景色
- (void)borderWithRadius:(CGFloat)radius borderColor:(UIColor *)borderColor background:(UIColor *)background;

@end
