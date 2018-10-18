//
//  HLHJLoginTool.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HLHJLoginTool : NSObject
///是否登录
+ (BOOL)isLogin:(UIViewController *)vc;

+ (UIViewController *)getCurrentVC ;

@end
