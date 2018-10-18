//
//  HLHJRadioListTableViewCell.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJRadioListTableViewCell.h"

#import "HLHJProgramModel.h"
@interface HLHJRadioListTableViewCell()

@property (nonatomic, strong) UILabel  *titLab;

@property (nonatomic, strong) UIImageView  *timeIcon;

@property (nonatomic, strong) UILabel  *timeLab;

@property (nonatomic, strong) UIButton   *isPlayBtn;

@end

@implementation HLHJRadioListTableViewCell

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
    
    _titLab = [UILabel new];
    _titLab.text = @"最美中国";
    _titLab.textColor = [UIColor blackColor];
    _titLab.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_titLab];
    
    _timeIcon = [UIImageView new];
    _timeIcon.image = [UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_gb_shijian"];
    [self.contentView addSubview:_timeIcon];
    
    
    _timeLab = [UILabel new];
    _timeLab.text = @"00:00";
    _timeLab.textColor = [UIColor blackColor];
    _timeLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_timeLab];
    
    _isPlayBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [_isPlayBtn setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_gb_bofang"] forState:UIControlStateNormal];
    [_isPlayBtn setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_gb_zanting"] forState:UIControlStateSelected];
    [self.contentView addSubview:_isPlayBtn];
    
    WS(weakSelf);
    [_titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).mas_offset(10);
        make.top.equalTo(weakSelf.contentView).mas_offset(10);
        make.right.equalTo(weakSelf.contentView).mas_offset(-10);
    }];
                    
    [_timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titLab);
        make.top.equalTo(_titLab.mas_bottom).mas_offset(10);
    }];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeIcon);
        make.left.equalTo(_timeIcon.mas_right).mas_offset(5);
    }];
    
    [_isPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView).mas_offset(-10);
    }];
    
}
- (void)setModel:(ListProgramModel *)model {
    _model = model;
    _titLab.text = model.name;
    _timeLab.text = model.time;
    _isPlayBtn.hidden = model.online == 1 ? NO:YES;
    
    if (model.online == 1) {
        _titLab.textColor =  [UIColor redColor];
        _timeLab.textColor = [UIColor redColor];
        _isPlayBtn.selected = YES;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
