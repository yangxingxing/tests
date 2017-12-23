//
//  UISubTitleCell.h
//  wBaiJu
//
//  Created by Mac on 16/5/16.
//  Copyright © 2016年 Mac. All rights reserved.


#import "UITableViewCellCustom.h"
typedef NS_ENUM(NSInteger,UITableViewCellMyStyle) {
    UITableViewCellMyStyle1 = 1000 //左边主标题，中间空一段距离，右边副标题
};
//针对cellType的value1和value2
@interface UISubTitleCell : UITableViewCellCustom
-(instancetype)initWithMyStyle:(UITableViewCellMyStyle)style reuseIdentifier:(NSString *)reuseIdentifier leftWidth:(float)leftWidth;
@end
