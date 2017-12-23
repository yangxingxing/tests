//
//  UIView+Category.h
//  DishOrder iPad
//
//  Created by 邱家楗 on 16/3/28.
//
//

#import "UIConsts.h"

#import <UIKit/UIKit.h>

@interface UIView (Category)

#pragma mark frame
@property (nonatomic, assign)   CGFloat x;
@property (nonatomic, assign)   CGFloat y;
@property (nonatomic, readonly) CGFloat maxX;
@property (nonatomic, readonly) CGFloat maxY;

@property (nonatomic, assign)   CGFloat width;
@property (nonatomic, assign)   CGFloat height;

@property (nonatomic, assign)   CGPoint origin;
@property (nonatomic, assign)   CGSize  size;

#pragma mark ViewController
@property (nonatomic, readonly) UIViewController* viewController;

//右滑 与 UIScrollView手势冲突
- (void)screenEdgePanGestureRecognizerWithScrollView:(UIScrollView *)scrollView;

#pragma mark border
- (void)setBorderWithRadius:(CGFloat)radius;
//设置圆角 及 边框色 borderWidth = UIButtonBorderWidth
- (void)setBorderWithRadius:(CGFloat)radius borderColor:(UIColor *)borderColor;

- (void)setBorderWithRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

#pragma mark Image Show Size
+ (void)layoutImageSize:(CGSize)imageSize showSize:(CGSize )full
            returnBlock:(void(^)(CGSize newImageSize, CGRect rect, BOOL smallImage))returnBlock;

@end

@interface UIImageView (LayoutImageSize)

- (void)layoutImageView;

@end

