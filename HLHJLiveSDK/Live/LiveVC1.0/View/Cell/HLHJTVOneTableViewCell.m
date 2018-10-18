//
//  HLHJTVOneTableViewCell.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJTVOneTableViewCell.h"
#import "HLHJTVUICollectionViewCell.h"

@interface HLHJTVOneTableViewCell()

@property (nonatomic, assign) NSInteger selectedRow;

@end

@implementation HLHJTVOneTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        layout.itemSize = CGSizeMake(self.contentView.frame.size.width/7,  self.contentView.frame.size.height);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[HLHJTVUICollectionViewCell class] forCellWithReuseIdentifier:@"HLHJTVUICollectionViewCell"];
        
        [self.contentView addSubview:_collectionView];
        
//        NSString *time = [self getWeekTime];
//        NSArray *b = [time componentsSeparatedByString:@","];
//        NSArray *selectArr = [self getDayArrayLeftDate:b[2] rightDate:b[3] dateFormatter:@"yyyy-MM-dd"];
        
        NSArray *selectArr = [self getCurrentWeeksDateFormatter:@"yyyy-MM-dd"];
        //是否包含
        if ([selectArr containsObject:[self getCurrentTime]]) {
            
            NSInteger index = [selectArr indexOfObject:[self getCurrentTime]];
            
            self.selectedRow = index;
            
        }
    }
}

#pragma mark: --- uicollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HLHJTVUICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLHJTVUICollectionViewCell" forIndexPath:indexPath];
        
    NSArray *arr = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
//    NSString *time = [self getWeekTime];
//    NSArray *b = [time componentsSeparatedByString:@","];
//    NSArray *datearr = [self getDayArrayLeftDate:b[2] rightDate:b[3] dateFormatter:@"dd"];
//      cell.dateleLa.text = datearr[indexPath.row];

    cell.titleLa.text = arr[indexPath.row];
    cell.dateleLa.text = [self getCurrentWeeksDateFormatter:@"dd"][indexPath.row];
    
//
    
    if (self.selectedRow == indexPath.row) {
        
        cell.titleLa.textColor = [UIColor redColor];
        cell.dateleLa.textColor = [UIColor redColor];
        cell.dateleLa.layer.borderColor = [UIColor redColor].CGColor;
 
    }else{
        
        cell.titleLa.textColor = [UIColor darkGrayColor];
        cell.dateleLa.textColor = [UIColor darkGrayColor];
        cell.dateleLa.layer.borderColor = [UIColor darkGrayColor].CGColor;
    }

    return cell;
}
-(NSString*)getCurrentTime {
    
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString * dateTime = [formatter stringFromDate:[NSDate date]];
    
    return  dateTime;
    
}
//点击选定
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

//    NSString *time = [self getWeekTime];
//    NSArray *b = [time componentsSeparatedByString:@","];
//    NSArray *datearr = [self getDayArrayLeftDate:b[2] rightDate:b[3] dateFormatter:@"yyyy-MM-dd"];
    NSArray *datearr  =[self getCurrentWeeksDateFormatter:@"yyyy-MM-dd"];
    if (_TimeChooseBlock) {
        _TimeChooseBlock(datearr[indexPath.row]);
    }
    self.selectedRow = indexPath.row;
    [self.collectionView reloadData];

}
//取消选定
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedRow = indexPath.row;
    [self.collectionView reloadData];

}
//
////获取本周对应的日期
//- (NSString *)getWeekTime
//{
//    NSDate *nowDate = [NSDate date];
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *comp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit fromDate:nowDate];
//    //1. 获取今天是周几
//    NSInteger weekDay = [comp weekday];
//    //2. 获取几天是几号
//    NSInteger day = [comp day];
//    //3. 计算当前日期和本周的星期一和星期天相差天数
//    long firstDiff,lastDiff;
//    if (weekDay == 1)
//    {
//        firstDiff = -6;
//        lastDiff = 0;
//    }
//    else
//    {
//        firstDiff = [calendar firstWeekday] - weekDay + 1;
//        lastDiff = 8 - weekDay;
//    }
//    // 在当前日期(去掉时分秒)基础上加上差的天数
//    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  fromDate:nowDate];
//    [firstDayComp setDay:day + firstDiff];
//    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
//
//    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit   fromDate:nowDate];
//    [lastDayComp setDay:day + lastDiff];
//    NSDate *lastDayOfWeek = [calendar dateFromComponents:lastDayComp];
//
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"dd"];
//    NSString *firstDay = [formatter stringFromDate:firstDayOfWeek];
//    NSString *lastDay = [formatter stringFromDate:lastDayOfWeek];
//
//
//    NSDateFormatter *formatte1 = [[NSDateFormatter alloc] init];
//    [formatte1 setDateFormat:@"yyyy-MM-dd"];
//    NSString *firstDay1 = [formatte1 stringFromDate:firstDayOfWeek];
//    NSString *lastDay1 = [formatte1 stringFromDate:lastDayOfWeek];
//
//    NSString *dateStr = [NSString stringWithFormat:@"%@,%@,%@,%@",firstDay,lastDay,firstDay1,lastDay1];
//
//
//    return dateStr;
//
//}

//获取两个日期之间的所有日期，精确到天

//- (NSArray *)getDayArrayLeftDate:(NSString *)aLeftDateStr rightDate:(NSString *)aRightDateStr dateFormatter:(NSString *)dataFormater{
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//
//    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
//
//    NSDate *aLeftDate = [dateFormatter dateFromString:aLeftDateStr];
//
//    NSDate *aRightDate = [dateFormatter dateFromString:aRightDateStr];
//
//    if (aLeftDate == aRightDate) {
//
//        NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//
//        NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday |NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay fromDate:aLeftDate];
//
//        NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
//
//        NSDateFormatter *dateday = [[NSDateFormatter alloc]init];
//
//        [dateday setDateFormat:@"yyyy-MM-dd"];
//
//        NSString *currentDateStr = [dateday stringFromDate:beginningOfWeek];
//
//        return @[currentDateStr];
//
//    }
//
//    NSMutableArray *dayArray = [NSMutableArray arrayWithCapacity:0];
//
//    NSDate *currentDate = aLeftDate;
//
//    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//
//    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday |NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay fromDate:currentDate];
//
//
//    while (currentDate < aRightDate) {
//
//        NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
//
//        currentDate = beginningOfWeek;
//
//        NSDateFormatter *dateday = [[NSDateFormatter alloc]init];
//
////        [dateday setDateFormat:@"yyyy-MM-dd"];
//        [dateday setDateFormat:dataFormater];
//
//        NSString *currentDateStr = [dateday stringFromDate:beginningOfWeek];
//
//        [dayArray addObject:currentDateStr];
//
//        [components setDay:([components day]+1)];
//
//    }
//    return dayArray;
//
//}



//获取一周时间 数组
- (NSMutableArray *)getCurrentWeeksDateFormatter:(NSString *)dateFormaString {
    
//    NSDate *now = [NSDate date];
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday
//                                         fromDate:now];
//    // 得到星期几
//    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
//    NSInteger weekDay = [comp weekday];
//    // 得到几号
//    NSInteger day = [comp day];
//
//    // 计算当前日期和这周的星期一和星期天差的天数
//    long firstDiff,lastDiff;
//    if (weekDay == 1) {
//        firstDiff = 1;
//        lastDiff = 0;
//    }else{
//        firstDiff = [calendar firstWeekday] - weekDay;
//        lastDiff = 7 - weekDay;
//    }
    
    
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit fromDate:nowDate];
    //1. 获取今天是周几
    NSInteger weekDay = [comp weekday];
    //2. 获取几天是几号
    NSInteger day = [comp day];
    //3. 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    
    NSMutableArray *eightArr = [[NSMutableArray alloc] init];
    for (NSInteger i = firstDiff; i < lastDiff + 1; i ++) {
        //从现在开始的24小时
        NSTimeInterval secondsPerDay = i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:dateFormaString];
        NSString *dateStr = [dateFormatter stringFromDate:curDate];//几月几号
        // NSString *dateStr = @"5月31日";
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
        [weekFormatter setDateFormat:@"EEEE"];//星期几 @"HH:mm 'on' EEEE MMMM d"];
//        NSString *weekStr = [weekFormatter stringFromDate:curDate];
        //组合时间
        //        NSString *strTime = [NSString stringWithFormat:@"%@(%@)",dateStr,weekStr];
        //        [eightArr addObject:strTime];
        [eightArr addObject:dateStr];
    }
    return eightArr;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
