//
//  HLHJNewLiveCommonListCell.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLHJCommentModel.h"

@protocol HLHJNewLiveCommonListCellCellDelegate<NSObject>

@optional
- (void)giveLikeBtnAction:(UIButton *)sender;

@end

@interface HLHJNewLiveCommonListCell : UITableViewCell

@property (nonatomic, strong) HLHJCommentModel  *model;

@property (nonatomic, strong) UIButton  *giveLikeBtn;

@property (nonatomic, weak) id<HLHJNewLiveCommonListCellCellDelegate>  delegate;


@end


