//
//  HLHJCommentTableViewCell.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJCommentTableViewCell.h"

@interface HLHJCommentTableViewCell()

@end

@implementation HLHJCommentTableViewCell




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        [self setUI];
    }
    return self;
    
}

- (void)setUI {
    
    _iconImageView = [UIImageView new];
    _iconImageView.image = [UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zb_touxiang"];
    [self.contentView addSubview:_iconImageView];
    
    _nickLab = [UILabel new];
    _nickLab.text = @"张三";
    _nickLab.textColor = [UIColor blackColor];
    _nickLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_nickLab];
    
    
    _timeLab = [UILabel new];
    _timeLab.text = @"2017-07-18";
    _timeLab.textColor = [UIColor lightGrayColor];
    _timeLab.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_timeLab];
    
    _contentLab = [UILabel new];
    _contentLab.text = @"张三";
    _contentLab.textColor = [UIColor blackColor];
    _contentLab.font = [UIFont systemFontOfSize:15];
    _contentLab.numberOfLines = 0;
    _contentLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_contentLab];
    
    UIView *contentView = self.contentView;
    CGFloat width = 35;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).mas_offset(15);
        make.top.mas_equalTo(contentView).mas_offset(15);
        make.width.equalTo(_iconImageView.mas_height);
        make.width.mas_equalTo(width);
    }];
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.cornerRadius  = width / 2;
    [_nickLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView);
        make.left.equalTo(_iconImageView.mas_right).mas_offset(10);
        make.right.equalTo(contentView).mas_offset(-10);
    }];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nickLab);
        make.right.equalTo(_nickLab);
        make.top.equalTo(_nickLab.mas_bottom).mas_offset(10);
    }];
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_nickLab);
        make.top.equalTo(_timeLab.mas_bottom).mas_offset(10);
        make.bottom.equalTo(contentView).mas_offset(-10);
    }];
    
}
- (void)setModel:(HLHJCommentModel *)model {
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,model.head_pic]] placeholderImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zb_touxiang"]];
    _nickLab.text = model.user_name;
    _timeLab.text = [self cStringFromTimestamp:model.create_at];
    _contentLab.text = model.content;
    
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
