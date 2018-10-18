//
//  HLHJRadioProgramModel.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/28.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJRadioProgramModel.h"

@implementation HLHJRadioProgramModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"program":[ListProgramModel class]};
}

@end
@implementation ListProgramModel

@end

