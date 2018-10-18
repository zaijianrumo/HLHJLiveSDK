//
//  HLHJRadioTableViewCell.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HLHJRadioModel.h"
/**
 广播cell
 */

@interface HLHJRadioTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView  *coverImg;

@property (nonatomic, strong) UILabel  *radioName;

@property (nonatomic, strong) UILabel  *radioDes;

@property (nonatomic, strong) HLHJRadioModel  *model;

@end
