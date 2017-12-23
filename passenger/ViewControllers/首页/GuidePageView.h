//
//  GuidePageView.h
//  LoveLife
//
//  Created by 杨星 on 16/4/25.
//  Copyright © 2016年 yangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuidePageView : UIView

//点击进入app首页的按钮
@property(nonatomic,strong) UIButton *goInButton;

// 跳过
@property(nonatomic,strong) UIButton *returnButton;

-(id)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray;

- (void)removeBtnClick;

@end
