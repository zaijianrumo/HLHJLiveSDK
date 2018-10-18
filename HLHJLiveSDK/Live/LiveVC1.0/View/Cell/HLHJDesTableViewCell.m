//
//  HLHJDesTableViewCell.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJDesTableViewCell.h"

@implementation HLHJDesTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    UILabel *titleLba = [UILabel new];
    titleLba.text = @"简介";
    titleLba.textColor = [UIColor grayColor];
    titleLba.font = [UIFont systemFontOfSize:15];
    titleLba.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLba];
    _titLab = titleLba;
    
    UILabel *desLab = [UILabel new];
    desLab.text = @"";
    desLab.textColor = [UIColor blackColor];
    desLab.font = [UIFont systemFontOfSize:15];
    desLab.numberOfLines = 0;
    [self.contentView addSubview:desLab];
    _desLab = desLab;
    
    
    UIView *contentView = self.contentView;
    [_titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(10);
        make.top.equalTo(contentView).offset(10);
        make.width.mas_equalTo(40);
        
    }];
    [_desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titLab.mas_top);
        make.right.lessThanOrEqualTo(contentView.mas_right).offset(-10);
        make.left.equalTo(_titLab.mas_right).offset(10);
        make.bottom.equalTo(contentView.mas_bottom).offset(-10);
    }];
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
