//
//  RejectReasonView.m
//  passenger
//
//  Created by 杨星星 on 2017/12/21.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "RejectReasonView.h"
#import "EWMBackView.h"
#import "UITextViewCustom.h"
#import <ReactiveObjC.h>
#import "wComm.h"

@interface RejectReasonView() <UITextViewCustomDelegate> {
    EWMBackView * _view;//退款背景层
//    UIView *_refundView;
    
    UITextViewCustom *_textView;
}

@end

@implementation RejectReasonView

- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREENW - 2*10, 250*ScreenRate)]) {
        self.backgroundColor = textWhiteColor;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        [self createRefundView];
    }
    return self;
}

- (void)createBackView {
    // 创建背景层
    _view = [[EWMBackView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //设置背景色
//    _view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
//    [UIView animateWithDuration:0.2f animations:^{
//        _view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];;
//    }];
    _view.userInteractionEnabled = YES;
    _view.tag = 1234;
}

#pragma mark - 退款相关内容
- (void)createRefundView {
    [self createBackView];
//    _refundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*ScreenRate, 250*ScreenRate)];
//    _refundView.backgroundColor = textWhiteColor;
//    _refundView.layer.cornerRadius = 3;
//    _refundView.layer.masksToBounds = YES;
    [_view addSubview:self];
    
    CGFloat textViewPadding = 20;
    UILabel *tipsLabel = [MyTools createLabelWithFrame:CGRectMake(0, 0, self.width, 30*ScreenRate) text:@"驳回" textColor:textBlackColorPass font:17];
    [self addSubview:tipsLabel];
    
    UILabel *refundReasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(textViewPadding, CGRectGetMaxY(tipsLabel.frame), self.width-2*textViewPadding, 20)];
    refundReasonLabel.font = FontSize(15);
    refundReasonLabel.text = @"请输入驳回理由:";
    refundReasonLabel.textColor = GrayColor;
    [self addSubview:refundReasonLabel];
    
//    UIButtonCustom *closeBtn = [MyTools createButtonWithFrame:CGRectMake(self.width - 40, 0, 40, 40) title:nil titleColor:nil imageName:@"gray_close" backgroundImageName:nil target:nil selector:nil];
//    closeBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
//    @weakify(self);
//    [[closeBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        @strongify(self);
//        [self cancelBtnClick];
//    }];
//    [self addSubview:closeBtn];
    
    // 退款说明框
    _textView = [[UITextViewCustom alloc]initWithFrame:CGRectMake(textViewPadding, CGRectGetMaxY(refundReasonLabel.frame) + 10, self.width - 2*textViewPadding, 100*ScreenRate)];
    _textView.layer.cornerRadius = RadiusIcon;
    _textView.clipsToBounds = YES;
    _textView.returnKeyType =UIReturnKeyDefault;
    _textView.textColor = [UIColor darkGrayColor];
    _textView.autoresizingMask = UIViewAutoresizingNone;
    _textView.maxLen =200;
    _textView.inputEmoji = NO;
    _textView.delegate = self;
    _textView.backgroundColor = textWhiteColor;
    _textView.placeholder = nil;
    [_textView setBorderWithRadius:3 borderColor:UITableViewSeparatorColor];
    [self addSubview:_textView];
    
    UIButtonCustom *confirmBtn = [MyTools createButtonWithFrame:CGRectMake(_textView.x, CGRectGetMaxY(_textView.frame) + 20, (_textView.width-20)/2, 40*ScreenRate) title:@"确定" titleColor:textWhiteColor imageName:nil backgroundImageName:nil target:self selector:@selector(confirmBtnClick)];
    confirmBtn.backgroundColor = CodeBtnBackColor;
    [confirmBtn setBorderWithRadius:3];
//    _confirmBtn = confirmBtn;
    [self addSubview:confirmBtn];
    
    UIButtonCustom *cancleBtn = [MyTools createButtonWithFrame:CGRectMake(CGRectGetMaxX(confirmBtn.frame) + 20, confirmBtn.y, confirmBtn.width, confirmBtn.height) title:@"取消" titleColor:textWhiteColor imageName:nil backgroundImageName:nil target:self selector:@selector(cancelBtnClick)];
//    cancleBtn.centerY = confirmBtn.centerY;
    cancleBtn.backgroundColor = textLightGrayColorPass;
    [cancleBtn setBorderWithRadius:3];
    [self addSubview:cancleBtn];
    
    self.height = CGRectGetMaxY(cancleBtn.frame) + 30;
    self.center = _view.center;//CGPointMake(self.view.centerX, self.view.centerY - 32);
    
    _view.centerFrame = self.frame;
    [_view show];
    
    [_textView becomeFirstResponder];
}

- (void)confirmBtnClick {
    if (_textView.text.length == 0) {
        [Comm showMsg:@"请输入驳回理由"];
        return;
    }
    [self confirmBtnClickWithText:_textView.text];
    [self cancelBtnClick];
}

- (void)confirmBtnClickWithText:(NSString *)text {}

- (void)cancelBtnClick {
    [_view removeFromSuperview];
    _view = nil;
}


@end
