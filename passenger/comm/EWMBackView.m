//
//  EWMBackView.m
//  114SD
//
//  Created by 杨星星 on 2017/4/10.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "EWMBackView.h"

@implementation EWMBackView

-(void)show{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(BackViewCloce) name:MctShutdown object:nil];
    __weak typeof(self) wSelf = self;
    [UIView animateWithDuration:0.2f animations:^{
        wSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];;
    }];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
}

- (void)BackViewCloce {
    if (self) {
        if (_delegate) {
            [_delegate closeScreenBrightness];   //关闭屏幕亮度
        }
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_centerFrame.size.width > 0) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        if (point.x < _centerFrame.origin.x || point.x > CGRectGetMaxX(_centerFrame) || point.y < _centerFrame.origin.y || point.y > CGRectGetMaxY(_centerFrame)) {
            [self BackViewCloce];
        }
    }
}



@end

