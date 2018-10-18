//
//  HLHJAlertTool.h
//  HLHJFactModuleSDK
//
//  Created by mac on 2018/5/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HLHJAlertTool : NSObject
+(UIAlertController *)createAlertWithTitle:(NSString *)title message:(NSString *)message preferred:(UIAlertControllerStyle)preferred confirmHandler:(void(^)(UIAlertAction *confirmAction))confirmHandler cancleHandler:(void(^)(UIAlertAction *cancleAction))cancleHandler;
@end
