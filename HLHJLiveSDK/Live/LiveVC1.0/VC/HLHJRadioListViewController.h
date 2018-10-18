//
//  HLHJRadioListViewController.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLHJRadioModel.h"
#import <TMSDK/TMViewController.h>
/**
 @brief 广播列表
 */
@interface HLHJRadioListViewController : TMViewController

@property (nonatomic, strong)HLHJRadioModel   *radioModel;

@end
