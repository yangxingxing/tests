//
//  AMapLocation.m
//  114SD
//
//  Created by 杨星星 on 2017/4/1.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "AMapLocation.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "User.h"

@interface AMapLocation () <AMapLocationManagerDelegate,AMapSearchDelegate> {
    dispatch_block_t _success,_fail;
    dispatch_block_t _geocodeSuccess,_geocodeFail;
}

@property (nonatomic,strong) AMapLocationManager *locationManager;

@end

static AMapSearchAPI *_geocodesearch = nil;

@implementation AMapLocation

- (instancetype)init {
//    static AMapLocation *location = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        location = [[AMapLocation alloc] init];
//    });
    if (self = [super init]) {
        [self configLocationManager];
        _geocodesearch=[[AMapSearchAPI alloc]init];
        _geocodesearch.delegate=self;
    }
    
    return self;
}

- (void)configLocationManager
{
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        UIAlertView *locationAlert = [[UIAlertView alloc] initWithTitle:@"定位关闭"
                                                                message:@"您当前手机定位服务功能是关闭的,是否去设置"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"设置",nil];
        [locationAlert show];
    }
    // 配置用户key
    [AMapServices sharedServices].apiKey = amapKey;
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setLocatingWithReGeocode:YES];
    
//    self.locationManager.distanceFilter ＝ 200;
    
//    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
//    [self startSerialLocation];
    
}

- (void)startSerialLocationWithSuccess:(dispatch_block_t)success fail:(dispatch_block_t)fail
{
    _success = success;
    _fail = fail;
    //开始定位
    [self.locationManager startUpdatingLocation];
}

- (void)stopSerialLocation
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    if (_fail) {
        _fail();
        _success = nil;
        _fail = nil;
    }
    //定位错误
    SLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    //定位结果
    SLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    User  *usrInfo = [User standardUserInfo];
    usrInfo.longitude = location.coordinate.longitude;
    usrInfo.latitude = location.coordinate.latitude;
    if (usrInfo.longitude > 0 && usrInfo.longitude > 0) {
        if (_success) {
            _success();
            _success = nil;
            _fail = nil;
        }
    } else {
        if (_fail) {
            _fail();
            _success = nil;
            _fail = nil;
        }
    }
    [self stopSerialLocation];
    [self addressWithLatitude:usrInfo.latitude longitude:usrInfo.longitude];
}

//根据经纬度,获取地址
-(void)addressWithLatitude:(double) latitude
                 longitude:(double) longitude
                   success:(dispatch_block_t)success
                      fail:(dispatch_block_t)fail {
    _geocodeSuccess = success;
    _geocodeFail    = fail;
    [self addressWithLatitude:latitude longitude:longitude];
}

//根据经纬度,获取地址
-(void)addressWithLatitude:(double) latitude
                 longitude:(double) longitude
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    regeo.requireExtension = NO;
    regeo.radius = 100;
    //发起逆地理编码
    [_geocodesearch AMapReGoecodeSearch:regeo];
    //    BOOL flag = [_geocodesearch reverseGeoCode:_reverseGeocodeSearchOption];
    
    //    return flag;
}

-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    User  *usrInfo = [User standardUserInfo];
    //准确位置
    SLog(@"%@",response.regeocode.
          formattedAddress);
    usrInfo.location = response.regeocode.formattedAddress;
    AMapAddressComponent *addressComponent = response.regeocode.addressComponent;
    usrInfo.provience = addressComponent.province;
    usrInfo.city = addressComponent.city;
    usrInfo.district = addressComponent.district;
    usrInfo.township = addressComponent.township;
    
//    [User save:usrInfo];
    if (_geocodeSuccess) {
        _geocodeSuccess();
    }
//#if 0
//    //获取到路的信息
//    for (AMapRoad *road in response.regeocode.roads) {
//        
//        NSLog(@"%@",road.name);
//        
//    }
//#endif
//    //附近兴趣热点的信息
//    for (AMapPOI *poi in response.regeocode.pois) {
//        
//        NSLog(@"%@ %@ %@",poi.name,poi.tel,poi.email);
//        
//    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.cancelButtonIndex != buttonIndex) {
        
        BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
        if (canOpenSettings) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }
}


@end
