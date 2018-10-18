//
//  HLHJNetworkTool.m
//  HLHJFactModuleSDK
//
//  Created by mac on 2018/5/11.
//  Copyright © 2018年 mac. All rights reserved.
//
//
#import "HLHJNetworkTool.h"
#import <TMSDK/TMHttpUser.h>
static AFHTTPSessionManager *_manager;

@implementation HLHJNetworkTool

+ (AFHTTPSessionManager *)shareInstance {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [AFHTTPSessionManager manager];
    });
    return _manager;
}
+ (AFHTTPSessionManager *)sharedManager {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript" , @"text/plain" ,@"text/html",@"application/xml",@"image/jpeg",nil];
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = 30.0f;
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

        //***************** HTTPS 设置 *****************************//
        // 设置非校验证书模式
        _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        // 客户端是否信任非法证书
        _manager.securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
        _manager.securityPolicy.validatesDomainName = NO;
        
    });
    return _manager;
}

/**
 普通请求

 @param type 请求类型
 @param url 请求链接
 @param parameter 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)hlhjRequestWithType:(requestType )type
                 requestUrl:(NSString *_Nonnull)url
                  parameter:(NSDictionary *_Nullable)parameter
            successComplete:(void(^_Nullable)(id _Nullable responseObject))success
            failureComplete:(void(^_Nonnull)(NSError * _Nonnull error))failure {

    if ([url containsString:BASE_URL]) {
        url = url;
    }else {
        url = [NSString stringWithFormat:@"%@/%@%@",BASE_URL,URL_KEYWORDS,url];
    }
      NSLog(@"请求链接:%@ \n 请求参数:%@",url ,parameter);
//
    //3.传tooken
    [_manager.requestSerializer setValue:[TMHttpUser token]?[TMHttpUser token]:@"" forHTTPHeaderField:@"token"];
      _manager = [self sharedManager];
        if (type == 1) { // GET 请求
            [_manager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
                NSLog(@"responseObject:%@",responseObject);
               !success ? : success(responseObject);

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){

                if (error.code == NSURLErrorCancelled)  return ;
                 NSLog(@"%@",error);
                !failure ? : failure(error);
            }];
        }else if (type == 2){ // POST 请求

            [_manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
               NSLog(@"responseObject:%@",responseObject);
               !success ? : success(responseObject);

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){

                if (error.code == NSURLErrorCancelled)  return ;
                NSLog(@"%@",error);
                !failure ? : failure(error);
            }];
        }else {
            NSLog(@"未选择请求类型");
            return;
        }

}

@end

