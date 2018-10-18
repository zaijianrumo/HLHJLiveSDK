//
//  HLHJNewRadioHeadView.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewRadioHeadView.h"
#import "UIColor+HLHJHex.h"
@implementation HLHJNewRadioHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if ( self == [super initWithReuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"我的电台";
        label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        label.textColor = [UIColor colorWithHexString:@"333333"];
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self);
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(1);
        }];
        
    }
    return self;
}




@end
