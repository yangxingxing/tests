//
//  DKMultiPictureBrowser.h
//  DKMultiPictureBrowser
//
//  Created by 李大宽 on 2017/3/14.
//  Copyright © 2017年 李大宽. All rights reserved.

#import "BaseViewController.h"

@interface DKMultiPictureBrowser : BaseViewController

/**
 pictureArray 存放网络图片的数组
 */
@property(nonatomic, copy) NSArray *pictureArray;

@property (nonatomic,copy) NSArray *imageArray;// 本地图片

@property (nonatomic,assign) NSInteger selectedIndex;

@end
