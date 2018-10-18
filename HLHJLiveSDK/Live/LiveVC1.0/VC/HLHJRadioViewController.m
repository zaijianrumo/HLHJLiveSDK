//
//  HLHJRadioViewController.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJRadioViewController.h"
#import "HLHJRadioTableViewCell.h"
#import "HLHJRadioListViewController.h"
#import "HLHJRadioModel.h"
#import "MJRefresh.h"
@interface HLHJRadioViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, assign) NSInteger  page;

@property (nonatomic, strong) NSMutableArray  *dataArray;

@end
@implementation HLHJRadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"广播";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initUI];
    
    [self initData];
}

- (void)initUI {
    
    __weak typeof(self) weakSelf = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
    }];
}
- (void)initData {
    
    WS(weakSelf);
    ///NOTE5:下拉刷新加载列表数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [weakSelf getDataSourcePage:self.page];
    }];
    ///NOTE6:上拉刷新加载列表数据
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getDataSourcePage:self.page];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)getDataSourcePage:(NSInteger)page {
    
    NSDictionary *prama = @{@"page":@(page)
                            };
    __weak typeof(self) weakSelf = self;
    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/radio" parameter:prama successComplete:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            if (self.page == 1 && self.dataArray) {
                [self.dataArray removeAllObjects];
            }
            
            NSArray *arr = [NSArray yy_modelArrayWithClass:[HLHJRadioModel class] json:responseObject[@"data"]];
            if (arr.count > 0) {
                [self.dataArray addObjectsFromArray:arr];
                [weakSelf.tableView.mj_footer resetNoMoreData];
                [weakSelf endRefreshing];
            }else {
                /// 变为没有更多数据的状态
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        }else {
            [weakSelf endRefreshing];
        }
        
    } failureComplete:^(NSError * _Nonnull error) {
        [weakSelf endRefreshing];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"HLHJRadioTableViewCell";
    HLHJRadioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[HLHJRadioTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HLHJRadioListViewController *radioing = [HLHJRadioListViewController new ];
    radioing.radioModel = self.dataArray[indexPath.row];
    radioing.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:radioing animated:YES];
}
#pragma lazy
- (void)endRefreshing {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
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
        _tableView.rowHeight = 130;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
