//
//  EWMBackView.h
//  114SD
//
//  Created by 杨星星 on 2017/4/10.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "BaseView.h"
#import <ReactiveObjC.h>

@protocol BackViewDelegate <NSObject>
-(void)closeScreenBrightness;
@end

@interface EWMBackView : BaseView

@property(nonatomic,weak) id<BackViewDelegate> delegate;

@property (nonatomic) CGRect centerFrame;

- (void)show;

- (void)BackViewCloce;

@end
