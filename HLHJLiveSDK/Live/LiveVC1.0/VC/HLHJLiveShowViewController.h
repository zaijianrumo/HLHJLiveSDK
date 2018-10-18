//
//  HLHJLiveShowViewController.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WMPageController/WMPageController.h"
/**
 @brief 直播详情
 */
#import "HLHJLiveModel.h"
@interface HLHJLiveShowViewController : WMPageController


@property (nonatomic, strong) HLHJLiveModel  *model;

@end
