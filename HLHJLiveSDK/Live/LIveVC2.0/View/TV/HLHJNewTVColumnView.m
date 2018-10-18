//
//  HLHJNewTVColumnView.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewTVColumnView.h"
#import "HLHJNewTVColumnCollectionCell.h"
#import "UIColor+HLHJHex.h"
#import "HLHJTvModel.h"
@interface HLHJNewTVColumnView()

@property (nonatomic, assign) NSInteger selectedRow;

@end

@implementation HLHJNewTVColumnView

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[HLHJNewTVColumnCollectionCell class] forCellWithReuseIdentifier:@"HLHJNewTVColumnCollectionCell"];
        [self addSubview:_collectionView];

    }
}
- (void)setDataArray:(NSMutableArray *)dataArray {
    
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
    
}

#pragma mark: --- uicollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    HLHJTvModel *model = self.dataArray[indexPath.row];
    NSString *str = model.channel_name;
    CGFloat strWidth = [self calculateRowWidth:str];
    return CGSizeMake(strWidth + 30, self.frame.size.height);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HLHJNewTVColumnCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLHJNewTVColumnCollectionCell" forIndexPath:indexPath];
    
    HLHJTvModel *model = self.dataArray[indexPath.row];
    cell.nameLab.text = model.channel_name;
    
     if (self.selectedRow == indexPath.row) {

      cell.nameLab.textColor = [TMEngineConfig instance].themeColor;
      cell.nameLab.layer.borderColor = [TMEngineConfig instance].themeColor.CGColor;
      cell.nameLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
         

     }else{
         
          cell.nameLab.textColor = [UIColor colorWithHexString:@"999999"];
          cell.nameLab.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
          cell.nameLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
         
     }
    
    return cell;
}
//点击选定
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_ColumnChooseBlock) {
        HLHJTvModel *model = self.dataArray[indexPath.row];
        _ColumnChooseBlock(model.ID);
    }
    self.selectedRow = indexPath.row;
    [self.collectionView reloadData];
    
}
//取消选定
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedRow = indexPath.row;
    [self.collectionView reloadData];
    
}


- (CGFloat)calculateRowWidth:(NSString *)string {
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Medium" size:14]};
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin |
                   
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    return rect.size.width;
    
}


@end
