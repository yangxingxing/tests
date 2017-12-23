//
//  SystemAuthority.m
//  114SD
//
//  Created by 杨星星 on 2017/3/30.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "SystemAuthority.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
@import CoreTelephony;
#import <UserNotifications/UserNotifications.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <EventKit/EventKit.h>

//手机系统版本号
#define SYSTEMVERSION [[[UIDevice currentDevice]systemVersion]floatValue]


@implementation SystemAuthority

- (BOOL)CameraAuthority
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        [self showAlertWithType:systemAuthorityCamera];
        return NO;
    }
    return YES;
}


- (BOOL)PhotoLibraryAuthority
{
    if (SYSTEMVERSION >= 8.0) {
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        if(authStatus == PHAuthorizationStatusDenied || authStatus == PHAuthorizationStatusRestricted) {
            // 未授权
            [self showAlertWithType:systemAuthorityPhotoLibrary];
            return NO;
        }
    }
    else if (SYSTEMVERSION >= 6.0 && SYSTEMVERSION < 8.0)
    {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if(authStatus == ALAuthorizationStatusDenied || authStatus == ALAuthorizationStatusRestricted) {
            // 未授权
            [self showAlertWithType:systemAuthorityPhotoLibrary];
            return NO;
        }
    }
    return YES;
}

- (BOOL)notificationAuthority
{
    if (SYSTEMVERSION>=8.0f)
    {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types)
        {
            [self showAlertWithType:systemAuthorityNotifacation];
            return NO;
        }
        
    }
    else
    {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone == type){
            [self showAlertWithType:systemAuthorityNotifacation];
            return NO;
        }
    }
    return YES;
}

- (BOOL)netWorkAuthority
{
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    if (state == kCTCellularDataRestricted) {
        [self showAlertWithType:systemAuthorityNetwork];
        return NO;
    }
    return YES;
}

- (BOOL)audioAuthority
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        [self showAlertWithType:systemAuthorityAudio];
        return NO;
    }
    return YES;
}

- (BOOL)locationAuthority
{
    BOOL isLocation = [CLLocationManager locationServicesEnabled];
    if (!isLocation) {
        CLAuthorizationStatus CLstatus = [CLLocationManager authorizationStatus];
        if (CLstatus == kCLAuthorizationStatusDenied || CLstatus == kCLAuthorizationStatusDenied) {
            [self showAlertWithType:systemAuthorityLocation];
            return NO;
        }
    }
    return YES;
}

- (BOOL)addressBookAuthority
{
    if (SYSTEMVERSION >= 9.0) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted)
        {
            [self showAlertWithType:systemAuthorityAddressBook];
            return NO;
            
        }
    }
    else
    {
        ABAuthorizationStatus ABstatus = ABAddressBookGetAuthorizationStatus();
        if (ABstatus == kABAuthorizationStatusDenied || ABstatus == kABAuthorizationStatusRestricted)
        {
            [self showAlertWithType:systemAuthorityAddressBook];
            return NO;
        }
    }
    return YES;
}

- (BOOL)calendarAuthority
{
    EKAuthorizationStatus EKstatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if (EKstatus == EKAuthorizationStatusDenied || EKstatus == EKAuthorizationStatusRestricted)
    {
        [self showAlertWithType:systemAuthorityCalendar];
        return NO;
    }
    return YES;
}

- (BOOL)reminderAuthority
{
    EKAuthorizationStatus EKstatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    if (EKstatus == EKAuthorizationStatusDenied || EKstatus == EKAuthorizationStatusRestricted)
    {
        [self showAlertWithType:systemAuthorityReminder];
        return NO;
    }
    return YES;
}

- (void)showAlertWithType:(systemAuthorityType)type
{
    NSString *title;
    NSString *msg;
    switch (type) {
        case systemAuthorityCamera:
            title = @"未获得授权使用相机";
            msg = @"请在设备的 设置-隐私-相机 中打开。";
            break;
        case systemAuthorityPhotoLibrary:
            title = @"未获得授权使用相册";
            msg = @"请在设备的 设置-隐私-照片 中打开。";
            break;
        case systemAuthorityNotifacation:
            title = @"未获得授权使用推送";
            msg = @"请在设备的 设置-隐私-推送 中打开。";
            break;
        case systemAuthorityNetwork:
            title = @"未获得授权使用网络";
            msg = @"请在设备的 设置-隐私-网络 中打开。";
            break;
        case systemAuthorityAudio:
            title = @"未获得授权使用麦克风";
            msg = @"请在设备的 设置-隐私-麦克风 中打开。";
            break;
        case systemAuthorityLocation:
            title = @"未获得授权使用定位";
            msg = @"请在设备的 设置-隐私-定位 中打开。";
            break;
        case systemAuthorityAddressBook:
            title = @"未获得授权使用通讯录";
            msg = @"请在设备的 设置-隐私-通讯录 中打开。";
            break;
        case systemAuthorityCalendar:
            title = @"未获得授权使用日历";
            msg = @"请在设备的 设置-隐私-日历 中打开。";
            break;
        case systemAuthorityReminder:
            title = @"未获得授权使用备忘录";
            msg = @"请在设备的 设置-隐私-备忘录 中打开。";
            break;
        default:
            break;
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即前往", nil];
    alertView.delegate = self;
    [alertView show];
    alertView.tag = type;
}

#pragma mark -- AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //跳转到设置界面，让用户开启权限
        NSURL *url;
        if(SYSTEMVERSION >= 8.0)
        {
            //iOS8 以后
            url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url])
                [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            //iOS8 之前
            //以下方法暂未测试
            switch (alertView.tag) {
                case systemAuthorityCamera:
                    url = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
                    break;
                case systemAuthorityPhotoLibrary:
                    url = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
                    break;
                case systemAuthorityNetwork:
                    url = [NSURL URLWithString:@"prefs:root=General&path=Network"];
                    break;
                case systemAuthorityAudio:
                    url = [NSURL URLWithString:@"prefs:root=Privacy&path=Audio"];
                    break;
                case systemAuthorityLocation:
                    url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
                    break;
                case systemAuthorityAddressBook:
                    url = [NSURL URLWithString:@"prefs:root=Privacy&path=AddressBook"];
                    break;
                case systemAuthorityCalendar:
                    url = [NSURL URLWithString:@"prefs:root=Privacy&path=Calendar"];
                    break;
                case systemAuthorityReminder:
                    url = [NSURL URLWithString:@"prefs:root=Privacy&path=NOTES"];
                    break;
                    
                default:
                    break;
            }
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}
@end
