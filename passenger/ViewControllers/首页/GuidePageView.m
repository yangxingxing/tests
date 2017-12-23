
//
//  GuidePageView.m
//  LoveLife
//
//  Created by 杨星 on 16/4/25.
//  Copyright © 2016年 yangyang. All rights reserved.
//

#import "GuidePageView.h"

@interface GuidePageView () <UIScrollViewDelegate>
{
    UIScrollView * _scrollView;
}

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation GuidePageView

-(id)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray
{
    if (self = [super initWithFrame:frame]) {
     //创建scrollView
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
        //设置分页属性
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        //设置contentSize
        _scrollView.contentSize = CGSizeMake(SCREENW * imageArray.count, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        
        
        
        for ( int i = 0; i < imageArray.count; i ++) {
            UIImageView * imageView =  [[UIImageView alloc] initWithFrame:CGRectMake(i * SCREENW, 0, SCREENW, SCREENH)];
            imageView.image = ImageNamed(imageArray[i]);
            //开启用户交互
            imageView.userInteractionEnabled = YES;
            [_scrollView addSubview:imageView];
            
            //跳转按钮
            if (i == imageArray.count - 1) {
                self.goInButton = [UIButtonCustom buttonWithType:UIButtonTypeCustom];
                self.goInButton.frame = CGRectMake(0, SCREENH - 100*ScreenRate, SCREENW, 100*ScreenRate);
                self.goInButton.centerX = SCREENW/2;
                [self.goInButton addTarget:self action:@selector(removeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//                [label setBorderWithRadius:0 borderColor:textOrangeColor borderWidth:1];
                label.centerY = self.goInButton.height/2;
                label.centerX = SCREENW/2;
                label.textColor = textOrangeColor;
//                label.text = @"立即体验";
                label.textAlignment = NSTextAlignmentCenter;
                [self.goInButton addSubview:label];
                
                [imageView addSubview:self.goInButton];
            } else {
                self.returnButton = [MyTools createButtonWithFrame:CGRectMake(SCREENW - 80, 0, 80, 80) title:@"" titleColor:textOrangeColor imageName:nil backgroundImageName:nil target:self selector:@selector(removeBtnClick)];
                //                [self.returnButton setBorderWithRadius:self.returnButton.width/2 borderColor:textOrangeColor];
                [imageView addSubview:self.returnButton];
            }
        }
    }
    
    return self;
}

- (void)removeBtnClick {};

@end
