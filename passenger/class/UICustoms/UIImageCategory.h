//
//  UIImageCategory.h
//  CategorySample
//
//  Created by yile on 3/29/09.
//  Copyright 2009 Quoord. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^WBJImageCompressFinished)(CGSize thumbnailSize, NSData *thumbnailData, NSData *imageData, NSData *srcImageData, NSInteger tag);

typedef enum WBJImageCompressSrcType
{
    icstNone,      //不需要处理原图
    icstWithSize,  //根据图片大小判断
    icstNeed,      //必须处理原图 原图不压缩
    icstNeedAndCompress   //必须处理原图 但原图进行压缩
}WBJImageCompressSrcType;

@interface UIImage (Read)

//对 imageNamed扩展，不在缓存
+ (UIImage *)imageWithResNamed:(NSString *)name;  // no cache!

@end

@interface UIImage (Resize)

//取图片中间 缩略图
- (UIImage *)thumbnail:(CGSize)thumbnailSize;

- (UIImage *)thumbnailImage:(CGSize)thumbnailSize
       interpolationQuality:(CGInterpolationQuality)quality
                      scale:(CGFloat)scale;

//裁剪 图片中部份位置的内容
- (UIImage *)croppedImage:(CGRect)bounds;


- (UIImage *)imageNewSize:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality
                    scale:(CGFloat)scale;

/*
 支持等比计算
 contentMode 只支持 UIViewContentModeScaleToFill、 UIViewContentModeScaleAspectFit、 UIViewContentModeScaleAspectFill
 */

- (UIImage *)imageNewSize:(CGSize)bounds
              contentMode:(UIViewContentMode)contentMode
     interpolationQuality:(CGInterpolationQuality)quality
                    scale:(CGFloat)scale;

/*
 * 调整图片的 大小
 */
//这会判断 图片大小
- (UIImage *)transForRateWidth:(CGFloat)width
                        Height:(CGFloat)height;

- (UIImage *)transForRateWidth:(CGFloat)width
                        Height:(CGFloat)height
                         Scale:(CGFloat)scale;

- (UIImage *)transformWidth:(CGFloat)width
                     Height:(CGFloat)height;

- (UIImage *)transformWidth:(CGFloat)width
                     Height:(CGFloat)height
                      Scale:(CGFloat)scale;

//转为本机最大显示文件
- (UIImage* )tranToSelf;

//把图片 切到UIView 能显示的大小  thumbnail NO
- (UIImage*)tranImageSizeWithView:(UIView *)view;

- (UIImage*)tranImageSizeWithView:(UIView *)view thumbnail:(BOOL) thumbnail;

@end

@interface UIImage (ImageCategory)

/*
 计算竖图宽不超过max或横图高不超max
 maxSize       最大宽高
 size          图片大小
 */
+ (CGSize)calcSizeWithMax:(CGSize)maxSize
                     size:(CGSize)size;

/*
 根据传入 尺寸计算 显示区域的size
 
 showWidth     显示的标准宽度
 Width         图片的宽
 Height        图片的高度
 */
+ (CGSize)calcImageShowMax:(CGFloat)max
                     width:(CGFloat)tw
                    height:(CGFloat)th
                 minHeight:(CGFloat)minHeight;

+ (CGSize)calcWithImageSize:(CGSize)imageSize
                   baseSize:(CGSize)baseSize
                    maxSize:(CGSize)maxSize
                  thumbnail:(BOOL *)thumbnail;

- (CGSize)calcImageSizeSize:(CGSize)baseSize
                    maxSize:(CGSize)maxSize
                  thumbnail:(BOOL *)thumbnail;

- (void)imageCompressWithSize:(CGSize)baseSize
                      maxSize:(CGSize)maxSize
                 srcImageType:(WBJImageCompressSrcType)srcType
                    takePhoto:(BOOL)takePhoto
                          tag:(NSInteger)tag
                finishedBlock:(WBJImageCompressFinished)finishedBlock;

+ (BOOL)imageBigWithSize:(CGSize)size  scale:(CGFloat)scale;


//把图片 转为 正方向  一般都不需要使用
- (UIImage *)fixOrientation;

//图片 转为 指定颜色 不会渐变
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

//图片 转为 指定颜色 有渐变
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;

+ (UIImage *)convertViewToImage:(UIView *)v;


//将UIColor变换为UIImage
+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size;

// 将UIColor变换为UIImage, 圆矩形
+ (UIImage *)roundedRectImageWithColorTo:(UIColor *)color size:(CGSize)size
                                   radii:(CGFloat)radii;

//根据 UIBezierPath 画不同形状图片
+ (UIImage *)imageWithPath:(UIBezierPath *)path fillColor:(UIColor *)color size:(CGSize)size
               borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
             lineJoinRound:(BOOL)lineJoinRound;

/** 取图片某一像素的颜色 */
- (UIColor *)colorAtPixel:(CGPoint)point;

/** 获得灰度图 */
- (UIImage *)convertToGrayImage;


/** 按给定的方向旋转图片 */
- (UIImage*)rotate:(UIImageOrientation)orient;

/** 垂直翻转 */
- (UIImage *)flipVertical;

/** 水平翻转 */
- (UIImage *)flipHorizontal;

/** 将图片旋转degrees角度 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/** 将图片旋转radians弧度 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

//返回 图片 中二维码字符串
- (NSArray <NSString *> *)stringWithQRCode;

@end
