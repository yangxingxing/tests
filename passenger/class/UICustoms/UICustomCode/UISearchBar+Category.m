//
//  UISearchBar+Category.m
//  DishOrder iPad
//
//  Created by 邱家楗 on 16/3/30.
//
//

#import "UISearchBar+Category.h"

@implementation UISearchBar(Category)

- (void)borderWithRadius:(CGFloat)radius borderColor:(UIColor *)borderColor background:(UIColor *)background
{
    self.autoresizingMask = UIAutoSizeMaskTop;
    
    CGRect searchBarrect = self.frame;
    self.backgroundImage = [UIImage imageWithColor:background withSize:searchBarrect.size];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        self.barTintColor  = background;
        if (radius > 0)
            [self setBorderWithRadius:radius borderColor:borderColor];  //IOS 6.0 无法去除边框
    }
    else{
        self.tintColor = background;
    }

}

@end
