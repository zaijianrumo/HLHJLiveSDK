//
//  HLHJGraphicLiveTableViewCell.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLHJMagicImageView.h"
#import "HLHJGraphicModel.h"
/**
 @brief 图文直播Cell 
 */
@interface HLHJGraphicLiveTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel  *timeLab;

@property (nonatomic, strong) UILabel  *contetnLab;

@property (nonatomic, strong) HLHJMagicImageView  *iconImg;

@property (nonatomic, strong) ContetnModel  *model;

@end
