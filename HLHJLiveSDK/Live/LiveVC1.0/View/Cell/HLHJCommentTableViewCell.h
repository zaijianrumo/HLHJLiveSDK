//
//  HLHJCommentTableViewCell.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HLHJCommentModel.h"
/**
 @brief 评论cell
 */
@interface HLHJCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView  *iconImageView;
@property (nonatomic, strong) UILabel  *nickLab;
@property (nonatomic, strong) UILabel  *timeLab;
@property (nonatomic, strong) UILabel  *contentLab;

@property (nonatomic, strong) HLHJCommentModel  *model;

@end
