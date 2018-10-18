//
//  HLHJNewTVColumnCollectionCell.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewTVColumnCollectionCell.h"

#import "UIColor+HLHJHex.h"

@implementation HLHJNewTVColumnCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
        
        _nameLab = [UILabel new];
        _nameLab.text = @"湖南卫视";
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _nameLab.textColor = [UIColor colorWithHexString:@"999999"];
        _nameLab.layer.masksToBounds = YES;
        _nameLab.layer.cornerRadius = 6;
        _nameLab.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        _nameLab.layer.borderWidth = 1;
        _nameLab.numberOfLines = 0;
        [self.contentView addSubview:_nameLab];
        
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).mas_offset(5);
            make.bottom.right.equalTo(self.contentView).mas_offset(-5);
        }];
        
    }
    return self;
}

@end
