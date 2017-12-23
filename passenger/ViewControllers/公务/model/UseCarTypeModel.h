//
//  UseCarTypeModel.h
//  passenger
//
//  Created by 杨星星 on 2017/12/18.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "BaseModel.h"

@interface UseCarTypeModel : BaseModel

@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *detail;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) BOOL selected;

@end
