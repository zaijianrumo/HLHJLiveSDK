//
//  HLHJNewLiveToolView.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewLiveToolView.h"
#import "UIColor+HLHJHex.h"
@interface HLHJNewLiveToolView()

@property (nonatomic, strong) NSMutableArray *masonryViewArray;

@end

@implementation HLHJNewLiveToolView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {

        UIButton *toolBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [toolBtn1 setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [toolBtn1 setImage:HLHJImage(@"ic_home_praise_normal") forState:UIControlStateNormal];
        [toolBtn1 setImage:HLHJImage(@"ic_home_praise_select") forState:UIControlStateSelected];
        toolBtn1.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        [self addSubview:toolBtn1];
        [toolBtn1 setTitle:@" 0" forState:UIControlStateNormal];
        [self.masonryViewArray addObject:toolBtn1];
        toolBtn1.tag = 0;
        [toolBtn1 addTarget:self action:@selector(toolBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.giveLiveBtn = toolBtn1;
        
        self.commenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commenBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [self.commenBtn setImage:HLHJImage(@"ic_home_comments") forState:UIControlStateNormal];
        self.commenBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        [self addSubview:self.commenBtn];
        [self.commenBtn setTitle:@" 0" forState:UIControlStateNormal];
        [self.masonryViewArray addObject:self.commenBtn];
        self.commenBtn.tag = 1;
        [self.commenBtn addTarget:self action:@selector(toolBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *toolBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [toolBtn3 setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [toolBtn3 setImage:HLHJImage(@"ic_collection_normal") forState:UIControlStateNormal];
        [toolBtn3 setImage:HLHJImage(@"ic_home_collection_selected") forState:UIControlStateSelected];
        toolBtn3.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        [self addSubview:toolBtn3];
        [self.masonryViewArray addObject:toolBtn3];
        toolBtn3.tag = 2;
        [toolBtn3 addTarget:self action:@selector(toolBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.collentBtn = toolBtn3;
        
        UIButton *toolBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [toolBtn4 setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [toolBtn4 setImage:HLHJImage(@"ic_home_share") forState:UIControlStateNormal];
        toolBtn4.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        [self addSubview:toolBtn4];
        [self.masonryViewArray addObject:toolBtn4];
        toolBtn4.tag = 3;
        [toolBtn4 addTarget:self action:@selector(toolBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self masonry_horizontal_fixSpace];
   
    }
    return self;
}
- (NSMutableArray *)masonryViewArray {
    
    if (!_masonryViewArray) {
        
        _masonryViewArray = [NSMutableArray array];
    }
    return _masonryViewArray;
   
}

- (void)toolBtnAction:(UIButton *)sender {

    switch (sender.tag) {
        case 0:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(giveLiveBtnAciton:)]) {
                [self.delegate giveLiveBtnAciton:sender];
            }
        }break;
        case 1:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(commenAciton:)]) {
                [self.delegate commenAciton:sender];
            }
        }break;
        case 2:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(collentAciton:)]) {
                [self.delegate collentAciton:sender];
            }
        }break;
        case 3:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(shareAciton:)]) {
                [self.delegate shareAciton:sender];
            }
        }break;
            
        default:
            break;
    }
    
}

- (void)masonry_horizontal_fixSpace {
    
    // 实现masonry水平固定间隔方法
    [self.masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30 leadSpacing:10 tailSpacing:10];
    
    // 设置array的垂直方向的约束
    [self.masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.height.equalTo(self);
    }];
}


@end
