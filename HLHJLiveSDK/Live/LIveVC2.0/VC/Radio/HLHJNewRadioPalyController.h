//
//  HLHJNewRadioPalyController.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <TMSDK/TMViewController.h>

@class HLHJRadioModel;
/**
 <#Description#>
 */
@interface HLHJNewRadioPalyController : TMViewController


@property (nonatomic, strong) HLHJRadioModel  *model;

///当前点击播放的下标
@property (nonatomic, assign) NSInteger  chooseIndex;

@end
