//
//  HLHJRadioListViewController.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJRadioListViewController.h"
#import "HLHJRadioListTableViewCell.h"
#import "HLHJRadioingViewController.h"
#import "HLHJRadioTableViewCell.h"

#import "HLHJRadioProgramModel.h"
#import "MJRefresh.h"
@interface HLHJRadioListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, strong) NSMutableArray  *dataArray;

@property (nonatomic, strong) HLHJRadioProgramModel *model;

@end

@implementation HLHJRadioListViewController

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
        make.left.bottom.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
    }];
    ///NOTE5:下拉刷新加载列表数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataSource];
    }];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - 加载数据
-(void)getDataSource {
//    WS(weakSelf);
//    NSDictionary *param = @{@"radio_id":_radioModel.ID,
//                            @"program_date":[self getCurrentTime]
//                            };
//
//    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/radio_program" parameter:param successComplete:^(id  _Nullable responseObject) {
//        [weakSelf.tableView.mj_header endRefreshing];
//
////        NSLog(@"responseObject:%@",responseObject);
//
//        if ([responseObject[@"code"] integerValue] ==1) {
//            [self.dataArray removeAllObjects];
//            _model = [HLHJRadioProgramModel yy_modelWithJSON:responseObject[@"data"]];
//            if (_model.program) {
//                [self.dataArray addObjectsFromArray:_model.program];
//            }
//            [weakSelf.tableView reloadData];
//        }
//    } failureComplete:^(NSError * _Nonnull error) {
//        [weakSelf.tableView.mj_header endRefreshing];
//    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0)
    return 130;
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.row == 0){
        static NSString *cellID = @"HLHJRadioTableViewCell";
        HLHJRadioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[HLHJRadioTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = 0;
        }
        [cell.coverImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,_model.radio_thumb]] placeholderImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zhibo_xiedanmu"]];
        cell. radioName.text = _model.radio_name;
        cell.radioDes.text = _model.online;
        return cell;
    }
    
    static NSString *cellID = @"HLHJRadioListTableViewCell";
    HLHJRadioListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[HLHJRadioListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = 0;
    }
    cell.model = self.dataArray[indexPath.row-1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){

        HLHJRadioingViewController *radioing = [HLHJRadioingViewController new];
        radioing.model = _model;
        radioing.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:radioing animated:YES];
    }
}
#pragma lazy
-(NSString*)getCurrentTime {
    
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString * dateTime = [formatter stringFromDate:[NSDate date]];
    
    return  dateTime;
    
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
