//
//  TMShareInstance.h
//  UMSocialDemo
//
//  Created by ZhouYou on 2018/2/8.
//  Copyright © 2018年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMShareConfig.h"

typedef void(^TMShareComplete)(id data, NSError *error);

@class UIViewController;
@interface TMShareInstance : NSObject

+ (TMShareInstance *)instance;

//先配置
- (void)configWith:(TMShareConfig *)config;

/*
 webLink   分享的web地址
 thumb     缩略图，必填 https://开头
 title     标题
 des       描述
 currentController  当前页面Controller
 complete   回调
 */
- (void)showShare:(NSString *)webLink
         thumbUrl:(NSString *)thumb
            title:(NSString *)title
            descr:(NSString *)des
currentController:(UIViewController *)currentController
           finish:(TMShareComplete)complete;
@end
