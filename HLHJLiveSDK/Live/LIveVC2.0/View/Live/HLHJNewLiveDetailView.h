//
//  HLHJNewLiveDetailView.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLHJLiveModel.h"
#import "IJKMediaFramework.framework/Headers/IJKFFOptions.h"
#import "IJKMediaFramework.framework/Headers/IJKFFMoviePlayerController.h"
#import "HLHJLiveDesModel.h"

typedef NS_ENUM(NSUInteger, MovieViewState) {
    MovieViewStateSmall,
    MovieViewStateAnimating,
    MovieViewStateFullscreen,
};

@protocol HLHJNewLiveDetailViewDelegate<NSObject>
@optional

- (void)fullScreenAction:(BOOL)flag;

- (void)navbackAcction;

@end


@interface HLHJNewLiveDetailView : UIView

- (instancetype)initWithFrame:(CGRect)frame  isTv:(BOOL )isTV;

/**
 记录小屏时的parentView
 */
@property (nonatomic, weak) UIView *movieViewParentView;
/**
 记录小屏时的frame
 */
@property (nonatomic, assign) CGRect movieViewFrame;

///电视播放 播放源
@property (nonatomic, copy) NSString  *playUrl;

/// 直播播放数据
@property (nonatomic, strong) NSDictionary *prama;


@property (nonatomic, assign) MovieViewState state;

@property (nonatomic,  weak) id<HLHJNewLiveDetailViewDelegate>  delegate;

@property (nonatomic, strong) IJKFFMoviePlayerController *playerVC;

@property (nonatomic, strong) HLHJLiveDesModel  *liveDesModel;

@end
