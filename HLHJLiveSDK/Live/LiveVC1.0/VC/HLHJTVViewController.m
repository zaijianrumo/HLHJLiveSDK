//
//  HLHJTVViewController.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJTVViewController.h"
#import "HLHJTVTableViewCell.h"
#import "HLHJTVOneTableViewCell.h"
#import "HLHJLivePlayViewController.h"
#import "IJKMediaFramework.framework/Headers/IJKFFOptions.h"
#import "IJKMediaFramework.framework/Headers/IJKFFMoviePlayerController.h"
#import "HLHJProgramModel.h"
#import "MJRefresh.h"
#import "UIImage+HLHJAliExtension.h"
@interface HLHJTVViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, strong) UIView *videoView;

@property (nonatomic, strong)IJKFFMoviePlayerController *playerVC;

@property (nonatomic, strong) NSMutableArray  *dataArray;

@property (nonatomic, copy) NSString  *program_date;

/** 加载指示器 */
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end

@implementation HLHJTVViewController
#pragma mark - 当离开当前直播间的时候，要停止播放
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.playerVC pause];
        [self.playerVC stop];
        [self.playerVC shutdown];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"电视栏目";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.program_date = [self getCurrentTime];
    
    [self initUI];
}
- (void)initUI {
    __weak typeof(self) weakSelf = self;
    
    [self.view addSubview:self.videoView];
    [self.view addSubview:self.tableView];
    
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
        make.height.mas_equalTo(180);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.videoView.mas_bottom);
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
    NSDictionary *param = @{@"tv_id":_tvModel.ID,
                            @"program_date":self.program_date
                            };
    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/program" parameter:param successComplete:^(id  _Nullable responseObject) {
        [weakSelf.tableView.mj_header endRefreshing];
        if ([responseObject[@"code"] integerValue] ==1) {
            [self.dataArray removeAllObjects];
            HLHJProgramModel *pmodel = [HLHJProgramModel yy_modelWithJSON:responseObject[@"data"]];
            if (pmodel.program) {
                [self.dataArray addObjectsFromArray:pmodel.program];
            }
            [weakSelf.tableView reloadData];
        }
    } failureComplete:^(NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
    {
        return 1;
    }
    return self.dataArray?self.dataArray.count:0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        HLHJTVOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJTVOneTableViewCell"];
        
        WS(weakSelf);
        cell.TimeChooseBlock = ^(NSString *time) {
            weakSelf.program_date = time;
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        return cell;
    }
    
      HLHJTVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJTVTableViewCell"];
        if (self.dataArray && self.dataArray.count > 0) {
            ProgramModel *model = self.dataArray[indexPath.row];
            cell.model = model;
        
        }
            return cell;
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return .1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

-(void)isfullscreenAction:(UIButton *)sender {

    if (_tvModel.tv_source.length > 0) {
        [self.playerVC pause];
        HLHJLivePlayViewController *livePlay = [[HLHJLivePlayViewController alloc]init];
        livePlay.stream_addr = _tvModel.tv_source;
        livePlay.isTVPlay = YES;
        livePlay.live_id = _tvModel.ID;
        livePlay.portrait = [NSString stringWithFormat:@"%@%@",BASE_URL,_tvModel.channel_thumb];
        [self presentViewController:livePlay animated:YES completion:nil];
        WS(weakSelf);
        livePlay.dismissBlock = ^{
            [weakSelf.playerVC play];
        };
    }

}

-(void)isPlayAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.playerVC pause];
    }else {
        [self.playerVC play];
    }
}
#pragma mark - IJKFFMoviePlayerController Notification
- (void)tvPlayerStateDidChange {
    if ((self.playerVC.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!self.playerVC.isPlaying) {
            [self.playerVC play];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.playerVC.view.backgroundColor  = [UIColor whiteColor];
                [self stopActivityView];
            });
        }else{
            // 如果是网络状态不好, 断开后恢复, 也需要去掉加载
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self stopActivityView];
            });
         
            [self.playerVC play];
        }
    }else if (self.playerVC.loadState & IJKMPMovieLoadStateStalled){ // 网速不佳, 自动暂停状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showActivityView];
            });
            
        });
    }
}
///加载指示器
- (void)showActivityView{
    if (!_activity) {
        _activity= [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    [self.activity startAnimating];
    [self.playerVC.view addSubview:self.activity];
    WS(weakSelf);
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.activity.mas_height);
        make.width.mas_equalTo(100);
        make.centerY.equalTo(weakSelf.playerVC.view);
        make.centerX.equalTo(weakSelf.playerVC.view);
    }];
}
///加载关闭指示器
- (void)stopActivityView{
    if ([_activity isAnimating]) {
        [_activity startAnimating];
    }
    [_activity removeFromSuperview];
    _activity = nil;
}
#pragma lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[HLHJTVOneTableViewCell class] forCellReuseIdentifier:@"HLHJTVOneTableViewCell"];
        
        [_tableView registerClass:[HLHJTVTableViewCell class]
           forCellReuseIdentifier:@"HLHJTVTableViewCell"];
        
    }
    return _tableView;
}

- (UIView *)videoView {
    if (!_videoView) {
        _videoView = [UIView new];
        _videoView.backgroundColor = [UIColor whiteColor];
        //1.播放器
        IJKFFMoviePlayerController *FFvc = [[IJKFFMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:_tvModel.tv_source?_tvModel.tv_source:@""] withOptions:nil];
        ///需要强引用
        self.playerVC = FFvc;
        self.playerVC.scalingMode = IJKMPMovieScalingModeAspectFit;
        [self.playerVC prepareToPlay];
       
        [_videoView addSubview:self.playerVC.view];
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,_tvModel.channel_thumb?_tvModel.channel_thumb:@""]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(image){
                   UIImage *pimage = [UIImage blurImage:image blur:0.8];
                  _playerVC.view.backgroundColor = [UIColor colorWithPatternImage:pimage];
                }
            });
        }];
        
        ///1. 监听视频加载状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tvPlayerStateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_playerVC];
        
        ///1.底部控件View
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = [UIColor clearColor];
        [self.playerVC.view addSubview:bottomView];
        
        ///2.小屏/全屏
        UIButton *fullscreen = [UIButton buttonWithType:UIButtonTypeCustom];
        [fullscreen setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_xw_quanping"] forState:UIControlStateNormal];
        [fullscreen setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_xw_quanping"] forState:UIControlStateSelected];
        [fullscreen addTarget:self action:@selector(isfullscreenAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView  addSubview:fullscreen];

        ///3.暂停/播放
        UIButton *buttonPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonPlay setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_xw_bofang"] forState:UIControlStateSelected];
        [buttonPlay setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_xw_zanting"] forState:UIControlStateNormal];
        [buttonPlay addTarget:self action:@selector(isPlayAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:buttonPlay];

        ///4.设置约束
        [self.playerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_videoView);
        }];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_playerVC.view);
            make.height.mas_equalTo(50);
        }];
        
        [fullscreen mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bottomView).mas_offset(-10);
            make.bottom.equalTo(bottomView).mas_offset(-10);
        }];
        
        [buttonPlay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomView).mas_offset(10);
            make.bottom.equalTo(bottomView).mas_offset(-10);
        }];

    }
    return  _videoView;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
///获取当前时间
-(NSString*)getCurrentTime {
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * dateTime = [formatter stringFromDate:[NSDate date]];
    return  dateTime;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
