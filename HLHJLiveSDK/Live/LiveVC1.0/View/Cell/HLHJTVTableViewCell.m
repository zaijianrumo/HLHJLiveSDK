//
//  HLHJTVTableViewCell.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJTVTableViewCell.h"
#import "UIColor+HLHJHex.h"
@interface HLHJTVTableViewCell()

@property (nonatomic, strong) UILabel  *timeLab;
@property (nonatomic, strong) UILabel  *titleLab;
@property (nonatomic, strong) UIButton  *isPlayBtn;

@end

@implementation HLHJTVTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    
    _timeLab = [UILabel new];
    _timeLab.text = @"00:00";
    _timeLab.textColor = [UIColor colorWithHexString:@"999999"];
    _timeLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [self.contentView addSubview:_timeLab];
    
    _titleLab = [UILabel new];
    _titleLab.text = @"极限挑战";
    _titleLab.textColor = [UIColor colorWithHexString:@"999999"];
    _titleLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [self.contentView addSubview:_titleLab];
    
    
    _isPlayBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [_isPlayBtn setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_lm_bofang"] forState:UIControlStateNormal];
    _isPlayBtn.hidden = YES;
    [self.contentView addSubview:_isPlayBtn];
    
    
    
    WS(weakSelf);
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).mas_offset(10);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLab.mas_right).mas_offset(10);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [_isPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLab.mas_right).mas_offset(20);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
}

- (void)setModel:(ProgramModel *)model {
    _model = model;
    _timeLab.text = model.time;
    _titleLab.text = model.name;
    _isPlayBtn.hidden = model.online == 1 ? NO:YES;
    
    if (model.online == 1) {
        _titleLab.textColor = [UIColor redColor];
        _timeLab.textColor = [UIColor redColor];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
