//
//  HLHJLiveingViewController.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJLiveingViewController.h"
#import "HLHJLiveingTableViewCell.h"
#import "HLHJLiveShowViewController.h"
#import "MJRefresh.h"
#import "HLHJLiveModel.h"
@interface HLHJLiveingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, assign) NSInteger  page;

@property (nonatomic, strong) NSMutableArray  *dataArray;
@end

@implementation HLHJLiveingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"直播";
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
    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/live" parameter:prama successComplete:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if (self.page == 1 && self.dataArray) {
                [self.dataArray removeAllObjects];
            }
            
            NSArray *arr = [NSArray yy_modelArrayWithClass:[HLHJLiveModel class] json:responseObject[@"data"]];
            if (arr.count > 0) {
                [self.dataArray addObjectsFromArray:arr];
                [weakSelf.tableView.mj_footer resetNoMoreData];
                [weakSelf endRefreshing];
                [self.tableView reloadData];
            }else {
                [weakSelf endRefreshing];
                /// 变为没有更多数据的状态
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
       
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
    static NSString *cellID = @"HLHJLiveingTableViewCell";
    HLHJLiveingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[HLHJLiveingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = 0;
    }
    HLHJLiveModel *model = self.dataArray[indexPath.row];
    cell.liveModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HLHJLiveModel *model = self.dataArray[indexPath.row];
    HLHJLiveShowViewController *playView = [[HLHJLiveShowViewController alloc]init];
    playView.model = model;
    playView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playView animated:YES];
}
- (void)endRefreshing {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}
#pragma lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 210;
    }
    return _tableView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
