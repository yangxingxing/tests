#import "UIView+MaskWithPath.h"

@implementation UIView(MaskWithPath)

- (CAShapeLayer *)setMaskWithPath:(UIBezierPath *)path withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    return [self setMaskWithPath:path FillColor:[UIColor whiteColor] withBorderColor:borderColor borderWidth:borderWidth];
}

- (CAShapeLayer *)setMaskWithPath:(UIBezierPath *)path FillColor:(UIColor *)fillColor withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [path CGPath];
    maskLayer.fillColor = [fillColor CGColor];
    maskLayer.frame = self.bounds;
    self.layer.mask = maskLayer;
    
    if (borderColor)
        [self setBorderWithPath:path withBorderColor:borderColor borderWidth:borderWidth
                           Name:@"ShapeLayerName_Adfsdaaa"];
    return maskLayer;
}

- (CAShapeLayer *)setBorderWithPath:(UIBezierPath *)path withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth Name:(NSString*)layerName
{
    return [self setBorderWithPath:path withBorderColor:borderColor borderWidth:borderWidth Name:layerName
                  fillColor:[UIColor clearColor] ToIndex:NSNotFound];
    
}

- (CAShapeLayer *)setBorderWithPath:(UIBezierPath *)path withBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth Name:(NSString *)layerName fillColor:(UIColor *)fillColor ToIndex:(NSUInteger)toIndex
{
    if (borderColor && borderWidth>0) {
        if (!fillColor)
            fillColor = [UIColor clearColor];
        
        CAShapeLayer *maskBorderLayer = [CAShapeLayer layer];
        maskBorderLayer.name        = layerName;
        maskBorderLayer.path        = [path CGPath];
        maskBorderLayer.fillColor   = [fillColor CGColor];
        maskBorderLayer.strokeColor = [borderColor CGColor];
        maskBorderLayer.lineWidth   = borderWidth;
        maskBorderLayer.frame       = self.bounds;
        
        maskBorderLayer.lineCap     = kCALineCapRound;  //线端点类型 圆
        maskBorderLayer.lineJoin    = kCALineJoinRound;  //线连接类型  圆
        
        if (self.layer.sublayers.count > 0)
        {
            for (CALayer *layer in self.layer.sublayers) {
            
                if ([layer.name compare:layerName] == NSOrderedSame &&
                    [layer isKindOfClass:[CAShapeLayer class]])
                {
                    [self.layer replaceSublayer:layer with:maskBorderLayer];
                    return maskBorderLayer;
                }
            }
        }
        
        if (toIndex == NSNotFound || toIndex > self.layer.sublayers.count - 1)
            [self.layer addSublayer:maskBorderLayer];
        else
            [self.layer insertSublayer:maskBorderLayer atIndex:(unsigned)toIndex];
        maskBorderLayer.contentsScale = [[UIScreen mainScreen] scale];
        //maskBorderLayer.delegate      = self;
        self.layer.contentsScale = [[UIScreen mainScreen] scale];
        self.layer.masksToBounds = true;
        return maskBorderLayer;
    }
    return nil;
}

@end
