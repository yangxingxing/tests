//
//  FontSizeSetViews.h
//  
//
//  Created by 邱家楗 on 16/3/30.
//  Copyright © 2016年 tigo soft. All rights reserved.
//

#import "WBJUIFont.h"
#import "UITableViewCustom.h"
#import "FXMarkSlider.h"
#import "HSLocalized.h"

#import <Foundation/Foundation.h>

@interface FontSizeSetViews : NSObject

- (instancetype)initWithSuper:(UIView*)superView;

- (void)layoutSliderSubviews;

@property (nonatomic, readonly) SInt8 fontLevel;

@property (nonatomic, readonly) UIFont* textFont;
@property (nonatomic, readonly) UIFont* detailFont;
@property (nonatomic, readonly) UIFont* timeFont;

@property (nonatomic, readonly) UITableViewCustom *tableView;
@property (nonatomic, readonly) UIView  *bottomView;

@property (nonatomic, readonly) FXMarkSlider *slider;

@property (nonatomic, readonly) UILabel *textSmall;
@property (nonatomic, readonly) UILabel *textStandard;
@property (nonatomic, readonly) UILabel *textMax;

@end
