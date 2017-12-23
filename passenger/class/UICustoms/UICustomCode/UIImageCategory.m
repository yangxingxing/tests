//
//  UIImageCategory.m
//
//
//  Created by yile on 3/29/09.
//  Copyright 2009 Quoord. All rights reserved.
//

#import "UIImageCategory.h"
//#import "wComm.h"


@implementation UIImage (Read)

+ (NSArray *)preferredScales {
    static NSArray *scales;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenScale = [UIScreen mainScreen].scale;
        if (screenScale <= 1) {
            scales = @[@1,@2,@3];
        } else if (screenScale <= 2) {
            scales = @[@2,@3,@1];
        } else {
            scales = @[@3,@2,@1];
        }
        [scales retain];
    });
    return scales;
}

/**
 Add scale modifier to the file name (without path extension),
 From @"name" to @"name@2x".
 
 e.g.
 <table>
 <tr><th>Before     </th><th>After(scale:2)</th></tr>
 <tr><td>"icon"     </td><td>"icon@2x"     </td></tr>
 <tr><td>"icon "    </td><td>"icon @2x"    </td></tr>
 <tr><td>"icon.top" </td><td>"icon.top@2x" </td></tr>
 <tr><td>"/p/name"  </td><td>"/p/name@2x"  </td></tr>
 <tr><td>"/path/"   </td><td>"/path/"      </td></tr>
 </table>
 
 @param scale Resource scale.
 @return String by add scale modifier, or just return if it's not end with file name.
 */
+ (NSString *)string:(NSString *)string appendingNameScale:(CGFloat)scale
{
    if (fabs(scale - 1) <= __FLT_EPSILON__ || string.length == 0 || [string hasSuffix:@"/"]) return [string.copy autorelease];
    return [string stringByAppendingFormat:@"@%@x", @(scale)];
}

//对 imageNamed扩展，不在缓存
+ (UIImage *)imageWithResNamed:(NSString *)name  // no cache!
{
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return nil;
    
    NSString *res = name.stringByDeletingPathExtension;
    NSString *ext = name.pathExtension;
    NSString *path = nil;
    CGFloat scale = 1;
    
    // If no extension, guess by system supported (same as UIImage).
    NSArray *exts = ext.length > 0 ? @[ext] : @[@"", @"png", @"jpeg", @"jpg", @"gif", @"webp", @"apng"];
    NSArray *scales = [self preferredScales];
    for (NSInteger s = 0; s < scales.count; s++) {
        scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = [self string:res appendingNameScale:scale];
        for (NSString *e in exts) {
            path = [[NSBundle mainBundle] pathForResource:scaledName ofType:e];
            if (path) break;
        }
        if (path) break;
    }
    if (path.length == 0) return nil;
    return [self imageWithContentsOfFile:path];
//TODO:可以加入解码
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    if (data.length == 0) return nil;
//    
//    return [[self alloc] initWithData:data scale:scale];
}

@end

@interface UIImage (Resize_Private)
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality
                    scale:(CGFloat)scale;


- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

@end

@implementation UIImage (Resize)

// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(self.CGImage, bounds);
    UIImage *retImg = [UIImage imageWithCGImage:imagePartRef scale:self.scale
                                    orientation:self.imageOrientation];
    CGImageRelease(imagePartRef);
    return retImg;
}

- (UIImage *)thumbnail:(CGSize)thumbnailSize
{
    return [self thumbnailImage:thumbnailSize interpolationQuality:kCGInterpolationLow scale:1];
}

// Returns a copy of this image that is squared to the thumbnail size.
// If transparentBorder is non-zero, a transparent border of the given size will be added around the edges of the thumbnail. (Adding a transparent border of at least one pixel in size has the side-effect of antialiasing the edges of the image when rotating it using Core Animation.)
- (UIImage *)thumbnailImage:(CGSize)thumbnailSize
       interpolationQuality:(CGInterpolationQuality)quality
                      scale:(CGFloat)scale
{
    UIImage *resizedImage = [self imageNewSize:thumbnailSize
                                   contentMode:UIViewContentModeScaleAspectFill
                          interpolationQuality:quality
                                         scale:scale];
    
    // Crop out any part of the image that's larger than the thumbnail size
    // The cropped rect must be centered on the resized image
    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
    CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize.width) / 2),
                                 round((resizedImage.size.height - thumbnailSize.height) / 2),
                                 thumbnailSize.width,
                                 thumbnailSize.height);
    UIImage *croppedImage = [resizedImage croppedImage:cropRect];
    
    return croppedImage;
}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)imageNewSize:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality
                    scale:(CGFloat)scale {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality
                        scale:scale];
}

// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)imageNewSize:(CGSize)bounds
              contentMode:(UIViewContentMode)contentMode
     interpolationQuality:(CGInterpolationQuality)quality
                    scale:(CGFloat)scale{
    if (self.size.width <= bounds.width && self.size.height <= bounds.height)
        return self;
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio   = bounds.height / self.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            ratio = 1;
            //[NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %ld", (long)contentMode];
    }
    
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    
    return [self imageNewSize:newSize interpolationQuality:quality scale:scale];
}

+ (CGSize)calcRateSize:(CGSize)size maxSize:(CGSize)maxSize
{
    if (size.width <= maxSize.width && size.height <= maxSize.height)
        return size;
    CGFloat mw = maxSize.width;
    CGFloat mh = maxSize.height;
    
    
    CGFloat w = size.width;
    CGFloat h = size.height;
    
    CGFloat cs = 0.0;
    if (w > mw || h > mh)
    {
        if (mw / w > mh / h)
            cs = mh / h;
        else
            cs = mw / w;
    }
    if (size.width <= mw && size.height <= mh)
        cs = 1;
    return CGSizeMake(floor(size.width * cs), floor(size.height * cs));
}

- (UIImage *)transForRateWidth:(CGFloat)width Height:(CGFloat)height
{
    return [self transForRateWidth:width Height:height Scale:self.scale];
}

- (UIImage *)transForRateWidth:(CGFloat)width
                        Height:(CGFloat)height
                         Scale:(CGFloat)scale
{
    if (self.size.width <= width && self.size.height <= height)
        return self;
    CGSize size = [UIImage calcRateSize:self.size maxSize:CGSizeMake(width, height)];
    
    return [self transformWidth:size.width Height: size.height Scale:scale];
}

- (UIImage *)transformWidth:(CGFloat)width
                     Height:(CGFloat)height {
    CGFloat scale =  self.scale; //[UIScreen mainScreen].scale;
    
    if (scale >= 2)
        scale = 1.5;
    return [self transformWidth:width Height:height Scale:scale];
    
}

- (UIImage *)transformWidth:(CGFloat)width
                     Height:(CGFloat)height
                      Scale:(CGFloat)scale
{
    if (self.size.width < width && self.size.height < height)
    {
        width  = self.size.width;
        height = self.size.height;
    }
    CGRect rect = CGRectMake(0, 0, width, height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);//这句话确保缩小不失真
    
    [self drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if (!newImage)  //有时会返回nil
        newImage = self;
    
    return newImage;
}

- (UIImage *)tranToSelf
{
    CGSize screen = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = 1.5;
    
    //大图时
    if (self.size.width * self.size.height * self.scale > screen.width * screen.height * 4)
        scale = 1;
    
    CGFloat sw = screen.width * scale; //[UIScreen mainScreen].scale; 即为 2 在iPod 还是会有些卡
    CGFloat sh = screen.height * scale;
    if (self.size.width * self.scale < sw || self.size.height * self.scale < sh)
        return self;
    else
    {
        CGFloat h = self.size.height;
        CGFloat w = self.size.width;
        CGFloat r = 1;
        CGFloat max = sw * 21;
        if (self.size.width < self.size.height * 2)  //竖图
        {
            r = sw / w;
            w = sw;
            h *= r;
            if (h > max)
            {
                r = max / h;
                h = max;
                w = w * r;
            }
        }
        else
        {
            r = sh / h;
            w *= r;
            h = sh;
            if (w > max)
            {
                r = max / w;
                w = max;
                h = h * r;
            }
        }
        
        return [self imageNewSize:CGSizeMake(w, h) interpolationQuality:kCGInterpolationLow scale:scale];
//        CGSize newSize = CGSizeMake(w, h);
//        return [self resizedImage:newSize
//                        transform:[self transformForOrientation:newSize]
//                   drawTransposed:NO
//             interpolationQuality:kCGInterpolationLow
//                            scale:scale];
    }
}

//把图片 切到UIView 能显示的大小
- (UIImage *)tranImageSizeWithView:(UIView *)view
{
    return [self tranImageSizeWithView:view thumbnail:NO];
}

- (UIImage *)tranImageSizeWithView:(UIView *)view thumbnail:(BOOL) thumbnail;
{
    UIImage *img = self;
    CGFloat w = view.frame.size.width * 3.0;
    if (w > 0 && self.size.width > w)
    {
        if (thumbnail)
        {
            thumbnail = self.size.width > self.size.height * 4 || self.size.height > self.size.width * 4;
        }
        if (thumbnail)
        {
            img = [self thumbnail:CGSizeMake(view.frame.size.width * 2.0, view.frame.size.height * 2.0)];
        }
        else
        {
            CGFloat r;
            CGFloat h;
            if (self.size.width < self.size.height) //竖图
            {
                w = MIN(view.frame.size.width * 2.0, self.size.width);
                r = w / self.size.width;
                h = self.size.height * r;
            }
            else //横图
            {
                h = MIN(view.frame.size.width * 2.0, self.size.width);
                r = h / self.size.height;
                w = self.size.width * r;
            }
            
            //有时会返回nil
            img = [self transformWidth:w Height:h];
        }
    }
    return img ? : self;
}

@end

#pragma mark -
#pragma mark Private helper methods

@implementation UIImage (Resize_Private)

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality
                    scale:(CGFloat)scale
{
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width * scale, newSize.height * scale));

    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height * scale, newRect.size.width * scale);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:scale
                                      orientation:UIImageOrientationUp]; //self.imageOrientation
    
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
    }
    
    return transform;
}

@end

@implementation UIImage (ImageCategory)

+ (CGSize)calcSizeWithMax:(CGSize)maxSize
                     size:(CGSize)size
{
    CGFloat tw = size.width;
    CGFloat th = size.height;
    CGFloat r  =  1;
    if (tw > maxSize.width && tw <= th)  //竖
        r = maxSize.width / tw;
    else
        if (th > maxSize.height && tw >= th)
            r = maxSize.height / th;
    
    tw = tw * r;
    th = th * r;
    
    return CGSizeMake(floor(tw), floor(th));
}

/*
 根据传入 尺寸计算 显示区域的size
 
 showWidth     显示的标准宽度
 Width         图片的宽
 Height        图片的高度
 */
+ (CGSize)calcImageShowMax:(CGFloat)max
                     width:(CGFloat)tw
                    height:(CGFloat)th
                 minHeight:(CGFloat)minHeight
{
    CGSize size = [self calcSizeWithMax:CGSizeMake(max, max) size:CGSizeMake(tw, th)];
    CGFloat r = 1.5; //2.0;
    CGFloat maxW = max * r; //2
    if (size.height > maxW || size.width > maxW)
    {
        size.width = size.width / r;
        size.height = size.height / r;
    }
    if (minHeight > 0 && size.height < minHeight)
    {
        r = minHeight / size.height;
        size.height = minHeight;
        size.width = size.width * r;
    }
    return size;
}

+ (CGSize)calcSizeWithMax:(CGFloat)max
                     size:(CGSize)size
                minHeight:(CGFloat)minHeight;
{
    CGFloat tw = size.width;
    CGFloat th = size.height;
    CGFloat r  =  1;
    if (tw > max && tw <= th)
        r = max / tw;
    else
        if (th > max && tw >= th)
            r = max / th;
    
    tw = tw * r;
    th = th * r;
    
    r = 1.5; //2.0;
    CGFloat maxW = max * r; //2
    if (th > maxW || tw > maxW)
    {
        tw = tw / r;
        th = th / r;
    }
    if (minHeight > 0 && th < minHeight)
    {
        r = minHeight / th;
        th = minHeight;
        tw = tw * r;
    }
    
    return CGSizeMake(floor(tw), floor(th));
}

+ (CGSize)exchangeSize:(CGSize)size
{
    CGFloat tem = size.width;
    size.width  = size.height;
    size.height = tem;
    return size;
}

+ (CGSize)calcWithImageSize:(CGSize)imageSize
                   baseSize:(CGSize)baseSize
                    maxSize:(CGSize)maxSize
                  thumbnail:(BOOL *)thumbnail
{
    CGFloat w = imageSize.width;
    CGFloat h = imageSize.height;
    
    //CGFloat tw = 200.0;
    //CGFloat th = 266.0;
    CGSize bs = baseSize;
    if (w > h) //横图
    {
        if (bs.width < bs.height)
        {
            bs = [self exchangeSize:baseSize];
        }
        CGFloat rate = bs.height / h;
        bs.width = w * rate;
    }
    else
    {
        if (bs.width > bs.height)
        {
            bs = [self exchangeSize:baseSize];
        }
        
        CGFloat rate = bs.width / w;
        bs.height = h * rate;
    }
    
    *thumbnail = NO;
    if (bs.height > maxSize.height && maxSize.height > 0)
    {
        bs.height = maxSize.height;
        CGFloat rate = bs.height / h;
        w = w * rate;
        *thumbnail = bs.height > w * 4;
        if (!thumbnail)
            bs.width = w;
    }
    
    if (bs.width > maxSize.width && maxSize.width > 0)
    {
        bs.width = maxSize.width;
        CGFloat rate = bs.width / w;
        h *= rate;
        *thumbnail = bs.width > h * 4;
        
        if (imageSize.height > 60 && h < 60)
        {
            h = 60;
            rate = bs.height / 60.0;
            bs.width = bs.width * rate;
            if (bs.width > maxSize.width)
                bs.width = maxSize.width;
        }
        
        bs.height = h;
    }
    
    if (w > 60.0 && bs.width < 60.0)
    {
        bs.width = 60.0;
        CGFloat rate = bs.width / 60.0;
        bs.height = bs.height * rate;
        if (bs.height > maxSize.height)
            bs.height = maxSize.height;
    }
    return bs;
}

- (CGSize)calcImageSizeSize:(CGSize)baseSize
                    maxSize:(CGSize)maxSize
                  thumbnail:(BOOL *)thumbnail
{
    return [UIImage calcWithImageSize:self.size
                             baseSize:baseSize
                              maxSize:maxSize
                            thumbnail:thumbnail];
}

- (void)imageCompressWithSize:(CGSize)baseSize
                      maxSize:(CGSize)maxSize
                 srcImageType:(WBJImageCompressSrcType)srcType
                    takePhoto:(BOOL)takePhoto
                          tag:(NSInteger)tag
                finishedBlock:(WBJImageCompressFinished)finishedBlock
{
    __block CGSize thumbnailSize;
    __block NSData *thumbnailData = nil;
    __block NSData *imageData     = nil;
    __block NSData *srcImageData  = nil;
    WBJImageCompressFinished finishDo = [finishedBlock copy];
    
    //此处不需要 调用[self fixOrientation], 之前要调用是因为 之的 [transformWidth: Height:] 会把图片画倒了
    //拍照 用transformWidth 会卡
    UIImage* newImg = takePhoto ? [self fixOrientation] : self;
    
    if (srcType == icstWithSize && (newImg.size.width > 1024 || newImg.size.height > 2048))
        srcType = icstNeedAndCompress;

    dispatch_group_t dispatchGroup = dispatch_group_create();
    
    dispatch_queue_t dispatchQueue1 = dispatch_queue_create("tigo.com.image.Compress1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(dispatchGroup, dispatchQueue1, ^(){
        SLog(@"begin thumbnail image");
//        int64_t tickCount = 0;
        UIImage *image = newImg;
        CGFloat w = image.size.width;
        CGFloat h = image.size.height;
        
        CGFloat maxWidth = 1242;
        if (h > w && w > maxWidth)
        {
            CGFloat r = maxWidth / w;
            h = h * r;
            w = maxWidth;
            //            tickCount = [Comm tickCount];
            image = [image transformWidth:w Height:h Scale:1];
            //            SLog(@"trans %lld", [Comm tickCount] - tickCount);
        }
        
        BOOL thumbnail = NO;
        thumbnailSize = [newImg calcImageSizeSize:baseSize maxSize:maxSize thumbnail:&thumbnail];
        
        UIImage *iconImage = newImg;
        if (newImg.size.width > thumbnailSize.width || newImg.size.height > thumbnailSize.height)
        {
            //            tickCount = [Comm tickCount];
            iconImage = thumbnail ? [newImg thumbnail:thumbnailSize] :
            [newImg transformWidth: thumbnailSize.width Height: thumbnailSize.height];
            //            SLog(@"trans thumbnail %lld", [Comm tickCount] - tickCount);
        }
//        tickCount = [Comm tickCount];
        thumbnailData = UIImageJPEGRepresentation(iconImage, 0.3);
//        SLog(@"thumbnailData %lld", [Comm tickCount] - tickCount);
//        tickCount = [Comm tickCount];
        imageData     = UIImageJPEGRepresentation(image, srcType > icstNone ? 0 : 0.3);
        
#if ! __has_feature(objc_arc)
        [thumbnailData retain];
        [imageData retain];
#endif

//        SLog(@"imageData %lld", [Comm tickCount] - tickCount);
    });
    
    dispatch_queue_t dispatchQueue2 = nil;
    if (srcType > icstNone)
    {
        srcImageData = nil;
        dispatchQueue2 = dispatch_queue_create("tigo.com.image.Compress2", DISPATCH_QUEUE_CONCURRENT);
        dispatch_group_async(dispatchGroup, dispatchQueue2, ^(){
            SLog(@"src image");
//            int64_t tickCount = [Comm tickCount];
            srcImageData = UIImageJPEGRepresentation(newImg, 0.5);
//            SLog(@"srcData1 %lld", [Comm tickCount] - tickCount);
          
            if ((srcType == icstNeedAndCompress) ||
                (srcType == icstWithSize && srcImageData.length > 1024 * 130)) //130kb
            {
                CGFloat r = 0.0;
                if (srcImageData.length <= 1024 * 700)
                    ;
                else
                    if (srcImageData.length > 1024 * 1024 + 500)
                        r = 0.1;
                    else
                        if (srcImageData.length > 1024 * 1000) //1000kb
                            r = 0.2;
                        else
                            if (srcImageData.length > 1024 * 900) //900kb
                                r = 0.3;
                            else
                                if (srcImageData.length > 1024 * 800) //800kb
                                    r = 0.4;
                if (r > 0)
                {
                    srcImageData = UIImageJPEGRepresentation(newImg, r);
                    //                        SLog(@"srcData2 %lld", [Comm tickCount] - tickCount);
                }
            }
#if ! __has_feature(objc_arc)
            [srcImageData retain];
#endif
        });
    }

    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
        if (finishDo)
        {
            finishDo(thumbnailSize, thumbnailData, imageData, srcImageData, tag);
        }
#if ! __has_feature(objc_arc)
        [finishDo release];
        [thumbnailData release];
        [imageData release];
        if (srcImageData)
            [srcImageData release];
#endif
        thumbnailData = nil;
        imageData     = nil;
        srcImageData  = nil;
    });
#if ! __has_feature(objc_arc)
    if (dispatchQueue2)
        dispatch_release(dispatchQueue2);
    dispatch_release(dispatchQueue1);
    dispatch_release(dispatchGroup);
#endif
}

//调用过 [image fixOrientation] 调整过方向的Image 才需要调用此函数.
- (UIImage *)transformCheckWidth:(CGFloat)width
                          Height:(CGFloat)height
                           Scale:(CGFloat)scale;
{
    CGRect rect = CGRectMake(0, 0, width, height);
    
//    CGImageRef imageRef = self.CGImage;
//    CGContextRef bitmap = CGBitmapContextCreate(NULL,
//                                                width,
//                                                height,
//                                                CGImageGetBitsPerComponent(imageRef),
//                                                4*width,
//                                                CGImageGetColorSpace(imageRef),
//                                                (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, width, height,
                                                CGImageGetBitsPerComponent(self.CGImage), 0,
                                                CGImageGetColorSpace(self.CGImage),
                                                CGImageGetBitmapInfo(self.CGImage));
    
    //如果 UIImage 之前调用过   [image fixOrientation]
//    BOOL fixOrientation = self.imageOrientation == UIImageOrientationUp;
//    if (fixOrientation)
//        CGContextDrawImage(bitmap, rect, imageRef); //经测试 drawInRect 性能与这差1毫秒
//    else
//    {
        //drawInRect 的性能比较低
        UIGraphicsPushContext(bitmap);
        [self drawInRect:rect];  //CGContextDrawImage(bitmap, drawRect, imageRef);
        UIGraphicsPopContext();
//    }
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref
                        scale: self.scale
                  orientation:self.imageOrientation];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return result;
}
+ (BOOL)imageBigWithSize:(CGSize)size scale:(CGFloat)scale
{
    CGSize screen = [[UIScreen mainScreen] bounds].size;
    return size.width * size.height * scale > screen.width * screen.height * ([UIScreen mainScreen].scale + 2);
}

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    //
    //    return [UIImage imageWithCGImage:self.CGImage scale:self.scale
    //                         orientation:[self flipVertical]];
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImageOrientation)flipHorizontalOrientation
{
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
            return UIImageOrientationUpMirrored;
        case UIImageOrientationDown:
            return UIImageOrientationDownMirrored;
        case UIImageOrientationLeft:
            return UIImageOrientationRightMirrored;
        case UIImageOrientationRight:
            return UIImageOrientationLeftMirrored;
        case UIImageOrientationUpMirrored:
            return UIImageOrientationUp;
        case UIImageOrientationDownMirrored:
            return UIImageOrientationDown;
        case UIImageOrientationLeftMirrored:
            return UIImageOrientationRight;
        case UIImageOrientationRightMirrored:
            return UIImageOrientationLeft;
        default:
            break;
    }
    return UIImageOrientationUpMirrored;
}

/*
 * @brief flip vertical
 */
- (UIImageOrientation)flipVerticalOrientation
{
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
            return UIImageOrientationDownMirrored;
        case UIImageOrientationDown:
            return UIImageOrientationUpMirrored;
        case UIImageOrientationLeft:
            return UIImageOrientationLeftMirrored;
        case UIImageOrientationRight:
            return UIImageOrientationRightMirrored;
        case UIImageOrientationUpMirrored:
            return UIImageOrientationDown;
        case UIImageOrientationDownMirrored:
            return UIImageOrientationUp;
        case UIImageOrientationLeftMirrored:
            return UIImageOrientationLeft;
        case UIImageOrientationRightMirrored:
            return UIImageOrientationRight;
        default:
            break;
    }
    return UIImageOrientationUp;
}

+ (UIImage *)convertViewToImage:(UIView *)v {
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 * 将UIColor变换为UIImage, 矩形 方
 **/
+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size
{
    CGRect rect = CGRectZero;
    rect.size = size;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    [color set];
    UIRectFill(rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


// 将UIColor变换为UIImage, 圆矩形
+ (UIImage *)roundedRectImageWithColorTo:(UIColor *)color size:(CGSize)size
                                   radii:(CGFloat)radii
{
    CGRect rect = CGRectZero;
    rect.size = size;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    [[UIColor clearColor] set];
    UIRectFill(rect);
    
    
    CGSize radiiSize   = CGSizeMake(radii, radii);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect: rect
                                               byRoundingCorners: UIRectCornerAllCorners
                                                     cornerRadii: radiiSize];
    [color set];
    [path fill];
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//根据 UIBezierPath 画不同形状图片
+ (UIImage *)imageWithPath:(UIBezierPath *)path
                 fillColor:(UIColor *)color
                      size:(CGSize)size
               borderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth
             lineJoinRound:(BOOL)lineJoinRound
{
    CGRect rect = CGRectZero;
    rect.size =size;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPathRef pathRef = path.CGPath;
    
    if (borderWidth > 0 && borderColor)
    {
        if (lineJoinRound)
        {
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetLineJoin(context, kCGLineJoinRound);
        }
        else
        {
            CGContextSetLineCap(context, kCGLineCapButt);
            CGContextSetLineJoin(context, kCGLineJoinMiter);
        }
        
        CGContextAddPath(context, pathRef);
        
        CGContextSetLineWidth(context, borderWidth);
        
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextStrokePath(context);
    }
    CGContextAddPath(context, pathRef);
    CGContextClip(context);
    
    CGContextSetLineWidth(context, 0);
    // Fill the color for backgroundColor
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//把图片
- (UIImage *)imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

/** 取图片某一像素的颜色 */
- (UIColor *)colorAtPixel:(CGPoint)point
{
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point))
    {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.CGImage;
    NSUInteger width = self.size.width;
    NSUInteger height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = {0, 0, 0, 0};
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/** 获得灰度图 */
- (UIImage *)convertToGrayImage
{
    int width = self.size.width;
    int height = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL)
    {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), self.CGImage);
    CGImageRef contextRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:contextRef];
    CGContextRelease(context);
    CGImageRelease(contextRef);
    
    return grayImage;
}

//由角度转换弧度
#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)
//由弧度转换角度
#define kRadianToDegrees(radian) (radian * 180.0) / (M_PI)

/** 按给定的方向旋转图片 */
- (UIImage *)rotate:(UIImageOrientation)orient
{
    CGRect bnds = CGRectZero;
    UIImage* copy = nil;
    CGContextRef ctxt = nil;
    CGImageRef imag = self.CGImage;
    CGRect rect = CGRectZero;
    CGAffineTransform tran = CGAffineTransformIdentity;
    
    rect.size.width = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    
    bnds = rect;
    
    switch (orient)
    {
        case UIImageOrientationUp:
            return self;
            
        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeft:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height,
                                                    rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        default:
            return self;
    }
    
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;
            
        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }
    
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}

/** 垂直翻转 */
- (UIImage *)flipVertical
{
    return [self rotate:UIImageOrientationDownMirrored];
}

/** 水平翻转 */
- (UIImage *)flipHorizontal
{
    return [self rotate:UIImageOrientationUpMirrored];
}

/** 将图片旋转弧度radians */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width / 2, rotatedSize.height / 2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, radians);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
#if ! __has_feature(objc_arc)
    [rotatedViewBox release];
#endif
    
    return newImage;
}

/** 将图片旋转角度degrees */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    return [self imageRotatedByRadians:kDegreesToRadian(degrees)];
}

/** 交换宽和高 */
static CGRect swapWidthAndHeight(CGRect rect)
{
    CGFloat swap = rect.size.width;
    
    rect.size.width = rect.size.height;
    rect.size.height = swap;
    
    return rect;
}

//返回 图片 中二维码字符串
- (NSArray <NSString *> *)stringWithQRCode
{
    if(self && [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ){
        //1. 初始化扫描仪，设置设别类型和识别质量
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                                  context:nil
                                                  options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
        //2. 扫描获取的特征组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage: self.CGImage]];
        //3. 获取扫描结果
        if (features.count > 0)
        {
            NSMutableArray <NSString *>* results = [NSMutableArray arrayWithCapacity:features.count];
            for (CIQRCodeFeature *feature in features) {
                [results addObject:feature.messageString];
            }
            return results;
        }
    }
    return nil;
}

@end
