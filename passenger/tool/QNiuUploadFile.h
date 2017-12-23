//
//  QNiuUploadFile.h
//  YunFu
//
//  Created by 杨星星 on 2017/9/18.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^QNiuUploadSuccess)(NSString *key);

@interface QNiuUploadFile : NSObject

+ (void)uploadDataToQNiuWithImage:(UIImage *)image success:(QNiuUploadSuccess)success fail:(dispatch_block_t)fail;

@end
