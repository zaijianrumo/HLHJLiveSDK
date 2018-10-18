//
//  TMController.h
//  CordovaLib
//
//  Created by ZhouYou on 2017/12/14.
//

#import "CDVPlugin.h"

@interface TMController : CDVPlugin

/**
 * 以present  方式弹出一个新的窗口
 */
- (void)presentCtr:(CDVInvokedUrlCommand*)command;

/**
 * 以dismiss  方式返回
 */
- (void)dismissCtr:(CDVInvokedUrlCommand*)command;

/**
 * 以push  方式弹出一个新的窗口,若没有导航控制器实则是present出窗口
 */
- (void)pushCtr:(CDVInvokedUrlCommand*)command;

/**
 * 以pop  方式返回
 */
- (void)popCtr:(CDVInvokedUrlCommand*)command;

/**
 * 根据原生ViewController类名称创建并present出页面
 */
- (void)presentToNative:(CDVInvokedUrlCommand*)command;

/**
 * 根据原生ViewController类名称创建并push出页面
 */
- (void)pushToNative:(CDVInvokedUrlCommand*)command;

/**
 * 根据原生ViewController类名发送消息
 */
- (void)sendMessage:(CDVInvokedUrlCommand*)command;


@end
