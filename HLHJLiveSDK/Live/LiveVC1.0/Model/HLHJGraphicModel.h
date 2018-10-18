//
//  HLHJGraphicModel.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ContetnModel;

@interface HLHJGraphicModel : NSObject

@property (nonatomic, copy) NSString  *url;

@property (nonatomic, assign) NSInteger  online;

@property (nonatomic, copy) NSString  *lt;


@property (nonatomic, strong) NSArray<ContetnModel *>  *data;

@end

@interface ContetnModel : NSObject

@property (nonatomic, copy) NSString  *online_content;

@property (nonatomic, copy) NSString  *online_thumb;

@property (nonatomic, copy) NSString  *online_time;

@property (nonatomic, copy) NSString  *live_id;

@property (nonatomic, copy) NSString  *is_read;

@property (nonatomic, copy) NSString  *update_at;

@end
