//
//  HLHJRadioModel.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/25.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJRadioModel.h"

@implementation HLHJRadioModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"list":[ListRadioModel class]};
}
@end

@implementation ListRadioModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" :@"id"};
}

@end

