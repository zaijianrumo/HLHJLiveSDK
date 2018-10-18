//
//  HLHJGraphicLiveViewController.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJGraphicLiveViewController.h"
#import "HLHJGraphicLiveTableViewCell.h"
#import "HLHJGraphicModel.h"
#import "HLHJNSSafeObject.h"
@interface HLHJGraphicLiveViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, strong) NSMutableArray  *dataArray;

@property (nonatomic, strong) HLHJGraphicModel  *model;
/**
 是否滚动到最底部
 */
@property (nonatomic, assign) BOOL  currentIsInBottom;


@end

@implementation HLHJGraphicLiveViewController
{
        NSTimer * _timer;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [_timer invalidate];
    [_timer setFireDate:[NSDate distantFuture]];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_timer setFireDate:[NSDate date]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initUI];
}
- (void)initUI {

    __weak typeof(self) weakSelf = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    ///////////////////t测试
    HLHJNSSafeObject * safeObj = [[HLHJNSSafeObject alloc]initWithObject:self withSelector:@selector(sendGraphicData)];
    _timer = [NSTimer scheduledTimerWithTimeInterval:20 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
    
}
- (NSString *)getNowTimeTimestamp{

    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strTime = [dateFormatter stringFromDate:[NSDate date]];
    return strTime;
    
}
- (void)sendGraphicData {
    
    WS(weakSelf);
    [HLHJNetworkTool hlhjRequestWithType:GET
                              requestUrl:@"/api/online" parameter:@{@"live_id":_live_id,@"start_time":_model.lt ? _model.lt:@"",@"last_time":[self getNowTimeTimestamp]} successComplete:^(id  _Nullable responseObject) {
                                  
                                  if ([responseObject[@"code"] integerValue] == 1) {
                                      
//                                      NSLog(@"responseObject:%@",responseObject);
                                      
                                      _model = [HLHJGraphicModel yy_modelWithJSON:responseObject];
                                      if(_model.data.count > 0)
                                      {
                                          
                                          // 要插入的位置
                                          NSIndexSet *helpIndex = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [_model.data count])];
                                          // 要插入的数组
                                          [weakSelf.dataArray insertObjects:_model.data atIndexes:helpIndex];

                                          
                                          [self.tableView reloadData];
                                          
                                      }
                                      if (_model.online == 2) {
                                          [_timer invalidate];
                                          _timer = nil;
                                      }
                                  }
                              } failureComplete:^(NSError * _Nonnull error) {
                                  
                              }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"HLHJGraphicLiveTableViewCell";
    HLHJGraphicLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[HLHJGraphicLiveTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = 0;
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView  = [UIView new];
        _tableView.estimatedRowHeight = 100;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
