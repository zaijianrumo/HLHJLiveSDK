//
//  HLHJLiveHeadView.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLHJLiveHeadView : UIView

@property (nonatomic, copy) void(^ClickButtonBlock)(NSInteger buttonTag);

@end
