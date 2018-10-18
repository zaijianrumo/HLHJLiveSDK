//
//  HLHJIntroduceViewController.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJIntroduceViewController.h"
#import "HLHJDesTableViewCell.h"
#import "HLHJLiveDesModel.h"
@interface HLHJIntroduceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, strong) HLHJLiveDesModel  *desModel;
@end

@implementation HLHJIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;

     [self initUI];
      ///加载数据
     [self loadData];
}
- (void)initUI {
    
    __weak typeof(self) weakSelf = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
}
-(void)loadData {
    
    WS(weakSelf);
    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/live_detail" parameter:@{@"live_id":_live_id} successComplete:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            _desModel = [HLHJLiveDesModel yy_modelWithJSON:responseObject[@"data"]];
        }
        [weakSelf.tableView reloadData];
    } failureComplete:^(NSError * _Nonnull error) {
 
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"HLHJDesTableViewCell";
    HLHJDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[HLHJDesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = 0;
    }
    NSArray *arr = @[@"标题",@"简介"];
    cell.titLab.text = arr[indexPath.row];
    if (_desModel) {
        NSArray *arr1 = @[_desModel.live_title,_desModel.live_desc];
        cell.desLab.text = arr1[indexPath.row];
    }
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
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 100;
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
