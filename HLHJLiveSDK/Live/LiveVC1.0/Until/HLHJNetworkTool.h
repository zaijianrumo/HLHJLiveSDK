//
//  HLHJNetworkTool.h
//  HLHJFactModuleSDK
//
//  Created by mac on 2018/5/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

@interface HLHJNetworkTool : NSObject

typedef NS_ENUM(NSInteger, requestType) {
    GET = 1,
    POST = 2,
};

+ (AFHTTPSessionManager *_Nonnull)shareInstance;

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
            failureComplete:(void(^_Nonnull)(NSError * _Nonnull error))failure;



@end

