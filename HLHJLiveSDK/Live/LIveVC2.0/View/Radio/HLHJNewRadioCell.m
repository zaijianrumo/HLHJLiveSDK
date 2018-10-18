//
//  HLHJNewRadioCell.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewRadioCell.h"

@interface HLHJNewRadioCell()

@property (nonatomic, strong) UIImageView  *iconImageView;

@property (nonatomic, strong) UILabel  *nameLabel,*statusLabel,*NOlabel;


@end

@implementation HLHJNewRadioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
 
        self.selectionStyle = 0;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15);
            make.bottom.mas_equalTo(-15);
            make.width.mas_equalTo(70);
        }];
        self.iconImageView = imageView;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"成都广播";
        nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).mas_offset(15);
            make.left.equalTo(imageView.mas_right).mas_offset(14);
            make.right.mas_equalTo(-10);
        }];
        self.nameLabel = nameLabel;
        
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        statusLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [self.contentView addSubview:statusLabel];
        [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(nameLabel);
        }];
        self.statusLabel = statusLabel;

        
        UILabel *NOlabel = [[UILabel alloc] init];
        NOlabel.text = @"FM 95.1";
        NOlabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        NOlabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [self.contentView addSubview:NOlabel];
        [NOlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).mas_offset(-15);
            make.left.right.equalTo(nameLabel);
        }];
        self.NOlabel = NOlabel;
        
        UIButton *isPlayStatuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [isPlayStatuBtn setImage:HLHJImage(@"ic_radio_play") forState:UIControlStateNormal];
        [isPlayStatuBtn setImage:HLHJImage(@"ic_radio_stop") forState:UIControlStateSelected];
        [self.contentView addSubview:isPlayStatuBtn];
        [isPlayStatuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView.mas_right).mas_offset(-15);
        }];
        self.isPlayStatuBtn = isPlayStatuBtn;
       
        
        UIButton *animBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        animBtn.selected = NO;
        [animBtn setImage:HLHJImage(@"cm2_list_icn_loading1") forState:UIControlStateNormal];
        [self.contentView addSubview:animBtn];
        [animBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.statusLabel.mas_right).mas_offset(8);
            make.width.height.mas_equalTo(14);
        }];
        
          animBtn.hidden = YES;
          self.animBtn = animBtn;
        

    }
    return self;
}
- (void)setModel:(ListRadioModel *)model {
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,model.radio_thumb]]];
    self.nameLabel.text = model.radio_name;
    self.NOlabel.text  = model.pm;
    self.statusLabel.text = model.online;
    self.animBtn.hidden = !model.isSelect;
    self.isPlayStatuBtn.selected = model.isSelect;
    if(model.isSelect){

        UIImageView *btnImageView = self.animBtn.imageView;
        NSMutableArray *images = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i++) {
            NSString *imageName = [NSString stringWithFormat:@"cm2_list_icn_loading%zd", i + 1];
            [images addObject:HLHJImage(imageName)];
        }
        for (NSInteger i = 4; i > 0; i--) {
            NSString *imageName = [NSString stringWithFormat:@"cm2_list_icn_loading%zd", i];
            [images addObject:HLHJImage(imageName)];
        }

        btnImageView.animationImages = images;
        btnImageView.animationDuration = 1;
        //设置重复次数，0表示无限
        btnImageView.animationRepeatCount = 0;
        [self.animBtn.imageView startAnimating];

    }else {
        [self.animBtn.imageView stopAnimating];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
