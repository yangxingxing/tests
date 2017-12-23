//
//  CustomShareView.m
//  FengShui
//
//  Created by 杨星星 on 2017/10/16.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "CustomShareView.h"
#import "EWMBackView.h"
#import <ShareSDKExtension/ShareSDK+Extension.h>

@implementation CustomShareView
{
    UIView *_shareView;
    float _saveHeight;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideShareView:)];
        [self addGestureRecognizer:tap];
        
        _shareView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, SCREENW, 100)];
        _shareView.backgroundColor = [UIColor whiteColor];
        _shareView.autoresizingMask = UIAutoSizeMaskBottom;
        [self addSubview:_shareView];
        
        UILabel *tipsLabel = [MyTools createLabelWithFrame:CGRectMake(leftSpace, UITableViewCellCustomLeftX, 120, 20) text:@"推荐有奖" textColor:textBlackColor font:16];
        [_shareView addSubview:tipsLabel];
        
        UILabel *contentsLabel = [MyTools createLabelWithFrame:CGRectMake(tipsLabel.x, CGRectGetMaxY(tipsLabel.frame) + 5, SCREENW - 2*leftSpace, 20) text:@"每成功推荐一位用户注册，即奖励5元优惠券红包" textColor:textLightGrayColor font:14];
        [_shareView addSubview:contentsLabel];
        
        contentsLabel.textAlignment = tipsLabel.textAlignment = NSTextAlignmentLeft;
        
        UIButtonCustom *cancelBtn = [MyTools createButtonWithFrame:CGRectMake(_shareView.width - 50 - leftSpace, tipsLabel.y, 50, 30) title:@"取消" titleColor:GrayColor imageName:nil backgroundImageName:nil target:self selector:@selector(hideShareView:)];
        [_shareView addSubview:cancelBtn];
        
        UIView *shareBtnView = [self createShareeSubviews];
        shareBtnView.y = CGRectGetMaxY(contentsLabel.frame) + 20;
        [_shareView addSubview:shareBtnView];
        
        _saveHeight = _shareView.height = CGRectGetMaxY(shareBtnView.frame) + leftSpace;
    }
    return self;
}

- (UIView *)createShareeSubviews {
    CGFloat spaceWidth = 25*ScreenRate;
    CGFloat width = (SCREENW - 5*spaceWidth)/4;
    
    _shareAry = [NSMutableArray array];
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeWechat]) {
        [_shareAry addObject:@{@"title":@"微信好友",@"image":@"share_wechat.jpg",@"tag":[NSString stringWithFormat:@"%ld",(long)SharePlatTypeWX]}];
        [_shareAry addObject:@{@"title":@"朋友圈",@"image":@"share_CircleOfFriend.jpg",@"tag":[NSString stringWithFormat:@"%ld",(long)SharePlatTypeWXCircle]}];
    }
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeQQ]) {
        [_shareAry addObject:@{@"title":@"QQ好友",@"image":@"share_QQ.jpg",@"tag":[NSString stringWithFormat:@"%ld",(long)SharePlatTypeQQ]}];
    }
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeSinaWeibo]) {
        [_shareAry addObject:@{@"title":@"新浪微博",@"image":@"share_weibo.jpg",@"tag":[NSString stringWithFormat:@"%ld",(long)SharePlatTypeSina]}];
    }
    
    UIView *shareBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, width+30)];
    for (int i = 0; i < _shareAry.count; i++) {
        NSDictionary *dict = _shareAry[i];
        UIButtonCustom *btn = [MyTools createButtonWithFrame:CGRectMake(spaceWidth + i%4*(width + spaceWidth), 0, width, width+30) title:dict[@"title"] titleColor:textBlackColor imageName:dict[@"image"] backgroundImageName:nil target:self selector:@selector(shareBtnClick:)];
        btn.tag = [dict[@"tag"] integerValue];
        btn.imageViewFrame = CGRectMake(0, 0, width, width);
        btn.titleLabelFrame = CGRectMake(0, width, width, 30);
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = FontSize(15);
        
        [shareBtnView addSubview:btn];
    }
    return shareBtnView;
}

- (void)shareBtnClick:(UIButtonCustom *)btn {
    SSDKPlatformType platform = SSDKPlatformTypeUnknown;
    switch (btn.tag) {
        case SharePlatTypeWX: //微信好友
            platform = SSDKPlatformSubTypeWechatSession;
            break;
        case SharePlatTypeWXCircle: //微信朋友圈
            platform = SSDKPlatformSubTypeWechatTimeline;
            break;
        case SharePlatTypeQQ: //QQ
            platform = SSDKPlatformSubTypeQQFriend;
            break;
        case SharePlatTypeSina: //新浪
            platform = SSDKPlatformTypeSinaWeibo;
            break;
            
        default:
            break;
    }

    if (_shareDelegate && [_shareDelegate respondsToSelector:@selector(shareActionWithType:)]) {
        [_shareDelegate shareActionWithType:platform];
    }
}

-(void)hideShareView:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.33 animations:^{
        CGRect cRect = _shareView.frame;
        cRect.origin.y = self.frame.size.height;
        _shareView.frame = cRect;
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

-(void)displayView{
    [UIView animateWithDuration:0.33 animations:^{
        CGRect cRect = _shareView.frame;
        cRect.origin.y = self.frame.size.height-_saveHeight;
        _shareView.frame = cRect;
    }];
}

@end
