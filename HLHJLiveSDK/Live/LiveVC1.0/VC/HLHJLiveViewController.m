//
//  HLHJLiveViewController.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJLiveViewController.h"
#import "HLHJLiveHeadView.h"
#import "HLHJLiveingViewController.h"
#import "HLHJRadioViewController.h"
#import "HLHJTVViewController.h"
#import "HLHJTvModel.h"
#import "MJRefresh.h"
@interface HLHJLiveViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) HLHJLiveHeadView  *liveHeadView;

@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, strong) NSMutableArray  *dataArray;

@end

@implementation HLHJLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"电视";
    ///load UI
    [self initUI];
    self.edgesForExtendedLayout = UIRectEdgeNone;

}


- (void)initUI {
    _liveHeadView = [[HLHJLiveHeadView alloc]initWithFrame:CGRectZero];
     __weak typeof(self) weakSelf = self;
    _liveHeadView.ClickButtonBlock = ^(NSInteger buttonTag) {

        switch (buttonTag) {
            case 100:
            {
                if (self.dataArray.count == 0) {
                    return ;
                }
                HLHJTVViewController *tv = [HLHJTVViewController new];
                tv.tvModel = weakSelf.dataArray[0];
                tv.hidesBottomBarWhenPushed  = YES;
                [weakSelf.navigationController pushViewController:tv animated:YES];
                
            }break;
            case 101:{
                HLHJLiveingViewController *liveing = [HLHJLiveingViewController new];
                liveing.hidesBottomBarWhenPushed  = YES;
                [weakSelf.navigationController pushViewController:liveing animated:YES];
            } break;
            case 102:
            {
                HLHJRadioViewController *radio = [HLHJRadioViewController new];
                radio.hidesBottomBarWhenPushed  = YES;
                [weakSelf.navigationController pushViewController:radio animated:YES];
            } break;
                
            default:
                break;
        }
    };
    [self.view addSubview:_liveHeadView];
    [self.liveHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(110);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.view);
        make.top.equalTo(_liveHeadView.mas_bottom);
    }];
    
    ///NOTE5:下拉刷新加载列表数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataSource];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}
#pragma mark - 加载数据
-(void)getDataSource {
    WS(weakSelf);
    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/tv" parameter:nil successComplete:^(id  _Nullable responseObject) {
        [weakSelf.tableView.mj_header endRefreshing];
        if ([responseObject[@"code"] integerValue] ==1) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray: [NSArray yy_modelArrayWithClass:[HLHJTvModel class] json:responseObject[@"data"]]];
                 [weakSelf.tableView reloadData];
        }
    } failureComplete:^(NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = 0;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"栏目";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        cell.textLabel.textColor = [UIColor blackColor];
    }else {
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor blackColor];
        HLHJTvModel *model = self.dataArray[indexPath.row-1];
        cell.textLabel.text = model.channel_name;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0 ) {
        HLHJTVViewController *tv = [HLHJTVViewController new];
        tv.tvModel = self.dataArray[indexPath.row-1];
        tv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tv animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
#pragma lazy
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
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
