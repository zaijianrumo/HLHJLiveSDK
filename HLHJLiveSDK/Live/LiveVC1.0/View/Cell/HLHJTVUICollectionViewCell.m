//
//  HLHJTVUICollectionViewCell.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJTVUICollectionViewCell.h"



@implementation HLHJTVUICollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
        _titleLa = [UILabel new];
        _titleLa.text = @"周一";
        _titleLa.textAlignment = NSTextAlignmentCenter;
        _titleLa.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        _titleLa.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_titleLa];

        _dateleLa = [UILabel new];
        _dateleLa.text = @"14";
        _dateleLa.textAlignment = NSTextAlignmentCenter;
        _dateleLa.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        _dateleLa.textColor = [UIColor darkGrayColor];
        _dateleLa.layer.masksToBounds = YES;
        _dateleLa.layer.cornerRadius = 5;
        _dateleLa.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _dateleLa.layer.borderWidth = 1;
        [self.contentView addSubview:_dateleLa];

        WS(weakSelf);
        [_titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.contentView);
            make.top.equalTo(weakSelf.contentView.mas_top).mas_offset(15);
        }];
        [_dateleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).mas_offset(-15);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(40);
            make.centerX.equalTo(_titleLa);
        }];
    }
    return self;
}
@end
