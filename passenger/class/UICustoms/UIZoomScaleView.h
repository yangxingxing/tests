//
//  UIZoomScaleView.h
//  
//
//  Created by 邱家楗 on 16/3/25.
//  Copyright © 2016年 tigo soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIZoomScaleView : UIScrollView
<UIScrollViewDelegate>

@property (nonatomic, readonly) UITapGestureRecognizer *doubleTap;

@property (nonatomic, assign) BOOL canZoomScale;  //default YES

- (void)layoutImageView;

@end
