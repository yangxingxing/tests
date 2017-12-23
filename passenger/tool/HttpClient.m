//
//  HttpClient.m
//  114SD
//
//  Created by 杨星星 on 2017/3/23.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "HttpClient.h"
#import "AppDelegate.h"


@interface HttpClient () <NSURLSessionDelegate>

@property (nonatomic, copy) HttpClientReceived aReceived;
@property (nonatomic, copy) HttpClientFail aFail;
@property (nonatomic, copy) NSString *baseUrl;

@end

@implementation HttpClient

+ (instancetype)httpWithReceived:(HttpClientReceived)aReceived Fail:(HttpClientFail)aFail {
    HttpClient *httpClient = [[HttpClient alloc] init];
    httpClient.aReceived = aReceived;
    httpClient.aFail = aFail;
    httpClient.baseUrl = BaseUrl;
    
    httpClient.userInfo = [User standardUserInfo];
    return httpClient;
}

//GET请求数据
- (void)getRequest:(NSString*)urlStr Data:(NSDictionary*)dict {
    urlStr = [self.baseUrl stringByAppendingString:urlStr];
    // 1.实例化一个session对象
    NSURLSession * session = [NSURLSession sharedSession];
    // 拼接参数
    NSString *dataStr = [self getParams:dict];
    // 获取url
    NSURL *resultUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",urlStr,dataStr]];
    //    __weak typeof(self) wSelf = self;
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:resultUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) { // 请求失败
            NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            if (_aFail) {
                dispatch_async_on_main_queue(^{
                    _aFail(errorStr);
                });
            }
        } else {
            // kNilOptions默认写法优化性能
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            SLog(@"string=%@",string);
            
            SLog(@"currentThread=%@",[NSThread currentThread]);
            if (_aReceived) {
                dispatch_async_on_main_queue(^{
                    NSInteger code = [dic[@"success"] integerValue];
                    _aReceived(dic,code);
                    if (!code) {
                        NSString *message = dic[@"msg"];
                        if ([message isEqualToString:@"TOKEN已过期，请重新登录"]) {
                            [MyTools loginOut];
                        }
                    }
                });
            }
        }
        
    }];
    
    // 手动开启任务
    [dataTask resume];
}

//POST请求数据
- (void)postRequest:(NSString*)urlStr Data:(NSDictionary*)dict {
    //    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    urlStr = [self.baseUrl stringByAppendingString:urlStr];
    // 1.获取url
    NSURL *url = [NSURL URLWithString:urlStr];
    // 2.创建session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 3.创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    // 4.设置请求方式与参数
    request.HTTPMethod = @"POST";
    NSString *dataStr = [self getParams:dict];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    
    //    __weak typeof(self) wSelf = self;
    // 5.进行链接请求数据
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) { // 请求失败
            NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            if (_aFail) {
                dispatch_async_on_main_queue(^{
                    _aFail(errorStr);
                });
            }
        } else {
            // kNilOptions默认写法优化性能
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            SLog(@"string=%@",string);
            
            SLog(@"currentThread=%@",[NSThread currentThread]);
            if (_aReceived) {
                dispatch_async_on_main_queue(^{
                    NSInteger code = [dic[@"success"] integerValue];
                    _aReceived(dic,code);
                    if (!code) {
                        NSString *message = dic[@"msg"];
                        if ([message isEqualToString:@"TOKEN已过期，请重新登录"]) {
                            [MyTools loginOut];
                        }
                    }
                });
            }
        }
    }];
    // 6.开启请求数据
    [dataTask resume];
}

- (void)GBKEncode:(NSDictionary *)dic data:(NSData *)data {
    if (!dic) {
        //定义GBK编码格式
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //GBK格式接收数据并进行转换
        NSString * retStr = [[NSString alloc]initWithData:data encoding:enc];
        
        NSData * jsonData = [retStr dataUsingEncoding:enc];
        
        NSString * jsonStr = [[NSString alloc]initWithData:jsonData encoding:enc];
        //将数据转为UTF-8
        NSData * Ddata = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        //解析
        NSDictionary * dicJson = [NSJSONSerialization JSONObjectWithData:Ddata options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dicJson);
    }
}

// sessionDelegate
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    NSLog(@"%@",error);
}

// 拼接参数
- (NSString *)getParams:(NSDictionary *)params {
    NSArray *keyAray = [params allKeys];
    NSMutableString *result = [NSMutableString string];
    for (NSString *obj in keyAray) {
        NSValue *value = [params objectForKey:obj];
        [result appendString:[NSString stringWithFormat:@"&%@=%@",obj,value]];
    }
    if (result && result.length > 0) {
        [result replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    //    result = [@"date=20151031&startRecord=1&len=5&udid=1234567890&terminalType=Iphone&cid=213" mutableCopy];
    return result;
}

// 上传头像
- (void)postImageWithDic:(NSDictionary *)dic
                 withImg:(UIImage *)image
                  imgDic:(NSDictionary *)imgDic
                     url:(NSString *)url
                    name:(NSString *)name
            successBlock:(HttpClientReceived)successBlock
            failureBlock:(HttpClientFail)failureBlock
{
    url = [self.baseUrl stringByAppendingString:url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
//    NSMutableDictionary *mutableDict = [dic mutableCopy];
//    [mutableDict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:APPDeviceToken] forKey:@"devicetoken"];
    NSURLSessionDataTask *task = [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        if (image) {
            NSData *imageData =UIImageJPEGRepresentation(image,0.5); // 压缩
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            
            //上传的参数(上传图片，以文件流的格式)
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
        }
        if (imgDic) {
            for (id key in imgDic) {
                UIImage *image = [imgDic objectForKey:key];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat =@"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
                
                NSData *imageData =UIImageJPEGRepresentation(image,0.5);
                
                [formData appendPartWithFileData:imageData
                                            name:key
                                        fileName:fileName
                                        mimeType:@"image/jpeg"];
            }
        }
        
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
        SLog(@"上传进度:%@",uploadProgress);
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        //上传成功
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        SLog(@"string=%@",string);
        SLog(@"上传成功");
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        // kNilOptions默认写法优化性能
        if (successBlock && [dic isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [dic[@"code"] integerValue];
            successBlock(dic,code);
        }
        if (_aReceived) {
            NSInteger code = [dic[@"code"] integerValue];
            _aReceived(dic,code);
            if (code == 10) {
                [MyTools loginOut];
            }
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        //        NSLog(@"上传图片失败了了AFN ");
        SLog(@"上传图片失败了了AFN ");
        failureBlock(errorStr);
        if (failureBlock) {
            failureBlock(errorStr);
        }
        if (_aFail) {
            _aFail(errorStr);
        }
    }];
    
    [task resume];
}

//传图片
//- (void)PostImgWithDic:(NSDictionary *)dic
//               withImg:(NSDictionary *)imgDic
//                   url:(NSString *)url
//          successBlock:(HttpClientReceived)successBlock
//          failureBlock:(HttpClientFail)failureBlock
//{
//    //    AFHTTPSessionManager *manager = [self baseHtppRequest];
//    url = [self.baseUrl stringByAppendingString:url];
//    AFHTTPSessionManager *postAvatarManager = [AFHTTPSessionManager manager];
//    postAvatarManager.responseSerializer= [AFHTTPResponseSerializer serializer];
//    [postAvatarManager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        if (imgDic.allKeys.count == 0) {
//            SLog(@"没有图片上传");
//        }else
//        {
//            for (id key in imgDic) {
//                UIImage *image = [imgDic objectForKey:key];
//                
//                NSData *data = [[NSData alloc] init];
//                data = UIImageJPEGRepresentation(image, 1.0);
//                SLog(@"图片大小%ld",data.length);
//
//                data =  UIImageJPEGRepresentation(image, 0.4);
//                SLog(@"变化图片大小%ld",data.length);
//                
//                 [formData appendPartWithFileData:UIImageJPEGRepresentation(image,0.8) name:@"UploadAblum" fileName:@"headIcon.jpg" mimeType:@"image/jpeg"];
//                
////                [formData appendPartWithFileData: data name:[NSString stringWithFormat:@"%@",key] fileName:[NSString stringWithFormat:@"%@.jpeg",key] mimeType:@"image/jpeg"];//Type:@"image/jpeg"fileName:[NSString stringWithFormat:@"%@.png"
//            }
//        }
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        nil;
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //        NSLog(@"上传图片成功了AFN ");
//        SLog(@"上传图片成功了AFN ");
//        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
//        // kNilOptions默认写法优化性能
//        if (successBlock && [dic isKindOfClass:[NSDictionary class]]) {
//            NSInteger code = [dic[@"success"] integerValue];
//            successBlock(dic,code);
//        }
//        // 请求成功，解析失败，返回反馈字符串
//        
//    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
//        //        NSLog(@"上传图片失败了了AFN ");
//        SLog(@"上传图片失败了了AFN ");
//        failureBlock(errorStr);
//        if (failureBlock) {
//            failureBlock(errorStr);
//        }
//    }];
//}

@end
