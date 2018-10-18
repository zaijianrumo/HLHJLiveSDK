//
//  HLHJNewLiveCommonListCell.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewLiveCommonListCell.h"
#import "UIColor+HLHJHex.h"

@interface HLHJNewLiveCommonListCell()

@property (nonatomic, strong) UIImageView  *iconImg;

@property (nonatomic, strong) UILabel  *nameLab,*timeLabel,*contentLabel;

@end

@implementation HLHJNewLiveCommonListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        self.selectionStyle  = 0;
        self.backgroundColor = [UIColor whiteColor];
        
        
        UIImageView *iconImg = [[UIImageView alloc]init];
        iconImg.backgroundColor = [UIColor groupTableViewBackgroundColor];
        iconImg.layer.cornerRadius = 14;
        iconImg.clipsToBounds = YES;
        [self.contentView addSubview:iconImg];
        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(28);
            make.left.equalTo(self.contentView).mas_offset(15);
            make.top.equalTo(self.contentView).mas_offset(23);
        }];
        self.iconImg = iconImg;

        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.text = @"小二汪";
        nameLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        nameLab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        [self.contentView addSubview:nameLab];
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImg.mas_right).mas_offset(10);
            make.centerY.equalTo(iconImg).mas_offset(-5);
        }];
        self.nameLab = nameLab;
        
        
        UIButton *giveLikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [giveLikeBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [giveLikeBtn setImage:HLHJImage(@"ic_home_praise_normal") forState:UIControlStateNormal];
        [giveLikeBtn setImage:HLHJImage(@"ic_home_praise_select") forState:UIControlStateSelected];
        [giveLikeBtn setTitle:@" 0" forState:UIControlStateNormal];
        giveLikeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:giveLikeBtn];
        
        [giveLikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(nameLab);
            make.right.equalTo(self.contentView).mas_offset(-10);
        }];
        [giveLikeBtn addTarget:self action:@selector(giveLikeAction:) forControlEvents:UIControlEventTouchUpInside];
        self.giveLikeBtn = giveLikeBtn;
        
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.text = @"政策好的";
        contentLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        contentLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [self.contentView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLab.mas_left);
            make.right.equalTo(self.contentView.mas_right).mas_offset(-20);
            make.top.equalTo(nameLab.mas_bottom).mas_offset(15);
            
        }];
        self.contentLabel = contentLabel;
        

        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.text = @"20分钟前";
        timeLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        timeLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel.mas_bottom).mas_offset(15);
            make.left.equalTo(contentLabel);
            make.bottom.equalTo(self.contentView.mas_bottom).mas_offset(-23);
        }];
        self.timeLabel = timeLabel;
        
    }
    return self;
    
}

- (void)setModel:(HLHJCommentModel *)model {
    
    _model = model;
    
    if ([model.head_pic containsString:@"://"]) {
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.head_pic] placeholderImage:HLHJImage(@"ic_touxiang")];
    }else {
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,model.head_pic] ] placeholderImage:HLHJImage(@"ic_zb_touxiang")];
    }
    
    self.nameLab.text = model.user_name;
    
    self.contentLabel.text = model.content;
    self.timeLabel.text = [self cStringFromTimestamp:model.create_at];
    self.giveLikeBtn.selected = model.is_laud == 1 ? YES:NO;
    
    
    if (model.laud_num > 1000) {
        [self.giveLikeBtn setTitle:[NSString stringWithFormat:@" %.lfk",model.laud_num/1000] forState:UIControlStateNormal];
    }else {
        [self.giveLikeBtn setTitle:[NSString stringWithFormat:@" %ld",model.laud_num] forState:UIControlStateNormal];
    }
    
}
- (void)giveLikeAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(giveLikeBtnAction:)]) {
        [self.delegate giveLikeBtnAction:sender];
    }
}
//、时间戳——字符串时间
- (NSString *)cStringFromTimestamp:(NSString *)timestamp{
    //时间戳转时间的方法
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
