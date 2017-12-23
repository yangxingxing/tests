//
//  QNiuUploadFile.m
//  YunFu
//
//  Created by 杨星星 on 2017/9/18.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "QNiuUploadFile.h"
//#import <QiniuSDK.h>

@implementation QNiuUploadFile

+ (void)uploadDataToQNiuWithImage:(UIImage *)image success:(QNiuUploadSuccess)success fail:(dispatch_block_t)fail {
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *token = [user valueForKey:QNiuToken];
//    QNUploadManager *upManager = [[QNUploadManager alloc] init];
//
//    NSData *imageData =UIImageJPEGRepresentation(image,0.5); // 压缩
//
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat =@"yyyyMMddHHmmss";
//    NSString *str = [formatter stringFromDate:[NSDate date]];
//    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
//
//    [upManager putData:imageData key:fileName token:token
//              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                  NSLog(@"%@", info);
//                  NSLog(@"%@", resp);
//                  if (info.error) {
//                      if (fail) {
//                          fail();
//                      }
//                      [BusinessShowInfoView showInfo:@"图片上传失败"];
//                  } else {
//                      [BusinessShowInfoView showInfo:@"图片上传成功"];
//                      if (success) {
//                          success(key);
//                      }
//                  }
//              } option:nil];
}

@end
