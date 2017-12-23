//
//  MapFactory.m
//  Dream_Architect_Factory_LBS
//
//  Created by Dream on 2017/5/15.
//  Copyright © 2017年 Tz. All rights reserved.
//

#import "MapFactory.h"
//#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
//#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件



#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "AMapLocation.h"

//声明一次：简单工厂
//工厂模式：多个场景（不断开发总结，优化）
//对象一般不多（用的最多的）
//
@interface MapFactory () <MAMapViewDelegate> {
    AMapLocation *_amap;
}

@property (nonatomic) MAMapView  *mapView;
//@property (nonatomic) BMKMapView *bmkMapView;
@property int type;

@end

@implementation MapFactory

- (instancetype)init:(int)type{
    self = [super init];
    if (self) {
        //枚举也是可以(自己去改)
        _type = type;
        if (_type == 0) {
//            BMKMapManager* _mapManager = [[BMKMapManager alloc]init];
//            // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
//            BOOL ret = [_mapManager start:@"UpZpAkh1ytZ31HQYWnOB0wrGj9gG2a42"  generalDelegate:nil];
//            if (!ret) {
//                NSLog(@"manager start failed!");
//            }
        }else if(_type == 1){
            [AMapServices sharedServices].apiKey = amapKey;
        }
    }
    return self;
}

-(UIView*)getView:(CGRect)frame{
    switch (_type) {
        case 0:
//            if (_mapView == nil) {
//                _mapView = [[BMKMapView alloc]initWithFrame:frame];
//            }
            break;
        case 1:
            _mapView = [[MAMapView alloc] initWithFrame:frame];
            [self createAnnotataionView];
            break;
        case 2:
            _mapView = [[MAMapView alloc] initWithFrame:frame];
            break;
        case 3:
            _mapView = [[MAMapView alloc] initWithFrame:frame];
            break;

            
        default:
            break;
    }
    
    return _mapView;
}

- (void)returnCurrentPointBtnClick:(UIButtonCustom *)btn {
    MAUserLocation *userLocation = _mapView.userLocation;
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    NSLog(@"%@",userLocation.location);
}

#pragma mark - 创建大头针
- (void)createAnnotataionView {
    UIButtonCustom *returnCurrentPointBtn = [MyTools createButtonWithFrame:CGRectMake(10, _mapView.height - 33 - 20 - 64, 33, 33) title:nil titleColor:nil imageName:@"location_icon" backgroundImageName:nil target:self selector:@selector(returnCurrentPointBtnClick:)];
    
    [_mapView addSubview:returnCurrentPointBtn];
    
    User *user = [User standardUserInfo];
    
    MAPointAnnotation * point = [[MAPointAnnotation alloc] init];
    // 设置大头针的显示位置
//    point.coordinate = CLLocationCoordinate2DMake(user.latitude, user.longitude);
    [point setCoordinate:CLLocationCoordinate2DMake(user.latitude, user.longitude)];
    point.lockedToScreen = YES;
    point.lockedScreenPoint = CGPointMake(_mapView.width/2, _mapView.height/2-32);
    
//    [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
    // 设置标题
    point.title = @"当前位置";
//    // 设置副标题
//    point.subtitle = @"明天补课";
    // 将大头针添加到地图上
    [_mapView addAnnotation:point];
//    _mapView.mapType = MAMapTypeStandard;
//    _mapView.showTraffic = YES;
    
    _mapView.scaleOrigin = CGPointMake(30, 64);
    _mapView.delegate = self;
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.zoomLevel = 16;
//    _mapView.rotateEnabled = NO;
//    _mapView.userLocationAccuracyCircle.radius = 100;
//    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading animated:YES];
}

#pragma mark - MAMapViewDelegate
/**
 * @brief 拖动annotation view时view的状态变化
 * @param mapView 地图View
 * @param view annotation view
 * @param newState 新状态
 * @param oldState 旧状态
 */
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState fromOldState:(MAAnnotationViewDragState)oldState {
    [self reloadCenterCoordinateWithMapView:mapView];
}

/**
 * @brief 地图将要发生移动时调用此接口
 * @param mapView       地图view
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction {
    [self reloadCenterCoordinateWithMapView:mapView];
}

/**
 * @brief 地图移动结束后调用此接口
 * @param mapView       地图view
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    [self reloadCenterCoordinateWithMapView:mapView];
}

/**
 * @brief 地图将要发生缩放时调用此接口
 * @param mapView       地图view
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction {
    [self reloadCenterCoordinateWithMapView:mapView];
}

/**
 * @brief 地图缩放结束后调用此接口
 * @param mapView       地图view
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction {
    [self reloadCenterCoordinateWithMapView:mapView];
}

/**
 * @brief 根据anntation生成对应的View
 * @param mapView 地图View
 * @param annotation 指定的标注
 * @return 生成的标注View
 */
#pragma mark -----大头针标注
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{

//    if ([annotation isMemberOfClass:[MAUserLocation class]]) {
//        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
//        MAAnnotationView*annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
//        }
//        UIImage *image = [UIImage imageNamed:@"origin_icon_content"];
//        annotationView.image = image;
//        return annotationView;
//    }

    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAAnnotationView*annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }


//        for (int i = 0; i< self.dataSource.count;i++) {
//
//
//            HYMyPointModel *model = self.dataSource[i];
//
//            if (model.baidu_lng == annotation.coordinate.longitude & model.baidu_lat == annotation.coordinate.latitude) {
//
//                NSURL *url =[NSURL URLWithString:model.store_logo];
//                //2.根据URL获取数据
//                NSData *data =[NSData dataWithContentsOfURL:url];
//                //3.根据数据获取图片
//                UIImage *image =[UIImage imageWithData:data];
//
//                if (image == NULL) {
                    UIImage *image = [UIImage imageNamed:@"origin_icon_content"];
//                }
//
                annotationView.image = image;
//
//                annotationView.layer.borderColor = [UIColor whiteColor].CGColor;
//
//                annotationView.layer.borderWidth = 3 * WidthScale;
//
//                annotationView.frame = CGRectMake(0, 0, 60 * WidthScale, 60 * WidthScale);
//
//                annotationView.layer.cornerRadius = (60 * WidthScale)/ 2;
//
//                annotationView.clipsToBounds = YES;
//            }
//        }
        return annotationView;
    }
    return nil;
}

/**
 * @brief 当mapView新添加annotation views时，调用此接口
 * @param mapView 地图View
 * @param views 新添加的annotation views
 */
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    [self reloadCenterCoordinateWithMapView:mapView];
}

/**
 * @brief 当选中一个annotation view时，调用此接口. 注意如果已经是选中状态，再次点击不会触发此回调。取消选中需调用-(void)deselectAnnotation:animated:
 * @param mapView 地图View
 * @param view 选中的annotation view
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    [self reloadCenterCoordinateWithMapView:mapView];
}

// 点击POI
-(void)mapView:(MAMapView *)mapView didTouchPois:(NSArray *)array {
    MATouchPoi *poi = array.firstObject;
    NSLog(@"点击的位置----%@",poi.name);
}

- (void)reloadCenterCoordinateWithMapView:(MAMapView *)mapView {
    SLog(@"维度=%f，经度=%f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    _latitude  = mapView.centerCoordinate.latitude;
    _longitude = mapView.centerCoordinate.longitude;
    _amap = [AMapLocation new];
    __weak typeof(self) wSelf = self;
    [_amap addressWithLatitude:_latitude longitude:_longitude success:^{
        User  *usrInfo = [User standardUserInfo];
        wSelf.detailLocation = [usrInfo.location stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@%@%@",usrInfo.provience,usrInfo.city,usrInfo.district,usrInfo.township] withString:@""];
    } fail:nil];
}
@end
