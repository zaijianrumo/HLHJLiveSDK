//
//  HLHJTVViewController.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TMSDK/TMViewController.h>
#import "HLHJTvModel.h"
/**
 @brief 电视 栏目
 */
@interface HLHJTVViewController : TMViewController

@property (nonatomic, strong) HLHJTvModel  *tvModel;

@end
