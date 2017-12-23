//
//  CALayerLine.m
//  navViewController
//
//  Created by 邱家楗 on 16/1/11.
//  Copyright © 2016年 邱家楗. All rights reserved.
//

#import "CALayerLine.h"

@interface CALayerLine()

//<CALayerDelegate>


@end


@implementation CALayerLine

- (instancetype)init
{
    self = [super init];
    if (self) {
        _expandOfSupperEdgeInsets = UIEdgeInsetsZero;
        _lineHorizontal           = CALayerLineHorizontalCustom;
        self.contentsScale        = [[UIScreen mainScreen] scale];
        self.delegate             = self;
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    if ([layer isKindOfClass:[CALayerLine class]])
    {
        CALayerLine *layerLine = (CALayerLine*)layer;
        
        CGRect r = layer.frame;
        switch (_lineHorizontal) {
            case CALayerLineHorizontalTop:
                r.origin.y = layerLine.expandOfSupperEdgeInsets.top - layerLine.expandOfSupperEdgeInsets.bottom + r.size.height * 0.5;
                break;
            case CALayerLineHorizontalCenter:
                r.origin.y = (self.superlayer.frame.size.height - r.size.height) * 0.5 + layerLine.expandOfSupperEdgeInsets.top - layerLine.expandOfSupperEdgeInsets.bottom;
                break;
            case CALayerLineHorizontalBottom:
                r.origin.y = (self.superlayer.frame.size.height - r.size.height) + layerLine.expandOfSupperEdgeInsets.top - layerLine.expandOfSupperEdgeInsets.bottom - r.size.height * 0.5;
                break;
            default:
                break;
        }
        r.origin.y   = floor(r.origin.y); //IOS 6 需要，不然有些界面显示不出来
        r.origin.x = layerLine.expandOfSupperEdgeInsets.left;
        r.size.width = layer.superlayer.frame.size.width - layerLine.expandOfSupperEdgeInsets.left - layerLine.expandOfSupperEdgeInsets.right;
        layer.frame = r;
        
        [layer setNeedsDisplay];
    }
}

@end

@implementation CALayerLineFocus

- (void)setLineHorizontal:(CALayerLineHorizontal)lineHorizontal
{
    super.lineHorizontal = CALayerLineHorizontalBottom;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor clearColor] CGColor];
        super.lineHorizontal  = CALayerLineHorizontalBottom;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    CGFloat h = 5.0;
    
    CGContextSetLineWidth(ctx, 1);
    //1.绘制图形
    CGContextMoveToPoint(ctx, 0, self.frame.size.height - h);
    CGContextAddLineToPoint(ctx, 0, self.frame.size.height);
    CGContextAddLineToPoint(ctx, self.frame.size.width, self.frame.size.height);
    CGContextAddLineToPoint(ctx, self.frame.size.width, self.frame.size.height - h);
    //设置属性（颜色）
    //    [[UIColor yellowColor]set];
    //CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
    CGContextSetStrokeColorWithColor(ctx, self.borderColor);
    
    //2.渲染
    //CGContextFillPath(ctx);
    CGContextStrokePath(ctx);
}

@end

@implementation UIView(LayerLine)


- (CALayerLine *)findCALineWithName:(NSString *)layerName
{
    if (self.layer.sublayers.count > 0)
    {
        for (CALayer *layer in self.layer.sublayers) {
            
            if ([layer.name compare:layerName] == NSOrderedSame &&
                [layer isKindOfClass:[CALayerLine class]])
            {
                return (CALayerLine*)layer;
            }
        }
    }
    return nil;
}

- (CALayerLine *)addCALayerLineWithName:(NSString *)layerName
                                  Class:(Class)lineClass
                         LineHorizontal:(CALayerLineHorizontal)lineHorizontal
{
    CALayerLine *line = [[lineClass alloc] init];
    line.name = layerName;
    line.lineHorizontal = lineHorizontal;
    [self.layer addSublayer:line];
#if !__has_feature(objc_arc)
    [line release];
#endif
    self.clipsToBounds  = NO;    //超出View Size也会显示
    return line;
}

//增加 View 顶部线条
- (CALayerLine *)addTopLineWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    static NSString *layerName = @"topLineWithWBJView";
    CALayerLine *line = [self findCALineWithName:layerName];
    
    if (!line)
    {
        line    = [self addCALayerLineWithName:layerName
                                         Class:[CALayerLine class]
                                LineHorizontal:CALayerLineHorizontalTop];
    }
    line.frame           = CGRectMake(0, 0, self.frame.size.width, borderWidth);
    
    line.backgroundColor = [borderColor CGColor];
    [line setNeedsLayout];
    
    return line;
}

- (CALayerLine *)addCenterLineWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    return [self addCenterLineWithBorderColor:borderColor
                                  borderWidth:borderWidth
                                        Width:self.frame.size.width + 1];
}


- (CALayerLine *)addCenterLineWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
                                       Width:(CGFloat)width
{
    CGSize size = self.frame.size;
    size.height -= borderWidth;
    size.width = width;
    return [self addLineWithBorderColor:borderColor
                            borderWidth:borderWidth
                                   Size:size
                         LineHorizontal:CALayerLineHorizontalCenter
                                   Name:@"centerLineWithWBJView"];
}

//增加 View 底部线条
- (CALayerLine *)addBottomLineWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    return [self addBottomLineWithBorderColor:borderColor
                                  borderWidth:borderWidth
                                        Width:self.frame.size.width + 1];
}

- (CALayerLine *)addBottomLineWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth Width:(CGFloat)width
{
    CGSize size = self.frame.size;
    size.height -= borderWidth * 0.5;
    size.width = width;
    return [self addLineWithBorderColor:borderColor
                            borderWidth:borderWidth
                                   Size:size
                         LineHorizontal:CALayerLineHorizontalBottom
                                   Name:@"bottomLineWithWBJView"];
}

- (CALayerLine *)addLineWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
                                  Size:(CGSize)size
                        LineHorizontal:(CALayerLineHorizontal)lineHorizontal
                                  Name:(NSString *)layerName
{
    NSString *sName = layerName ? layerName : [NSString stringWithFormat:@"layerLine_%ld", (long)self.layer.sublayers.count];
    CALayerLine *line = [self findCALineWithName:sName];
    
    if (!line)
    {
        line    = [self addCALayerLineWithName: sName
                                         Class:[CALayerLine class]
                                LineHorizontal:lineHorizontal];
        UIEdgeInsets edge = line.expandOfSupperEdgeInsets;
        edge.right = self.frame.size.width - size.width;
        
        line.expandOfSupperEdgeInsets = edge;
        
        line.frame           = CGRectMake(0, size.height, size.width, borderWidth);
        
        
        if (size.width > self.frame.size.width || size.height > self.frame.size.height)
            self.clipsToBounds  = NO;    //超出View Size也会显示
    }
    line.backgroundColor = [borderColor CGColor];
    [line setNeedsLayout];
    return line;
}

//画文本录入框 底部U型线条
- (CALayerLineFocus *)addFocusLineWithFocused:(BOOL)focused
{
    return [self addFocusLineWithFocused:focused Width:self.frame.size.width];
}

- (CALayerLineFocus *)addFocusLineWithFocused:(BOOL)focused Width:(CGFloat)width
{
    UIColor *borderColor = focused ? [UIColor orangeColor] :  [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    
    static NSString *layerName = @"bottomFocalLineWbj";
    CALayerLine *line = [self findCALineWithName:layerName];
    if (!line)
    {
        line = [self addCALayerLineWithName:layerName
                                      Class:[CALayerLineFocus class]
                             LineHorizontal:CALayerLineHorizontalBottom];
        
        line.frame           = CGRectMake(0, 0, width, 4.0);
        
        
        CGFloat offset = -5.0;
        UIEdgeInsets edge = line.expandOfSupperEdgeInsets;
        edge.right  = self.frame.size.width - width;
        if (edge.right == 0)
            edge.right = offset;
        edge.bottom = offset;
        edge.left   = offset;
        
        line.expandOfSupperEdgeInsets = edge;
    }
    line.borderColor     = [borderColor CGColor];
    [line setNeedsDisplay];
    [line setNeedsLayout];
    self.clipsToBounds  = NO;    //超出View Size也会显示
    return (CALayerLineFocus*)line;
}

@end
