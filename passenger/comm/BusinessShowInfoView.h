//
//  BusinessShowInfoView.h
//  wBaiJu
//
//  Created by Mac on 16/6/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "wProgressView.h"
#import "UILabelCustom.h"

@interface BusinessShowInfoView : UILabelCustom
+(wShowInfoView *)showInfo:(NSString*)info;
+(wShowInfoView *)showInfoWhiteColor:(NSString*)info;
@end
