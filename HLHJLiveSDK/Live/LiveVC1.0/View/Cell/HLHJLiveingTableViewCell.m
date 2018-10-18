//
//  HLHJLiveingTableViewCell.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJLiveingTableViewCell.h"

@interface HLHJLiveingTableViewCell()

@property (nonatomic, strong) UIImageView  *coverImg;
@property (nonatomic, strong) UIImageView  *stateImg;
@property (nonatomic, strong) UILabel  *titleLabe;
@end

@implementation HLHJLiveingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    
    _coverImg = [[UIImageView alloc]init];
    _coverImg.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _coverImg.contentMode = UIViewContentModeScaleAspectFill;
    _coverImg.clipsToBounds = YES;
    [self.contentView addSubview:_coverImg];
    
    _stateImg = [[UIImageView alloc]init];
    [_coverImg addSubview:_stateImg];
    
    _titleLabe = [UILabel new];
    _titleLabe.text = @"阿里巴巴举行集体婚礼";
    _titleLabe.textColor = [UIColor blackColor];
    _titleLabe.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titleLabe];
    
    WS(weakSelf);
    [_coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf);
        make.height.mas_equalTo(170);
    }];
    
    [_stateImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_coverImg).mas_offset(10);
        make.bottom.equalTo(_coverImg).mas_offset(-10);
    }];
    
    [_titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).mas_offset(-10);
        make.left.equalTo(weakSelf).mas_offset(10);
        make.top.equalTo(_coverImg.mas_bottom);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
    
    
}

-(void)setLiveModel:(HLHJLiveModel *)liveModel {
    _liveModel = liveModel;
    [_coverImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,liveModel.live_thumb]] placeholderImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zhibo_xiedanmu"]];
    _titleLabe.text = _liveModel.live_title;
    

    if (_liveModel.live_status == 1) {
        
        if (_liveModel.live_type == 1) {
            [_stateImg setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zb_zhengzaizhibo"]];
        }else {
             [_stateImg setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zb_huifang"]];
        }
    }else {
             [_stateImg setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zb_tuwenzhibo"]];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
