//
//  HLHJProgramModel.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/24.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 节目单列表
 */
@class  ProgramModel;
//
@interface HLHJProgramModel : NSObject

@property (nonatomic, copy) NSString  *ID;

@property (nonatomic, copy) NSString  *tv_source;

@property (nonatomic, copy) NSString  *channel_name;

@property (nonatomic, strong) NSArray<ProgramModel *>  *program;

@end

@interface ProgramModel : NSObject

@property (nonatomic, copy) NSString  *time;

@property (nonatomic, copy) NSString  *name;

@property (nonatomic, assign) NSInteger type; //类型 1-直播 2-回放

@property (nonatomic, assign) NSInteger online; //1-正在播放 2-暂停播放


@end
