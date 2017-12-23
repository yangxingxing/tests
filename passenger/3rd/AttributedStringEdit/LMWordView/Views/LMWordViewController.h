//
//  LMWordViewController.h
//  SimpleWord
//
//  Created by Chenly on 16/5/13.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class LMWordView;

@interface LMWordViewController : BaseViewController

@property (nonatomic, strong) LMWordView *textView;

@property (nonatomic,copy) NSString *htmlString;

@property (nonatomic,strong) NSMutableArray *uploadingImage;

- (NSString *)exportHTML;

@end
