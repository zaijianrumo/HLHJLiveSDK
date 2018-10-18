//
//  HLHJTVOneTableViewCell.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLHJTVOneTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic, copy) void(^TimeChooseBlock)(NSString *time);

@end
