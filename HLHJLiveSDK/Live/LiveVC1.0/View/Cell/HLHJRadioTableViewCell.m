//
//  HLHJRadioTableViewCell.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJRadioTableViewCell.h"

@interface HLHJRadioTableViewCell()

@end

@implementation HLHJRadioTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    
    _coverImg = [UIImageView new];
    _coverImg.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _coverImg.contentMode = UIViewContentModeScaleAspectFill;
    _coverImg.clipsToBounds = YES;
    [self.contentView addSubview:_coverImg];

    _radioName = [UILabel new];
    _radioName.text = @"央妈";
    _radioName.textColor = [UIColor blackColor];
    _radioName.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_radioName];
    
    _radioDes = [UILabel new];
    _radioDes.text = @"正在广播";
    _radioDes.textColor = [UIColor darkGrayColor];
    _radioDes.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_radioDes];
    
    WS(weakSelf);
    [_coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerYWithinMargins.equalTo(weakSelf.contentView);
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.width.equalTo(_coverImg.mas_height);
    }];
    
    [_radioName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_coverImg).mas_offset(-10);
        make.left.equalTo(_coverImg.mas_right).mas_offset(10);
    }];
    
    [_radioDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_radioName.mas_bottom).mas_offset(10);
        make.left.equalTo(_radioName);
    }];
        
}
- (void)setModel:(HLHJRadioModel *)model {
    _model = model;
//    [_coverImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,model.radio_thumb]] placeholderImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zhibo_xiedanmu"]];
//    _radioName.text = model.radio_name;
//    if (model.online.length == 0) {
//        _radioDes.text = @"";
//        return;
//    }
//    _radioDes.text = [NSString stringWithFormat:@"正在直播:%@",model.online];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
