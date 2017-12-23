//
//  HttpClient.h
//  114SD
//
//  Created by 杨星星 on 2017/3/23.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "User.h"

//http 连接服务器失败
typedef void (^HttpClientFail)(NSString *error);

//http 读取到数据
typedef void (^HttpClientReceived)(NSDictionary* dict, NSInteger code);

@interface HttpClient : NSObject

@property (nonatomic,strong) User *userInfo;

+ (instancetype)httpWithReceived:(HttpClientReceived)aReceived Fail:(HttpClientFail)aFail;

/**
 GET请求数据
 @param urlStr 此处是填url完整路径，也可将服务端url保存，此处填API即可
 @param dict 参数
 */
- (void)getRequest:(NSString*)urlStr Data:(NSDictionary*)dict;

// POST请求数据，建议使用
- (void)postRequest:(NSString*)urlStr Data:(NSDictionary*)dict;

// 上传头像
- (void)postImageWithDic:(NSDictionary *)dic
                 withImg:(UIImage *)image
                  imgDic:(NSDictionary *)imgDic
                     url:(NSString *)url
                    name:(NSString *)name
            successBlock:(HttpClientReceived)successBlock
            failureBlock:(HttpClientFail)failureBlock;

//传图片
//- (void)PostImgWithDic:(NSDictionary *)dic
//               withImg:(NSDictionary *)imgDic
//                   url:(NSString *)url
//          successBlock:(HttpClientReceived)successBlock
//          failureBlock:(HttpClientFail)failureBlock;

@property (nonatomic,copy) NSString *uuidString;

@end
