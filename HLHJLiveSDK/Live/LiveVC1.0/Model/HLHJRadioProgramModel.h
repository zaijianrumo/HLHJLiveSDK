//
//  HLHJRadioProgramModel.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/28.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ListProgramModel;
@interface HLHJRadioProgramModel : NSObject

@property (nonatomic, copy) NSString  *ID;

@property (nonatomic, copy) NSString  *radio_source;

@property (nonatomic, copy) NSString  *radio_name;

@property (nonatomic, copy) NSString  *radio_thumb;

@property (nonatomic, copy) NSString  *online;

@property (nonatomic, strong ) NSArray<ListProgramModel *>  *program;

@end
@interface ListProgramModel :NSObject

@property (nonatomic, copy) NSString  *time;

@property (nonatomic, copy) NSString  *name;

@property (nonatomic, assign) NSInteger type; //类型 1-直播 2-回放

@property (nonatomic, assign) NSInteger online; //1-正在播放 2-暂停播放
@end
