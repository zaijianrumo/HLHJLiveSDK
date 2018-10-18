//
//  HLHJNewTVTimeCollectionCell.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewTVTimeCollectionCell.h"
#import "UIColor+HLHJHex.h"
@implementation HLHJNewTVTimeCollectionCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
        _timeLab = [UILabel new];
        _timeLab.text = @"9-10";
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _timeLab.textColor = [UIColor colorWithHexString:@"999999"];
        [self.contentView addSubview:_timeLab];
        
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
    }
    return self;
}

@end
