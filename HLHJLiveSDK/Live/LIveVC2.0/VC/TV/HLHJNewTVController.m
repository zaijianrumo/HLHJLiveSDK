//
//  HLHJNewTVController.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewTVController.h"

/** Controllers **/

/** Model **/
#import "HLHJTvModel.h"
#import "HLHJProgramModel.h"
/** Views**/
#import "HLHJNewLiveDetailView.h"
#import "HLHJNewTVTimeView.h"
#import "HLHJNewTVColumnView.h"
#import "HLHJTVTableViewCell.h"

/** #define **/

@interface HLHJNewTVController ()<UITableViewDataSource,UITableViewDelegate,HLHJNewLiveDetailViewDelegate>

@property (nonatomic, strong) HLHJNewLiveDetailView *movieView;

@property (nonatomic, strong)  HLHJNewTVColumnView *tvColumn ;

@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, strong) NSMutableArray  *tvNameListArray,*programListArray;

@property (nonatomic, copy) NSString  *tv_id ,*tv_time;

@end

@implementation HLHJNewTVController

@synthesize tvColumn,tv_id,tv_time;

#pragma mark - LifeCycle
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.movieView.playerVC pause];
    [self.movieView.playerVC stop];
    [self.movieView.playerVC shutdown];
    [self.movieView.playerVC.view removeFromSuperview];
    self.movieView.playerVC = nil;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ///加载栏目列表
    [self getTVDataSource];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    ///播放页面
    HLHJNewLiveDetailView *movieView = [[HLHJNewLiveDetailView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 210)  isTv:YES];
    movieView.backgroundColor  = [UIColor lightGrayColor];
    movieView.delegate = self;
    [self.view addSubview:movieView];
    self.movieView = movieView;
    
    tv_time  = [self getCurrentTime];
    
    ///时间
    HLHJNewTVTimeView *timeView = [[HLHJNewTVTimeView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(movieView.frame), self.view.frame.size.width, 42)];
    [self.view addSubview:timeView];


    __block HLHJNewTVController *blockSelf = self;
    timeView.TimeChooseBlock = ^(NSString *time) {
        tv_time = time;
        [blockSelf getTvProgramModel:tv_id programData:time];
    };
    

    ///栏目
   HLHJNewTVColumnView *tvColumnView = [[HLHJNewTVColumnView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(timeView.frame), self.view.frame.size.width, 44)];
    [self.view addSubview:tvColumnView];
    tvColumnView.ColumnChooseBlock = ^(NSString *columnID) {
           tv_id = columnID;
          [blockSelf getTvProgramModel:columnID programData:tv_time];
    };
    tvColumn = tvColumnView;

    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(tvColumnView.frame), self.view.frame.size.width,self.view.frame.size.height - CGRectGetHeight(movieView.frame)-CGRectGetHeight(timeView.frame) - CGRectGetHeight(tvColumnView.frame));
    [self.view addSubview:self.tableView];
}



#pragma mark - Delegate/DataSource Methods


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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.programListArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLHJTVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJTVTableViewCell"];
    cell.model = self.programListArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

#pragma mark - Notification Methods

#pragma mark - KVO Methods

#pragma mark - Public Methods


///MARK:获取电视栏目列表数据
-(void)getTVDataSource {
    WS(weakSelf);
    
    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/tv" parameter:nil successComplete:^(id  _Nullable responseObject) {

        if ([responseObject[@"code"] integerValue] ==1) {
            [weakSelf.tvNameListArray removeAllObjects];
            [weakSelf.tvNameListArray addObjectsFromArray: [NSArray yy_modelArrayWithClass:[HLHJTvModel class] json:responseObject[@"data"]]];
            weakSelf.tvColumn.dataArray = weakSelf.tvNameListArray;
            
            if (weakSelf.tvNameListArray && weakSelf.tvNameListArray.count > 0) {
                HLHJTvModel *model = weakSelf.tvNameListArray[0];
                tv_id = model.ID;
                tv_time = [weakSelf getCurrentTime];
                [weakSelf getTvProgramModel:model.ID programData:[weakSelf getCurrentTime]];
            }
        }
    } failureComplete:^(NSError * _Nonnull error) {
    }];
    
}

///获取电视栏目对应的节目单列表
- (void)getTvProgramModel:(NSString *)tv_id programData:(NSString *)program_data {
    
    WS(weakSelf);
    NSDictionary *param = @{@"tv_id":tv_id,
                            @"program_date":program_data
                            };
    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/program" parameter:param successComplete:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] ==1) {
            [weakSelf.programListArray removeAllObjects];
            HLHJProgramModel *pmodel = [HLHJProgramModel yy_modelWithJSON:responseObject[@"data"]];
            if (pmodel.program) {
                [self.programListArray addObjectsFromArray:pmodel.program];
            }
            weakSelf.movieView.playUrl = pmodel.tv_source;
            [weakSelf.tableView reloadData];
        }
    } failureComplete:^(NSError * _Nonnull error) {
      
    }];
    
}

///获取当前时间
-(NSString*)getCurrentTime {
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * dateTime = [formatter stringFromDate:[NSDate date]];
    return  dateTime;
}

#pragma mark - Private Methods


#pragma mark - Action Methods

#pragma mark - Getter Methods

#pragma mark - Setter Methods
#pragma lazy
- (NSMutableArray *)tvNameListArray {
    if(!_tvNameListArray) {
        
        _tvNameListArray = [NSMutableArray array];
    }
    return _tvNameListArray;
}

- (NSMutableArray *)programListArray {
    
    if (!_programListArray) {
        _programListArray = [NSMutableArray array];
    }
    return _programListArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HLHJTVTableViewCell class] forCellReuseIdentifier:@"HLHJTVTableViewCell"];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
