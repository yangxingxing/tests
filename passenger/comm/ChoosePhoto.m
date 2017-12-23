//
//  ChoosePhoto.m
//  114SDShop
//
//  Created by 杨星星 on 2017/6/10.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "ChoosePhoto.h"

@interface ChoosePhoto () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    UIViewController *_delegate;
    UIActionSheet *_actionSheet;
    UIImagePickerController *_imagePicker;
}

@end

@implementation ChoosePhoto

- (instancetype)initWithDelegate:(UIViewController *)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

#pragma mark - 头像上传
// 更换头像
- (void)changeIconClick {
    if (_actionSheet)
        return;
    
    _actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片"
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:@"从照片中选择"
                                      otherButtonTitles:@"从相机拍摄", nil];
    [_actionSheet showInView:_delegate.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex != buttonIndex)
    {
        UIImagePickerControllerSourceType imgSrc = UIImagePickerControllerSourceTypeCamera; //拍照
        if (buttonIndex != UIImagePickerControllerSourceTypeCamera)
            imgSrc = UIImagePickerControllerSourceTypePhotoLibrary;//UIImagePickerControllerSourceTypeSavedPhotosAlbum;       //照片
        [self performSelector:@selector(pickImage:)
                   withObject:[NSNumber numberWithInt: imgSrc]
                   afterDelay:0];
    }
    _actionSheet = nil;
}

//选择头像
-(void)pickImage:(NSNumber*)srcNum
{
    if (_imagePicker)
        return;
    UIImagePickerControllerSourceType imageSource = [srcNum integerValue];
    
    if (UIImagePickerControllerSourceTypeCamera == imageSource) {
        // 在设置sourceType=camera的时候需要判断相机是否可用
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
        //相机
        if (![[SystemAuthority new] CameraAuthority])
        {
            return;
        }
    }
    else
    {
        //照片
        if (![[SystemAuthority new] PhotoLibraryAuthority])
        {
            //return;
        }
    }
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing=YES;
    _imagePicker.sourceType = imageSource; //UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePicker.navigationBar.barTintColor = MainColor;
    
    //    [self setNavigationBarState:imagePicker.navigationBar];
    _delegate.tabBarController.tabBar.hidden = YES;
    [_delegate presentViewController:_imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //    if ([mediaType isEqualToString:@"public.image"]){
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];//所选中的图片
    [picker dismissViewControllerAnimated:YES completion:nil];
    //    [picker dismissViewControllerAnimated:YES completion:^{
    //        [Comm resetNavViewFrame];
    //    }];
    
    _imagePicker = nil;
    
    [self chooseSuccessWithImage:image]; 
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //[picker.view removeFromSuperview];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    _imagePicker = nil;
}

- (void)chooseSuccessWithImage:(UIImage *)iamge{};

@end
