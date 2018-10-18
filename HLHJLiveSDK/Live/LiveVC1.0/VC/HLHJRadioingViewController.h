//
//  HLHJRadioingViewController.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TMSDK/TMViewController.h>
#import "HLHJRadioProgramModel.h"
/**
 @brief 音频播放界面
 */
@interface HLHJRadioingViewController : TMViewController

@property (nonatomic, strong) HLHJRadioProgramModel  *model;

@end
