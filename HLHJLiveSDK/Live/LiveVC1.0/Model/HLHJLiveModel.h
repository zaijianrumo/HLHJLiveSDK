//
//  HLHJLiveModel.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/24.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 直播列表 模型
 */
@interface HLHJLiveModel : NSObject


@property (nonatomic, copy) NSString  *ID;

@property (nonatomic, copy) NSString  *live_thumb;

@property (nonatomic, copy) NSString  *live_title;

@property (nonatomic, copy) NSString  *live_source;

@property (nonatomic, assign) NSInteger  live_type;

@property (nonatomic, assign) NSInteger  live_status;

@property (nonatomic, assign) BOOL  is_collection;

@property (nonatomic, assign) NSInteger  collection_num;

@property (nonatomic, assign) NSInteger  read_num;

@property (nonatomic, assign) NSInteger  comment_num;

@property (nonatomic, assign) BOOL  is_laud;

@property (nonatomic, assign) NSInteger  laud_num;

@property (nonatomic, copy) NSString * sid;



@end
