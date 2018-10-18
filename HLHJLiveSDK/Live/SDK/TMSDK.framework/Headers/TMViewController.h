//
//  TMViewController.h
//  TMProject
//
//  Created by ZhouYou on 2017/12/13.
//  Copyright © 2017年 ZhouYou. All rights reserved.
//

#import "CDVViewController.h"
#import "CDVCommandDelegateImpl.h"

@interface TMViewController : CDVViewController

/**
 * 是否原生页面
 */
@property (nonatomic, assign) BOOL native;

/**
 * 用于对Controller的参数传递，标准json格式等字符串
 */
@property (nonatomic, copy) NSString *paramStr;

/**
 * 用于对Controller的参数传递，NSDictionary类型
 */
//@property (nonatomic, strong) NSDictionary *paramDict;

/**
 * 对一个Native的Controller发送消息
 * message  消息内容，标准Json格式
 * controller  目标Controller
 * from 发送者，自由定义
 */
- (void)sendTmMessage:(NSString *)message toController:(id)controller from:(NSString *)from;

/**
 * 对一个Native的Controller发送消息
 * message  消息内容，标准Json格式
 * className  目标Controller类名
 * from 发送者，自由定义
 */
- (void)sendTmMessage:(NSString *)message toControllerClassName:(NSString *)className from:(NSString *)from;

/**
 * 根据html页面,http地址等初始化成一个原生窗口
 * page  页面地址，比如index.html、https://www.baidu.com
 * wwwFolder  html文件folder路径
 */
- (TMViewController *)instanceWithPage:(NSString *)page folder:(NSString *)wwwFolder;

/**
 * 收到消息的回调，需重写此方法
 * message  消息内容，标准json格式
 */
- (void)receivedTmMessage:(NSDictionary *)message;

/**
 * 根据ParamStr自动转换成字典（若paramStr为标准json格式）
 */
- (NSDictionary *)paramDict;

- (void)PushRemoteHtmlWithStartPage:(NSString *)startPage Animated:(BOOL)animated;
- (void)PresentRemoteHtmlWithStartPage:(NSString *)startPage Animated:(BOOL)animated;

- (void)PushLocalHtmlWithStartPage:(NSString *)startPage WwwFolderName:(NSString *)wwwFolderName Animated:(BOOL)animated;
- (void)PresentLocalHtmlWithStartPage:(NSString *)startPage WwwFolderName:(NSString *)wwwFolderName Animated:(BOOL)animated;
@end

@interface TMViewCommandDelegate : CDVCommandDelegateImpl

@end

@interface TMViewCommandQueue : CDVCommandQueue

@end
