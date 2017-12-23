//
//  BusinessShowInfoView.m
//  wBaiJu
//
//  Created by Mac on 16/6/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BusinessShowInfoView.h"
//#import "NSString+addition.h"


@implementation BusinessShowInfoView
static wShowInfoView *infoView = nil;

+(wShowInfoView *)showInfo:(NSString*)info{
    if (![info isKindOfClass:[NSString class]]) {
        info = SStringEmpty;
    }
    dispatch_main_sync_safe(^{
        
        infoView = [[wShowInfoView alloc] initWithFrame:CGRectZero];
        [infoView showInfo:info font:UITextFont];
        infoView.backgroundColor    = [[UIColor blackColor] colorWithAlphaComponent:0.7];//[UIColor darkGrayColor];
        infoView.textColor          = [UIColor whiteColor];
        
        infoView.layer.borderColor  = [[[UIColor blackColor] colorWithAlphaComponent:0.8] CGColor];
        infoView.frame              = CGRectInset(infoView.frame, -10, -5); //原来边框 5，相应加大边框
        //infoView.layer.cornerRadius = infoView.font.lineHeight / 2.0 + 10;
        infoView.layer.cornerRadius = infoView.frame.size.height * 0.5;
        infoView.center             = infoView.superview.center;
#if ! __has_feature(objc_arc)
        [infoView release];
#endif
        
    });
    
     return infoView;
//    BusinessShowInfoView *lab = [[BusinessShowInfoView alloc]init];
//    lab.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
//    lab.textColor = [UIColor whiteColor];
//    lab.text = info;
//    lab.font = UITextFont;
//    lab.layer.cornerRadius = UITextFont.lineHeight/2+10;
//    lab.numberOfLines = 0;
//    lab.layer.masksToBounds = YES;
//    lab.textEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
////    lab.textAlignment = NSTextAlignmentCenter;
//    UIWindow *keyWindow = [UIApplication sharedApplication].windows.lastObject;
//    [keyWindow addSubview:lab];
////    CGSize size = [lab.text calcSizeWithFont:lab.font constrainedToSize:CGSizeMake(200, MAXFLOAT)];
//    CGSize size = [lab sizeThatFits:CGSizeMake(200, MAXFLOAT)];
//    lab.size = CGSizeMake(size.width+30, size.height+20);
//    lab.center = keyWindow.center;
//    
//    [lab performSelector:@selector(closeView) withObject:nil afterDelay:1];
    
}

+(wShowInfoView *)showInfoWhiteColor:(NSString*)info{
    
    dispatch_main_sync_safe(^{
        
        infoView = [[wShowInfoView alloc] initWithFrame:CGRectZero];
        [infoView showInfo:info font:UITextFont];
        infoView.backgroundColor    = [UIColor whiteColor];
        infoView.textColor          = [UIColor blackColor];
        infoView.layer.borderColor  = [UIColor whiteColor].CGColor;
        infoView.frame              = CGRectInset(infoView.frame, -10, -5); //原来边框 5，相应加大边框
        //infoView.layer.cornerRadius = infoView.font.lineHeight / 2.0 + 10;
        infoView.layer.cornerRadius = infoView.frame.size.height * 0.5;
        //infoView.center             = infoView.superview.center;
        infoView.y = (SCREENH - infoView.height)/2.0+15;
#if ! __has_feature(objc_arc)
        [infoView release];
#endif
        
    });
    
    return infoView;
}

//-(void)closeView{
//        __weak typeof(self)wSelf = self;
//        [UIView animateWithDuration:0.5 animations:^{
//            wSelf.alpha = 0.1;
//        }completion:^(BOOL finished) {
//            [wSelf removeFromSuperview];
//        }];
//}

@end
