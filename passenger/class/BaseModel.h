//
//  BaseModel.h
//  114SD
//
//  Created by 杨星星 on 2017/3/23.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

+ (NSArray *)jsonToModelWithArray:(NSArray *)recordlist;

@end
