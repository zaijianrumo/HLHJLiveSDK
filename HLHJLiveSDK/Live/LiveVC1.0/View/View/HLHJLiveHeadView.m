//
//  HLHJLiveHeadView.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJLiveHeadView.h"


@interface HLHJLiveHeadView()

@property (nonatomic, strong) NSMutableArray  *masonryViewArray;

@property (nonatomic, strong) NSArray  *dataLists;

@end


@implementation HLHJLiveHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self masonryViewArray];
    
}
- (NSMutableArray *)masonryViewArray {
    if (!_masonryViewArray) {
        
        _masonryViewArray = [NSMutableArray array];
        CGFloat width = ScreenW / self.dataLists.count;
        for (int i = 0; i < self.dataLists.count; i ++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:self.dataLists[i][@"title"] forState:UIControlStateNormal];
            btn.frame = CGRectMake(width*i, 0, width, 120);
            CGFloat offset = 20.0f;
            [btn setImage:[UIImage imageNamed:self.dataLists[i][@"image"]] forState:UIControlStateNormal];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.frame.size.width+12, -btn.imageView.frame.size.height-offset/2, 0);
            btn.imageEdgeInsets = UIEdgeInsetsMake(-btn.titleLabel.intrinsicContentSize.height-5, 0, 0, -btn.titleLabel.intrinsicContentSize.width);
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self addSubview:btn];
            btn.tag = i+100;
            [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            [_masonryViewArray addObject:btn];
            
        }
    }
    
    return _masonryViewArray;
}
- (void)clickAction:(UIButton *)sender  {

    if (_ClickButtonBlock) {
        _ClickButtonBlock(sender.tag);
    }
    
}
- (NSArray *)dataLists{
    if (!_dataLists) {
        _dataLists = @[
                       @{@"image":@"HLHJLiveImgs.bundle/ic_ds_dianshi",@"title":@"电视"},
                       @{@"image":@"HLHJLiveImgs.bundle/ic_ds_zhibo",@"title":@"直播"},
//                       @{@"image":@"HLHJLiveImgs.bundle/ic_ds_guanggbo",@"title":@"广播"},
                       ];
    }
    return _dataLists;
}
@end
