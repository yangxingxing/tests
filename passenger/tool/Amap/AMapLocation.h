//
//  AMapLocation.h
//  114SD
//
//  Created by 杨星星 on 2017/4/1.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import <Foundation/Foundation.h>

static  NSString *amapKey = @"b984fd1fa8568b8115a78c7a544dc188";

@interface AMapLocation : NSObject

- (void)startSerialLocationWithSuccess:(dispatch_block_t)success fail:(dispatch_block_t)fail;

- (void)stopSerialLocation;

//根据经纬度,获取地址
-(void)addressWithLatitude:(double) latitude
                 longitude:(double) longitude
                   success:(dispatch_block_t)success
                      fail:(dispatch_block_t)fail;

@end
