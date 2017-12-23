//
//  MapFactory.h
//  Dream_Architect_Factory_LBS
//
//  Created by Dream on 2017/5/15.
//  Copyright © 2017年 Tz. All rights reserved.
//

#import <UIKit/UIKit.h>

//工厂职责：创建地图(MapView)
@interface MapFactory : NSObject

@property (nonatomic, copy, readonly) NSString *location;

@property (nonatomic,copy) NSString *detailLocation;

@property (nonatomic, assign, readonly) double longitude;// 经度

@property (nonatomic, assign, readonly) double latitude; // 维度

- (instancetype)init:(int)type;

//自己扩展：写出单例模式(作业)

-(UIView*)getView:(CGRect)frame;

@end
