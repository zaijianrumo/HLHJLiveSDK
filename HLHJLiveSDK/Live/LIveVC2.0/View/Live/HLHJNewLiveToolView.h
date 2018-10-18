
//
//  HLHJNewLiveToolView.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HLHJNewLiveToolViewDelete<NSObject>
@optional
////点赞
- (void)giveLiveBtnAciton:(UIButton *)sender;
///评论
- (void)commenAciton:(UIButton *)sender;
///收藏
- (void)collentAciton:(UIButton *)sender;
///分享
- (void)shareAciton:(UIButton *)sender;

@end

@interface HLHJNewLiveToolView : UIView

@property (nonatomic, weak)id<HLHJNewLiveToolViewDelete>  delegate;


@property (nonatomic, strong) UIButton  *giveLiveBtn,*commenBtn,*collentBtn;

@end
