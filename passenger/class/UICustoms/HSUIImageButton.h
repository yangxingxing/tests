//
//  HSUIImageButton.h
//  
//
//  Created by apple on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HSUIImageButton;


@protocol HSUIImageButtonDelegate<NSObject>

- (void)imageButtonClick:(HSUIImageButton *)imageButton;

@optional
- (void)imageButtonLongClick:(HSUIImageButton *)imageButton;

- (void)imageButton:(HSUIImageButton *)imageButton LongPressGestures:(UILongPressGestureRecognizer *)paramSender;

@end


@interface HSUIImageButton : UIImageView

@property (nonatomic, assign) NSObject<HSUIImageButtonDelegate> *delegate;

@end


