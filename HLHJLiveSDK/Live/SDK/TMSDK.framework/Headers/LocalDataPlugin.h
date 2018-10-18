//
//  CacheDataI008InstanceController.h
//  TmCompDemo
//
//  Created by omni－appple on 2018/3/27.
//  Copyright © 2018年 ZhouYou. All rights reserved.
//

#import <TMSDK/CDVPlugin.h>

@interface LocalDataPlugin : CDVPlugin
/**
 * 获取工程配置数据
 */
- (void)engineConfigData:(CDVInvokedUrlCommand*)command;

/**
 * 获取用户数据
 */
- (void)userConfigData:(CDVInvokedUrlCommand*)command;
    

@end
