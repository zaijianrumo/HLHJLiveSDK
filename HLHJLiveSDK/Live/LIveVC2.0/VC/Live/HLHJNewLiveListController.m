//
//  HLHJNewLiveListController.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewLiveListController.h"

/** Controllers **/
#import "HLHJNewLiveDetilController.h"
/** Model **/
#import "HLHJLiveModel.h"
/** Views**/
#import "HLHJNewLiveListCell.h"

#import <TMSDK/TMHttpUser.h>
/** Other **/
#import "MJRefresh.h"
@interface HLHJNewLiveListController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, strong) NSMutableArray  *listArray;

@property (nonatomic, assign) NSInteger  page;

@end

@implementation HLHJNewLiveListController


#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
   

    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(self.view);
    }];
    
    [self initData];
    
}

#pragma mark - Delegate/DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.listArray ? self.listArray.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 248;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HLHJNewLiveListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJNewLiveListCell"];
    cell.model = self.listArray[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HLHJNewLiveDetilController *hlhjLive = [HLHJNewLiveDetilController new];
    hlhjLive.hidesBottomBarWhenPushed = YES;
    HLHJLiveModel *model  =  self.listArray[indexPath.section];

    NSDictionary *dict  = @{@"ID":model.ID,@"live_thumb":model.live_thumb,@"live_status":[@(model.live_status) stringValue],@"live_source":model.live_source};
    hlhjLive.paramStr = [dict yy_modelToJSONString];
    
    [self.navigationController pushViewController:hlhjLive animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}
#pragma mark - Notification Methods

#pragma mark - KVO Methods

#pragma mark - Public Methods
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
    
    NSDictionary *prama = @{@"page":@(page),
                            @"token":[TMHttpUser token]?[TMHttpUser token]:@""
                            };
    __weak typeof(self) weakSelf = self;
    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/live" parameter:prama successComplete:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if (self.page == 1 && self.listArray) {
                [self.listArray removeAllObjects];
            }
            
            NSArray *arr = [NSArray yy_modelArrayWithClass:[HLHJLiveModel class] json:responseObject[@"data"]];
            if (arr.count > 0) {
                [self.listArray addObjectsFromArray:arr];
                [weakSelf.tableView.mj_footer resetNoMoreData];
                [weakSelf endRefreshing];
                [weakSelf.tableView reloadData];
            }else {
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

- (void)endRefreshing {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}
#pragma mark - Private Methods

#pragma mark - Action Methods

#pragma mark - Getter Methods

#pragma mark - Setter Methods

#pragma lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HLHJNewLiveListCell class] forCellReuseIdentifier:@"HLHJNewLiveListCell"];

        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

- (NSMutableArray *)listArray {
    
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
