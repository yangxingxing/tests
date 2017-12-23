//
//  UIView+Fit.m
//  testtest
//
//  Created by Mac on 15/3/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UIView+Fit.h"


@implementation UIView (Fit)


#pragma mark UIView


- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)changeY:(CGFloat)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (void)changeX:(CGFloat)x {
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (void)changeWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)changeHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (void)changePoint:(CGPoint)Point {
    CGRect rect = self.frame;
    rect.origin = Point;
    self.frame = rect;
}

- (void)changeSize:(CGSize)size {
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

-(void)transformCGAffineTransformMakeRotationWithRotation:(CGFloat)angle{
    CGRect frame = self.frame;
    self.transform = CGAffineTransformMakeRotation(angle);
    self.height = frame.size.height;
    self.width = frame.size.width;
    self.x = frame.origin.x;
    self.y = frame.origin.y;
}
//两点一线
-(CAShapeLayer*)lineVerticalWithPoint:(CGPoint)point toPoint:(CGPoint)toPoint{
    return [self lineVerticalWithPoint:point toPoint:toPoint andColor:UITableViewSeparatorColor];
}
-(CAShapeLayer*)lineVerticalWithPoint:(CGPoint)point toPoint:(CGPoint)toPoint andColor:(UIColor *)color{
    return [self lineVerticalWithPoint:point toPoint:toPoint andColor:color lineWidth:UILineBorderWidth];
}
//两点一线，加个设置颜色的
-(CAShapeLayer*)lineVerticalWithPoint:(CGPoint)point toPoint:(CGPoint)toPoint andColor:(UIColor *)color lineWidth:(float)lineWidth{
    
    CGMutablePathRef linePath = CGPathCreateMutable();
    CAShapeLayer * lineShape = [CAShapeLayer layer];
    lineShape.lineWidth = lineWidth;
    lineShape.lineCap = kCALineCapRound;
    lineShape.strokeColor = [color CGColor];
    CGPathMoveToPoint(linePath, NULL, point.x, point.y);
    CGPathAddLineToPoint(linePath, NULL, toPoint.x, toPoint.y);
    lineShape.path = linePath;
    CGPathRelease(linePath);
    [self.layer addSublayer:lineShape];
    return lineShape;
}

//扫描区域边框
-(CAShapeLayer*)lineBoardWithFrame:(CGRect)frame andColor:(UIColor *)color lineWidth:(float)lineWidth{
    
    CGMutablePathRef linePath = CGPathCreateMutable();
    CAShapeLayer * lineShape = [CAShapeLayer layer];
    lineShape.lineWidth = lineWidth;
    lineShape.lineCap = kCALineCapRound;
    lineShape.strokeColor = [color CGColor];
    lineShape.fillColor = [UIColor clearColor].CGColor;
    float lineLength = 20;
    //左上角
    CGPathMoveToPoint(linePath, NULL, lineWidth/2, lineLength+lineWidth/2);
    CGPathAddLineToPoint(linePath, NULL, lineWidth/2, lineWidth/2);
    CGPathAddLineToPoint(linePath, NULL, lineLength+lineWidth/2, lineWidth/2);
    //右上角
    CGPathMoveToPoint(linePath, NULL, frame.size.width-lineLength-lineWidth/2, lineWidth/2);
    CGPathAddLineToPoint(linePath, NULL, frame.size.width-lineWidth/2, lineWidth/2);
    CGPathAddLineToPoint(linePath, NULL, frame.size.width-lineWidth/2, lineLength+lineWidth/2);
    //右下角
    CGPathMoveToPoint(linePath, NULL, frame.size.width-lineWidth/2, frame.size.height-lineLength-lineWidth/2);
    CGPathAddLineToPoint(linePath, NULL, frame.size.width-lineWidth/2, frame.size.height-lineWidth/2);
    CGPathAddLineToPoint(linePath, NULL, frame.size.width-lineLength-lineWidth/2, frame.size.height-lineWidth/2);
    //左下角
    CGPathMoveToPoint(linePath, NULL, lineLength+lineWidth/2, frame.size.height-lineWidth/2);
    CGPathAddLineToPoint(linePath, NULL, lineWidth/2, frame.size.height-lineWidth/2);
    CGPathAddLineToPoint(linePath, NULL, lineWidth/2, frame.size.height-lineLength-lineWidth/2);
    
    lineShape.path = linePath;
    CGPathRelease(linePath);
    [self.layer addSublayer:lineShape];
    return lineShape;
}

/**
 ** lineView:	 需要绘制成虚线的view
 ** lineLength:	 虚线的宽度
 ** lineSpacing: 虚线的间距
 ** lineColor:	 虚线的颜色
 **/
+(void)drawDashLine:(UIImageView *)imageView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    UIGraphicsBeginImageContext(imageView.frame.size);   //开始画线
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    CGFloat lengths[] = {lineLength,lineSpacing};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, lineColor.CGColor);
    CGContextSetLineDash(line, 0, lengths, 1);  //画虚线
    CGContextMoveToPoint(line, 0, 1); //开始画线, x，y 为开始点的坐标
    CGContextAddLineToPoint(line, imageView.frame.size.width, 1);//画直线, x，y 为线条结束点的坐标
    CGContextStrokePath(line);
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
}

//自适应全屏
-(void)fullRect{
    if (self.superview)
    {
        CGRect rect = self.superview.bounds;
        if (rect.origin.y < 0)
            rect.size.height = rect.size.height + rect.origin.y;
        rect.origin.y = 0;
        self.frame = rect;
        
    }
    self.autoresizingMask = UIAutoSizeMaskAll;
}

//自适应全屏
-(void)fullRectWithSelfName:(NSString*)selfName superView:(UIView*)supView{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSString * hFormat = [NSString stringWithFormat:@"H:|-0-[%@]-0-|",selfName];
    NSString * vFormat = [NSString stringWithFormat:@"V:|-0-[%@]-0-|",selfName];
    NSArray *contsH = [NSLayoutConstraint constraintsWithVisualFormat:hFormat options:0 metrics:nil views:@{selfName:self}];
    NSArray *contsV = [NSLayoutConstraint constraintsWithVisualFormat:vFormat options:0 metrics:nil views:@{selfName:self}];
    [supView addConstraints:contsH];
    [supView addConstraints:contsV];
}
#pragma mark UITableView
+(instancetype)tableViewWithFrame:(CGRect)frame delegate:(id<UITableViewDataSource,UITableViewDelegate>)delegate supView:(UIView*)superView{
    
    UITableViewCustom * _tableView = [[UITableViewCustom alloc]initWithFrame:frame style:UITableViewStylePlain];
    _tableView.dataSource = delegate;
    _tableView.delegate = delegate;
    _tableView.scrollEnabled = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if (superView && [superView isKindOfClass:[UIView class]]){
        [superView addSubview:_tableView];
    }
    
    return _tableView;
}

#pragma mark UIScrollView
+(UIScrollView*)scrowllViewWithFrame:(CGRect)frame supView:(UIView*)superView page:(int)page delegate:(id<UIScrollViewDelegate>)delegate{
    UIScrollView * _scrowllView = [[UIScrollView alloc]initWithFrame:frame];
    _scrowllView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    if (delegate) {
        _scrowllView.delegate = delegate;
    }
//    _scrowllView.bounces = NO;
    _scrowllView.scrollEnabled = YES;
    if (page > 0) {//横向滚动
        [_scrowllView setContentSize:CGSizeMake(_scrowllView.width * page, _scrowllView.height)];
        _scrowllView.pagingEnabled = YES;
    }
    if (superView) {
        [superView addSubview:_scrowllView];
    }
    
    return _scrowllView;
}

#pragma mark UICollectionView
+(UICollectionView*)collectionViewWithFrame:(CGRect)frame flowLayout:(UICollectionViewFlowLayout*)flowLayout delegate:(id<UICollectionViewDataSource,UICollectionViewDelegate>)delegate supView:(UIView*)superView registerClass:(Class)classname reuseIdentifier:(NSString*)reuseIdentifier{
    
    UICollectionView * _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    _collectionView.dataSource = delegate;
    _collectionView.delegate   = delegate;
    _collectionView.showsVerticalScrollIndicator     = NO;
    _collectionView.showsHorizontalScrollIndicator   = NO;
    _collectionView.backgroundColor = UITableViewBackgroundColor;
    [_collectionView registerClass:classname forCellWithReuseIdentifier:reuseIdentifier];
    if (superView && [superView isKindOfClass:[UIView class]]) {
        [superView addSubview:_collectionView];
    }
    
    return _collectionView;
}

#pragma mark HSUITextField
+(instancetype)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder maxLen:(int)maxLen inputEmoji:(BOOL)inputEmoji numberOnly:(BOOL)numberOnly delegate:(id<HSUITextFieldDelegate>)delegate supView:(UIView*)superView{
    HSUITextField *textFied = [[self alloc]initWithFrame:frame];
    if (placeholder) {
        textFied.placeholder = placeholder;
    }
    textFied.returnKeyType = UIReturnKeyNext;
    textFied.maxLen = maxLen;
    textFied.inputEmoji = inputEmoji;
    textFied.numberOnly = numberOnly;
    textFied.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if (delegate) {
        textFied.delegate = delegate;
    }
    if (superView) {
        [superView addSubview:textFied];
    }
    return textFied;
    
}

//显示最大宽度
-(void)limitMaxWidth:(float)width{
    if (self.width > width) {
        self.width = width;
    }
}
//显示最大高度
-(void)limitMaxHeight:(float)height{
    if (self.height > height) {
        self.height = height;
    }
}
-(void)addScaleAnimation{
    [self addScaleAnimationWithCompletion:nil];
}
-(void)addScaleAnimationWithCompletion:(dispatch_block_t)completion{
    //添加动画
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    [self.layer addAnimation:k forKey:@"zanAnimation"];
    if (completion) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completion();
        });
    }
}

/**
 *  增加 View 顶部线条
 *
 *  @param borderColor 边框色
 *  @param borderWidth 边框线条粗细值
 *
 */
- (void)addTopLineWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, borderWidth)];
    line.backgroundColor = borderColor;
    [self bringSubviewToFront:line];
    [self addSubview:line];
}

- (void)addTopLine {
    [self addTopLineWithBorderColor:UITableViewSeparatorColor borderWidth:UIButtonBorderWidth];
}

/**
 *  增加 View 底部线条
 *
 *  @param borderColor 边框色
 *  @param borderWidth 边框线条粗细值
 */
- (void)addBottomLineWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - borderWidth, self.width, borderWidth)];
    line.backgroundColor = borderColor;
    [self bringSubviewToFront:line];
    [self addSubview:line];
}

- (void)addBottomLine {
    [self addBottomLineWithBorderColor:UITableViewSeparatorColor borderWidth:UIButtonBorderWidth];
}

@end

@implementation UIButton (Fit)

#pragma mark UIButton
+(instancetype)buttonCustomWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius title:(NSString*)title fontSize:(CGFloat)fontSize titleColor:(UIColor*)titleColor supView:(UIView*)superView{
    
    return [self buttonCustomWithFrame:frame cornerRadius:cornerRadius title:title fontSize:fontSize titleColor:titleColor titleEdgeInsets:UIEdgeInsetsZero image:nil imageEdgeInsets:UIEdgeInsetsZero supView:superView];
}
+(instancetype)buttonCustomWithFrame:(CGRect)frame image:(UIImage*)image supView:(UIView*)superView{
    UIButtonCustom * btn = [self buttonCustomWithFrame:frame cornerRadius:0 title:nil fontSize:0 titleColor:nil titleEdgeInsets:UIEdgeInsetsZero image:nil imageEdgeInsets:UIEdgeInsetsZero supView:superView];
    if (image) {
        [btn setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    return btn;
}

+(instancetype)buttonCustomWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius title:(NSString*)title fontSize:(CGFloat)fontSize titleColor:(UIColor*)titleColor titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets image:(UIImage*)image imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets supView:(UIView*)superView{
    
    if (frame.size.height < fontSize) {
        frame.size.height = fontSize;
    }
    
    UIButtonCustom *tempBtn = [self buttonWithType:UIButtonTypeCustom];
    tempBtn.frame     = frame;
    tempBtn.exclusiveTouch = YES;
    tempBtn.layer.masksToBounds = YES;
    if (cornerRadius > 0) {
        tempBtn.layer.cornerRadius  = cornerRadius;
        //tempBtn.layer.borderWidth   = UIButtonBorderWidth;
    }
    if (title) {
        [tempBtn setTitle:title forState:UIControlStateNormal];
    }
    [tempBtn setTitleColor:titleColor forState:UIControlStateNormal];
    if (image) {
        [tempBtn setImage:image forState:UIControlStateNormal];
    }
    if (fontSize > 0) {
        tempBtn.titleLabel.font = [WBJUIFont lightFontWithSize:fontSize];//[UIFont systemFontOfSize:fontSize];
    }
    if (!UIEdgeInsetsEqualToEdgeInsets(imageEdgeInsets, UIEdgeInsetsZero)) {
        tempBtn.imageEdgeInsets = imageEdgeInsets;
    }
    if (!UIEdgeInsetsEqualToEdgeInsets(titleEdgeInsets, UIEdgeInsetsZero)) {
        tempBtn.titleEdgeInsets = titleEdgeInsets;
    }
    
    [tempBtn setBackgroundColor:[UIColor clearColor]];
    if (superView && [superView isKindOfClass:[UIView class]]) {
        [superView addSubview:tempBtn];
    }
    
    
    //    tempBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //    [tempBtn addTarget:self action:@selector(pressOKButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    return tempBtn;
}


@end
