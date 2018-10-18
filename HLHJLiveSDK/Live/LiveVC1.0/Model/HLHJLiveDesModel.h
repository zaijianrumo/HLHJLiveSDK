//
//  HLHJLiveDesModel.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/25.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 直播详情
 */
@interface HLHJLiveDesModel : NSObject
//"id": 1,//直播ID
//"live_title": "这是一个视频直播1",//直播标题
//"live_desc": "sdfadfadsfasdfasdf1",//直播描述
//"live_source": "http://wssource.pull.inke.cn/live/1527140509565263.flv?ikDnsOp=1&ikHost=ws&ikOp=1&codecInfo=8192&ikLog=0&dpSrcG=1&ikMinBuf=3800&ikMaxBuf=4800&ikSlowRate=1.0&ikFastRate=1.2",//直播源
//"live_type": 1,//1-直播 2-回放
//"online": 1//1-正在直播 2-暂停直播

@property (nonatomic, copy) NSString  *ID;

@property (nonatomic, assign) NSInteger live_status;

@property (nonatomic, copy) NSString  *live_title;

@property (nonatomic, copy) NSString  *live_desc;

@property (nonatomic, copy) NSString  *live_source;

@property (nonatomic, copy) NSString  *live_type;

@property (nonatomic, copy) NSString  *online;

@property (nonatomic, strong) NSString *live_thumb;

@property (nonatomic, assign) NSInteger  comment_status;  //1-开启评论 2-关闭评论

@property (nonatomic, assign) NSInteger  vote_status; //1允许弹幕，2则不允许

@property (nonatomic, assign) BOOL  is_collection;

@property (nonatomic, assign) NSInteger  collection_num;

@property (nonatomic, assign) NSInteger  read_num;

@property (nonatomic, assign) NSInteger  comment_num;

@property (nonatomic, assign) BOOL  is_laud;

@property (nonatomic, assign) NSInteger  laud_num;

@end
