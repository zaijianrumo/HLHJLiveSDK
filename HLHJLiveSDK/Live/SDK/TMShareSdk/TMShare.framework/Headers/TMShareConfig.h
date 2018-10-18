//
//  TMShareConfig.h
//  UMSocialDemo
//
//  Created by ZhouYou on 2018/2/9.
//  Copyright © 2018年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMShareConfig : NSObject

//根据TMBaseConfig文件配置来初始化
- (id)initWithTMBaseConfig;

/* 打开日志 */
@property (nonatomic, assign) BOOL openLog;

// 打开图片水印
@property (nonatomic, assign) BOOL isUsingWaterMark;

/**
 *  是否清除缓存在获得用户资料的时候
 *  默认设置为YES,代表请求用户的时候需要请求缓存
 *  NO,代表不清楚缓存，用缓存的数据请求用户数据
 */
@property (nonatomic, assign) BOOL isClearCacheWhenGetUserInfo;

/* 设置友盟appkey */
@property (nonatomic, copy) NSString *umSocialAppkey;

/* 新浪相关 */
@property (nonatomic, copy) NSString *sinaAppKey;
@property (nonatomic, copy) NSString *sinaAppSecret;
@property (nonatomic, copy) NSString *sinaRedirectURL;

/* 微信相关 */
@property (nonatomic, copy) NSString *wechatAppKey;
@property (nonatomic, copy) NSString *wechatAppSecret;
@property (nonatomic, copy) NSString *wechatRedirectURL;//设置nil

/* qq相关 */
@property (nonatomic, copy) NSString *qqAppKey;/*设置QQ平台的appID*/
@property (nonatomic, copy) NSString *qqAppSecret;//设置nil
@property (nonatomic, copy) NSString *qqRedirectURL;//设置nil
@end
