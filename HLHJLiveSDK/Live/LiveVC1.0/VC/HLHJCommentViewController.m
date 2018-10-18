//
//  HLHJCommentViewController.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJCommentViewController.h"
#import "HLHJCommentTableViewCell.h"
#import "UIView+HLHJExtension.h"
#import "HLHJCommentModel.h"
#import "MJRefresh.h"
#import "HLHJLiveShowViewController.h"
#import "HLHJAlertTool.h"

#import <SetI001/SetI001LoginViewController.h>
#import <TMSDK/TMHttpUser.h>
#import "HLHJAlertTool.h"
#import "HLHJLiveDesModel.h"
@interface HLHJCommentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, strong) UIView  *bottomView;

@property (nonatomic, assign) NSInteger  page;

@property (nonatomic, strong) NSMutableArray  *dataArray;

@property (nonatomic,strong) UITextField  *textField;

@end

@implementation HLHJCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
    
    [self initData];
}
- (void)initUI {

    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
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
    
    NSDictionary *prama = @{@"page":@(page),
                            @"live_id":_live_id
                            };
    __weak typeof(self) weakSelf = self;
    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/comment_list" parameter:prama successComplete:^(id  _Nullable responseObject) {
           [weakSelf endRefreshing];
        
//            NSLog(@"--%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            if (weakSelf.page == 1 && weakSelf.dataArray) {
                [weakSelf.dataArray removeAllObjects];
            }
            if ([responseObject[@"comment_status"] integerValue] == 1) {
                [weakSelf.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.bottom.right.equalTo(weakSelf.view);
                    make.height.mas_equalTo(50);
                }];
                [weakSelf updateViewConstraints];
            }else {
                
                [weakSelf.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.bottom.right.equalTo(weakSelf.view);
                    make.height.mas_equalTo(0);
                }];
                [weakSelf updateViewConstraints];
            }
//
            NSArray *arr = [NSArray yy_modelArrayWithClass:[HLHJCommentModel class] json:responseObject[@"data"]];
            if (arr.count > 0) {
                [weakSelf.dataArray addObjectsFromArray:arr];
                [weakSelf.tableView.mj_footer resetNoMoreData];
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
    static NSString *cellID = @"HLHJCommentTableViewCell";
    HLHJCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[HLHJCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
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
    [self.view endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark button click
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (_textField == textField) {
        [[HLHJLiveShowViewController new] setEditing:YES];
        [_textField becomeFirstResponder];
    }else {
        [self.view endEditing:YES];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;//这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}
- (void)sendAction:(UIButton *)sender {
    
    WS(weakSelf);
    if ([TMHttpUser token].length == 0) {
        UIAlertController *alert = [HLHJAlertTool createAlertWithTitle:@"提示" message:@"请先登录" preferred:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *confirmAction) {
            SetI001LoginViewController *ctr = [SetI001LoginViewController new];
            [self.navigationController pushViewController:ctr animated:YES];
            
        } cancleHandler:^(UIAlertAction *cancleAction) {
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }else {

    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/comment" parameter:@{@"live_id":_live_id,@"content":_textField.text,@"token":[TMHttpUser token]} successComplete:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            [weakSelf.tableView.mj_header beginRefreshing];
            _textField.text = @"";
        }
    } failureComplete:^(NSError * _Nonnull error) {
        
    }];
    }
}
- (void)endRefreshing {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
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
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_bottomView addSubview:lineView];

        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zb_fasong"] forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:sendBtn];
        
        
        UITextField *filed = [UITextField new];
        filed.placeholder = @"请输入...";
        filed.backgroundColor = [UIColor groupTableViewBackgroundColor];
        filed.textColor = [UIColor blackColor];
        filed.font = [UIFont systemFontOfSize:14];
        filed.layer.masksToBounds = YES;
        filed.layer.cornerRadius = 20;
        filed.delegate = self;

        UIView *leftView = [UIView new];
        leftView.frame = CGRectMake(0, 0, 10, 10);
        filed.leftView = leftView;
        filed.leftViewMode = UITextFieldViewModeAlways;
        [_bottomView addSubview:filed];
        _textField = filed;
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_bottomView);
            make.height.mas_equalTo(1);
        }];
        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_bottomView.mas_right).mas_offset(-5);
            make.centerY.equalTo(_bottomView);
            make.width.mas_equalTo(40);
        }];

        [filed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(sendBtn);
            make.left.equalTo(_bottomView).offset(15);
            make.right.equalTo(sendBtn.mas_left).offset(-5);
            make.height.mas_equalTo(36);
        }];
        
    }
    
    return _bottomView;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
