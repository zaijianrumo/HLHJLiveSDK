//
//  HLHJNewLiveDetilController.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewLiveDetilController.h"

/** Controllers **/

/** Model **/
#import "HLHJCommentModel.h"
#import "HLHJLiveDesModel.h"
/** Views**/
#import "HLHJNewLiveDetailView.h"
#import "HLHJNewCommentView.h"
#import "HLHJNewLiveCommonListCell.h"
#import "HLHJNewLiveDesCell.h"
#import "MJRefresh.h"
#import "HLHJNewToash.h"
#import "HLHJRotatoUntil.h"
/** #define **/
#import <TMSDK/TMHttpUser.h>
#import <SetI001/SetI001LoginViewController.h>

//#import "IQKeyboardManager.h"

@interface HLHJNewLiveDetilController ()<UITableViewDataSource,UITableViewDelegate,HLHJNewLiveCommonListCellCellDelegate,UITextFieldDelegate,HLHJNewLiveDetailViewDelegate,UINavigationControllerDelegate>


@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, strong) HLHJNewLiveDetailView *movieView;

@property (nonatomic, strong) HLHJNewCommentView    *commView;

@property (nonatomic, strong) HLHJLiveDesModel  *desModel;

@property (nonatomic, assign) NSInteger  page;

@property (nonatomic, strong) NSMutableArray  *commListArray;

///直播ID
@property (nonatomic, copy)   NSString *ID;
///上个页面传过来的参数
@property (nonatomic, strong) NSDictionary *prama;
@end

@implementation HLHJNewLiveDetilController


#pragma mark - LifeCycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.navigationController.delegate = nil;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    self.navigationController.navigationBar.alpha = 0.0;
    
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    

     _prama = [self dictionaryWithJsonString:self.paramStr];
    
     _ID = _prama[@"ID"];

    
    self.movieView  = [[HLHJNewLiveDetailView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 195)  isTv:NO];
    self.movieView .delegate = self;
    [self.view addSubview:self.movieView ];

    HLHJNewCommentView *commView = [[HLHJNewCommentView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    [self.view addSubview:commView];
    self.commView = commView;
    self.commView.commentFiled.delegate = self;
    [self.commView.sendBtn addTarget:self action:@selector(sendContentAction:) forControlEvents:UIControlEventTouchUpInside];
  
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.movieView.frame), self.view.frame.size.width,self.view.frame.size.height- CGRectGetHeight(self.movieView.frame)-  CGRectGetHeight(self.commView.frame));
    
    [self initData];

    [self loadDetailData];
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}


#pragma mark - Delegate/DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.desModel ? 1:0;
    }
    return self.commListArray ? self.commListArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        HLHJNewLiveDesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJNewLiveDesCell"];
        if (self.desModel) {
            cell.model = self.desModel;
        }
        return cell;
    }
    HLHJNewLiveCommonListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJNewLiveCommonListCell"];
    cell.giveLikeBtn.tag = indexPath.row;
    cell.model = self.commListArray[indexPath.row];
    cell.delegate = self;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.commView.commentFiled resignFirstResponder];
    [self sendContentAction:nil];
    return YES;
}

///HLHJNewLiveDetailViewDelegate

- (void)fullScreenAction:(BOOL)flag {
    if (flag) {
        if (self.movieView.state != MovieViewStateSmall) {
            return;
        }
        self.movieView.state = MovieViewStateAnimating;
        
        /*
         * 记录进入全屏前的parentView和frame
         */
        self.movieView.movieViewParentView = self.movieView.superview;
        self.movieView.movieViewFrame = self.movieView.frame;
        
        /*
         * movieView移到window上
         */
        CGRect rectInWindow = [self.movieView convertRect:self.movieView.bounds toView:[UIApplication sharedApplication].keyWindow];
        [self.movieView removeFromSuperview];
        self.movieView.frame = rectInWindow;
        [[UIApplication sharedApplication].keyWindow addSubview:self.movieView];
        
        /*
         * 执行动画
         */
        [UIView animateWithDuration:0.3 animations:^{
            self.movieView.transform = CGAffineTransformMakeRotation(M_PI_2);
            
        self.movieView.bounds = CGRectMake(0, 0, CGRectGetHeight(self.movieView.superview.bounds), CGRectGetWidth(self.movieView.superview.bounds));
            
        self.movieView.center = CGPointMake(CGRectGetMidX(self.movieView.superview.bounds), CGRectGetMidY(self.movieView.superview.bounds));
         
            
        } completion:^(BOOL finished) {
            self.movieView.state = MovieViewStateFullscreen;
        }];
    }else {

        if (self.movieView.state != MovieViewStateFullscreen) {
            return;
        }
        
        self.movieView.state = MovieViewStateAnimating;
        
        CGRect frame = [self.movieView.movieViewParentView convertRect:self.movieView.movieViewFrame toView:[UIApplication sharedApplication].keyWindow];
        [UIView animateWithDuration:0.3 animations:^{
            
            self.movieView.transform = CGAffineTransformIdentity;
            
            self.movieView.frame = frame;
            
        } completion:^(BOOL finished) {
            /*
             * movieView回到小屏位置
             */
            [self.movieView removeFromSuperview];
            self.movieView.frame = self.movieView.movieViewFrame;
            [self.movieView.movieViewParentView addSubview:self.movieView];
            self.movieView.state = MovieViewStateSmall;
        }];
        
    }

}
- (void)navbackAcction {
    
    [self.movieView.playerVC pause];
    
    [self.movieView.playerVC stop];
    
    [self.movieView.playerVC shutdown];
    
    [self.movieView.playerVC.view removeFromSuperview];
    
    self.movieView.playerVC = nil;
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}


//HLHJNewDetailCommonListCellDelegate
///点赞
- (void)giveLikeBtnAction:(UIButton *)sender {
    
    if (![HLHJLoginTool isLogin:self]) return;
    
     HLHJCommentModel *model =  self.commListArray[sender.tag];
    
    NSDictionary *parma = @{@"token":[TMHttpUser token],
                             @"id":_ID,
                             @"type":@"0"
                            };
    MJWeakSelf;
    [HLHJNetworkTool hlhjRequestWithType:POST requestUrl:@"/api/laud" parameter:parma successComplete:^(id  _Nullable responseObject) {
        
        NSInteger  code = [responseObject[@"code"] integerValue];
        
        if (code == 1 ) {
            model.is_laud = !model.is_laud;
            model.laud_num = model.is_laud == YES ? model.laud_num + 1:model.laud_num -1;
            
            [weakSelf.commListArray replaceObjectAtIndex:sender.tag withObject:model];
            //一个cell刷新
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag inSection:1];
            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }
    } failureComplete:^(NSError * _Nonnull error) {
    
    }];
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
                            @"live_id":_ID,
                            @"token":[TMHttpUser token]?[TMHttpUser token]:@""
                            };
    __weak typeof(self) weakSelf = self;
    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/comment_list" parameter:prama successComplete:^(id  _Nullable responseObject) {
        [weakSelf endRefreshing];

        if ([responseObject[@"code"] integerValue] == 1) {
            if (weakSelf.page == 1 && weakSelf.commListArray) {
                [weakSelf.commListArray removeAllObjects];
            }
            if ([responseObject[@"comment_status"] integerValue] == 1) {
                [weakSelf.commView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.bottom.right.equalTo(weakSelf.view);
                    make.height.mas_equalTo(50);
                }];
                [weakSelf updateViewConstraints];
            }else {
                
                [weakSelf.commView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.bottom.right.equalTo(weakSelf.view);
                    make.height.mas_equalTo(0);
                }];
                [weakSelf updateViewConstraints];
            }
            NSArray *arr = [NSArray yy_modelArrayWithClass:[HLHJCommentModel class] json:responseObject[@"data"]];
            if (arr.count > 0) {
                [weakSelf.commListArray addObjectsFromArray:arr];
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
- (void)endRefreshing {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}

-(void)loadDetailData {
    
    WS(weakSelf);
    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/live_detail" parameter:@{@"live_id":_ID,@"token":[TMHttpUser token]?[TMHttpUser token]:@""} successComplete:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            _desModel = [HLHJLiveDesModel yy_modelWithJSON:responseObject[@"data"]];
            weakSelf.movieView.liveDesModel = _desModel;
            weakSelf.movieView.prama = @{@"ID":_desModel.ID,
                                         @"live_source":_desModel.live_source,
                                         @"live_status":_prama[@"live_status"],
                                         @"live_thumb":_prama[@"live_thumb"],
                                         };
        }
        [weakSelf.tableView reloadData];
    } failureComplete:^(NSError * _Nonnull error) {
    }];
}

#pragma mark - Private Methods

#pragma mark - Action Methods
- (void)sendContentAction:(UIButton *)sender {
    
    if([self.commView.commentFiled isFirstResponder]){
        
        [
         self.commView.commentFiled resignFirstResponder];
    }
    if (![HLHJLoginTool isLogin:self]) return;
    
    if (self.commView.commentFiled.text.length == 0) {
        [HLHJNewToash hsShowBottomWithText:@"请输入评论内容"];
        return;
    }
    MJWeakSelf;
    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/comment" parameter:@{@"live_id":_ID,@"content":self.commView.commentFiled.text,@"token":[TMHttpUser token]} successComplete:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            
            [weakSelf.tableView.mj_header beginRefreshing];
            
            weakSelf.commView.commentFiled.text = @"";
        }
    } failureComplete:^(NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark - Getter Methods

#pragma mark - Setter Methods

#pragma lazy
- (NSMutableArray *)commListArray {
    
    if (!_commListArray) {
        _commListArray = [NSMutableArray array];
    }
    return _commListArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 124;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HLHJNewLiveDesCell class] forCellReuseIdentifier:@"HLHJNewLiveDesCell"];
        [_tableView registerClass:[HLHJNewLiveCommonListCell class] forCellReuseIdentifier:@"HLHJNewLiveCommonListCell"];
     
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

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil ;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
