//
//  HLHJNewRadioController.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewRadioController.h"

/** Controllers **/
#import "HLHJNewRadioPalyController.h"
#import "IJKMediaFramework.framework/Headers/IJKFFOptions.h"
#import "IJKMediaFramework.framework/Headers/IJKFFMoviePlayerController.h"
/** Model **/
#import "HLHJRadioModel.h"
/** Views**/
#import "HLHJNewRadioCell.h"
#import "HLHJNewRadioHeadView.h"
#import "MJRefresh.h"
/** #define **/
#define  ImageHeight 181

@interface HLHJNewRadioController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView  *tableView;
//底层背景图
@property(nonatomic,strong)   UIImageView     *zoomImageView;

@property (nonatomic, assign) NSInteger  page;

@property (nonatomic, strong) NSMutableArray  *radioListArray;

@property (nonatomic, strong) UILabel  *titlelab;

@property (nonatomic, strong) HLHJRadioModel *radioModel;

@property (nonatomic, strong)IJKFFMoviePlayerController *playerVC;

@end

@implementation HLHJNewRadioController

@synthesize radioModel;

#pragma mark - LifeCycle

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stop];
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(ImageHeight, 0, 0, 0);
    
    self.zoomImageView = [[UIImageView alloc]init];
    self.zoomImageView.frame = CGRectMake(0, -ImageHeight ,self.view.frame.size.width,ImageHeight);
    self.zoomImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.zoomImageView addSubview:self.titlelab];
    
    
    [self.tableView addSubview:self.zoomImageView];
    
    [self initData];
}

#pragma mark - Delegate/DataSource Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
      //根据实际选择加不加上NavigationBarHeigth
      CGFloat y = scrollView.contentOffset.y;
      if(  y < -ImageHeight){
        CGRect frame=self.zoomImageView.frame;
        frame.origin.y=y;
        frame.size.height=-y;
        self.zoomImageView.frame=frame;
          
         self.titlelab.frame = CGRectMake(0,self.zoomImageView.frame.size.height - 40, self.zoomImageView.frame.size.width, 20);
      }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.radioListArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLHJNewRadioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJNewRadioCell"];
    [cell.isPlayStatuBtn addTarget:self action:@selector(isPlayAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.model = self.radioListArray[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


    [self stop];

    HLHJNewRadioPalyController *raidoPlay  = [HLHJNewRadioPalyController new];
    raidoPlay.hidesBottomBarWhenPushed = YES;
    raidoPlay.model = radioModel;
    raidoPlay.chooseIndex = indexPath.row;
    raidoPlay.native = YES;

    ListRadioModel *model = self.radioListArray[indexPath.row];
    model.isSelect =  NO;
    [self.radioListArray replaceObjectAtIndex:indexPath.row withObject:model];
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexpath,nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.navigationController pushViewController:raidoPlay animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    HLHJNewRadioHeadView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HLHJNewRadioHeadView"];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor whiteColor];
    }
}

#pragma lazy
- (NSMutableArray *)radioListArray {
    
    if (!_radioListArray) {
        _radioListArray = [NSMutableArray array];
    }
    return _radioListArray;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HLHJNewRadioCell class] forCellReuseIdentifier:@"HLHJNewRadioCell"];
        [_tableView registerClass:[HLHJNewRadioHeadView class] forHeaderFooterViewReuseIdentifier:@"HLHJNewRadioHeadView"];
    }
    return _tableView;
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
    
    NSDictionary *prama = @{@"page":@(page)
                            };
    __weak typeof(self) weakSelf = self;
    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/radio" parameter:prama successComplete:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {

            radioModel = [HLHJRadioModel yy_modelWithJSON:responseObject[@"data"]];
            [weakSelf.zoomImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,radioModel.banner]] placeholderImage:HLHJImage(@"img_gb_bg")];

            weakSelf.titlelab.text = radioModel.title;
            if (radioModel.list.count > 0) {
                 [self stop];
                    if (self.page == 1 && self.radioListArray) {
                    [self.radioListArray removeAllObjects];
                }
                [self.radioListArray addObjectsFromArray:radioModel.list];
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

- (void)isPlayAction:(UIButton *)sender {
    
    
    sender.selected = !sender.selected;
    
    //如果将Button添加在myCell.contentView 中，
    HLHJNewRadioCell *cell = (HLHJNewRadioCell *)[[sender superview] superview];

    cell.isPlayStatuBtn.selected = sender.selected;

    NSIndexPath *cellPath = [self.tableView indexPathForCell:cell];

    ListRadioModel  *model  = self.radioListArray[cellPath.row];

    if (!sender.selected) {
        
        [self stop];

        model.isSelect = NO;
        
    }else {

        model.isSelect = YES;

        [self stop];

        self.playerVC = [[IJKFFMoviePlayerController alloc]initWithContentURL:[NSURL
                                                                               URLWithString:model.radio_source ? model.radio_source : @""] withOptions:nil];
        self.playerVC.view.frame = CGRectMake(0, 0, ScreenW, .2);
        self.playerVC.view.backgroundColor = [UIColor clearColor];
        self.playerVC.scalingMode = IJKMPMovieScalingModeAspectFit;
        [self.playerVC prepareToPlay];
        
    }
        for (NSInteger i = 0 ; i < self.radioListArray.count ; i++) {
             ListRadioModel *listModel = self.radioListArray[i];
            if (cellPath.row == i) {
                 [self.radioListArray replaceObjectAtIndex:cellPath.row withObject:model];
            }else {
                 listModel.isSelect = NO;
                 [self.radioListArray replaceObjectAtIndex:i withObject:listModel];
            }
        }
     [self.tableView reloadData];
}

#pragma mark - Getter Methods

#pragma mark - Setter Methods
- (UILabel *)titlelab {
    if (!_titlelab) {

        _titlelab = [[UILabel alloc] init];
        _titlelab.text = @"";
        _titlelab.frame = CGRectMake(0,self.zoomImageView.frame.size.height - 40, self.zoomImageView.frame.size.width, 20);
        _titlelab.numberOfLines = 0;
        _titlelab.textAlignment = NSTextAlignmentCenter;
        _titlelab.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:16];
        _titlelab.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    }
    return _titlelab;
    
}

- (void)stop {
    [self.playerVC pause];
    [self.playerVC stop];
    [self.playerVC shutdown];
    [self.playerVC.view removeFromSuperview];
    self.playerVC= nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
