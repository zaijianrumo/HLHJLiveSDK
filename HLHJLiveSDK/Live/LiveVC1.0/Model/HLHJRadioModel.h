//
//  HLHJRadioModel.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/25.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ListRadioModel;

@interface HLHJRadioModel : NSObject

@property (nonatomic, copy) NSString  *banner;

@property (nonatomic, copy) NSString  *title;

@property (nonatomic, strong) NSArray<ListRadioModel *>  *list;

@end

@interface ListRadioModel : NSObject

@property (nonatomic, copy) NSString  *ID;

@property (nonatomic, copy) NSString  *radio_name;

@property (nonatomic, copy) NSString  *radio_thumb;

@property (nonatomic, copy) NSString  *radio_source;

@property (nonatomic, copy) NSString  *create_at;

@property (nonatomic, copy) NSString  *update_at;

@property (nonatomic, copy) NSString  *online;

@property (nonatomic, copy) NSString  *pm;

@property (nonatomic, assign) BOOL isSelect;

@end
