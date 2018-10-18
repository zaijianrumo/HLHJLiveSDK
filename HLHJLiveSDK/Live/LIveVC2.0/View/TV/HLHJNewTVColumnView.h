//
//  HLHJNewTVColumnView.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HLHJNewTVColumnView : UIView<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic, copy) void(^ColumnChooseBlock)(NSString *columnID);

@property (nonatomic, strong) NSMutableArray   *dataArray;

@end
