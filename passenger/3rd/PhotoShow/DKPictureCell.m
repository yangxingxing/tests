//
//  DKPictureCell.m
//  DKMultiPictureBrowser
//
//  Created by 李大宽 on 2017/3/14.
//  Copyright © 2017年 李大宽. All rights reserved.
//

#import "DKPictureCell.h"

@interface DKPictureCell ()<UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation DKPictureCell

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
    }
    return self;
}

/** 设置图片 */
- (void)setPicWithImage:(UIImage *)image {
    // 重置图片尺寸
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.width * image.size.height / image.size.width);
    self.imageView.center = self.scrollView.center;
}

#pragma mark- 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 3;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

#pragma mark- scrollView代理方法
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
