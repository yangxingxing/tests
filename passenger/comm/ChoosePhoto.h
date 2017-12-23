//
//  ChoosePhoto.h
//  114SDShop
//
//  Created by 杨星星 on 2017/6/10.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChoosePhoto : NSObject

- (instancetype)initWithDelegate:(UIViewController *)delegate;

// 更换头像
- (void)changeIconClick;

//选择头像
-(void)pickImage:(NSNumber*)srcNum;

- (void)chooseSuccessWithImage:(UIImage *)iamge;

@end
