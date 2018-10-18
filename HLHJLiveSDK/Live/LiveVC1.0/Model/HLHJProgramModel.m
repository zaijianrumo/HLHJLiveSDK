//
//  HLHJProgramModel.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/24.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJProgramModel.h"

@implementation HLHJProgramModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"program":[ProgramModel class]};
}

@end

@implementation ProgramModel

@end


