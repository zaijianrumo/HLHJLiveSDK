//
//  HLHJLivePlayViewController.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TMSDK/TMViewController.h>
/**
 @brief 直播界面
 */
@interface HLHJLivePlayViewController : UIViewController
/// 直播流地址
@property (nonatomic, copy) NSString *stream_addr;
///封面图
@property (nonatomic, copy) NSString *portrait;
///直播ID
@property (nonatomic, copy) NSString *live_id;
///TV YES 直播 NO
@property (nonatomic, assign) BOOL  isTVPlay;

@property (nonatomic, copy) void(^dismissBlock)(void);

@end
