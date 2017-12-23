//
//  UIView+Category.m
//  DishOrder iPad
//
//  Created by 邱家楗 on 16/3/28.
//
//

#import "UIView+Category.h"

@implementation UIView (Category)

@dynamic x, y, maxX, maxY, width, height, origin, size;

- (void)setX:(CGFloat)x
{
    CGRect r = self.frame;
    r.origin.x = x;
    self.frame = r;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect r = self.frame;
    r.origin.y = y;
    self.frame = r;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

- (void)setWidth:(CGFloat)width
{
    CGRect r = self.frame;
    r.size.width = width;
    self.frame = r;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect r = self.frame;
    r.size.height = height;
    self.frame = r;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect r = self.frame;
    r.origin = origin;
    self.frame = r;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setSize:(CGSize)size
{
    CGRect r = self.frame;
    r.size = size;
    self.frame = r;
}

- (CGSize)size
{
    return self.frame.size;
}

#pragma mark ViewController

- (UIViewController *)viewController
{
    UIViewController *vc = nil;
    id target = self;
    do {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            vc = (UIViewController*)target;
            break;
        }
    } while (target);
    
    
    return vc;
}

- (void)screenEdgePanGestureRecognizerWithScrollView:(UIScrollView *)scrollView
{
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = [self screenEdgePanGestureRecognizer];
    if (screenEdgePanGestureRecognizer)
        [scrollView.panGestureRecognizer requireGestureRecognizerToFail:screenEdgePanGestureRecognizer];
}

//右滑 与 UIScrollView手势冲突
- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer
{
    //scrollview 与 右滑手势冲突问题解决
    UIApplication *app = [UIApplication sharedApplication];
    UIViewController *rootVC = app.keyWindow.rootViewController;
    UINavigationController *navVC = nil;
    if ([rootVC isKindOfClass:[UINavigationController class]])
    {
        navVC = (UINavigationController*)rootVC;
    }
    else
    {
        navVC = rootVC.navigationController;
    }
    
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (navVC && navVC.view.gestureRecognizers.count > 0)
    {
        for (UIGestureRecognizer *recognizer in navVC.view.gestureRecognizers)
        {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    
    return screenEdgePanGestureRecognizer;
}

#pragma mark border

- (void)setBorderWithRadius:(CGFloat)radius {
    self.layer.cornerRadius  = radius;
    self.layer.masksToBounds = YES;
}

- (void)setBorderWithRadius:(CGFloat)radius borderColor:(UIColor *)borderColor
{
    [self setBorderWithRadius:radius borderColor:borderColor borderWidth: UIButtonBorderWidth];
}

- (void)setBorderWithRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat) borderWidth
{
    self.layer.cornerRadius  = radius;
    self.layer.masksToBounds = YES;
    self.layer.borderColor   = [borderColor CGColor];
    self.layer.borderWidth   = borderWidth;
}


#pragma mark Image Show Size
+ (void)layoutImageSize:(CGSize)imageSize showSize:(CGSize )full
            returnBlock:(void(^)(CGSize newImageSize, CGRect rect, BOOL smallImage))returnBlock {
    
    //先判断 非正方形图 注意：不是width与height完全相等的
    BOOL changeFrame = (imageSize.width >= imageSize.height * 1.5 || imageSize.height >= imageSize.width * 1.5);
    CGFloat maxW  = MIN(full.width, full.height); //考虑 有时 横屏，有时竖屏
    if (imageSize.width >= maxW && imageSize.height >= imageSize.width * 1.5) //竖图
    {
        CGFloat ratio     = maxW / imageSize.width;
        imageSize.width  = maxW;
        imageSize.height = (imageSize.height * ratio);
    }
    else
        //UIViewContentModeScaleAspectFit
        if (imageSize.width > full.width || imageSize.height > full.height)
        {
            CGFloat horizontalRatio = full.width / imageSize.width;
            CGFloat verticalRatio   = full.height / imageSize.height;
            CGFloat ratio = MIN(horizontalRatio, verticalRatio);
            
            imageSize = CGSizeMake(imageSize.width * ratio, imageSize.height * ratio);
        }
    
    BOOL smallImage  = (imageSize.width <= full.width && imageSize.height <= full.height);   //计算后小于显示区域的
    
    CGRect rect;
    if (changeFrame || smallImage) //大图设置 imageView.frame
    {
        CGFloat x = imageSize.width  >= full.width  ? 0 : (full.width  - imageSize.width)  * 0.5;
        CGFloat y = imageSize.height >= full.height ? 0 : (full.height - imageSize.height) * 0.5;
        
        rect = CGRectMake(x, y, imageSize.width, imageSize.height);
    }
    else
    {
        //小图根据 imageView.frame 与superView一样大小
        rect.origin = CGPointZero;
        rect.size   = full;
    }
    
    returnBlock(imageSize, rect, smallImage);
}

@end


@implementation UIImageView (LayoutImageSize)

- (void)layoutImageView
{
    if (nil == self.image || nil == self.superview)
        return;
    if ([self.superview isKindOfClass:[UIScrollView class]] && [self.superview respondsToSelector:@selector(layoutImageView)])
    {
        [self.superview performSelectorOnMainThread:@selector(layoutImageView)
                                         withObject:nil waitUntilDone:YES];
        return;
    }
    CGSize full = self.superview.frame.size;
    [UIView layoutImageSize:self.image.size showSize:full
                returnBlock:^(CGSize newImageSize, CGRect rect, BOOL smallImage) {
                    
                    self.frame = rect;
                    self.contentMode = UIViewContentModeScaleAspectFit;
                    
                    if ([self.superview isKindOfClass:[UIScrollView class]])
                    {
                        UIScrollView *parent = (UIScrollView *)self.superview;
                        
                        parent.contentSize = newImageSize;

                        //设置缩放范围
                        parent.minimumZoomScale = 1;
                        CGFloat scale1 = newImageSize.width < full.width ? (full.width / newImageSize.width) : 0;
                        CGFloat scale2 = newImageSize.height < full.height ? (full.height / newImageSize.height) : 0;
                        
                        parent.maximumZoomScale = MAX(smallImage ?  MIN(scale1, scale2) : MAX(scale1, scale2), 2.5);
                    }
                }];
}

@end
