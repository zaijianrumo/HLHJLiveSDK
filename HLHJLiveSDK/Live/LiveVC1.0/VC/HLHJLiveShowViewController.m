//
//  HLHJLiveShowViewController.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJLiveShowViewController.h"
#import "HLHJIntroduceViewController.h"
#import "HLHJCommentViewController.h"
#import "HLHJLivePlayViewController.h"
#import "HLHJGraphicLiveViewController.h"
#import "IJKMediaFramework.framework/Headers/IJKFFOptions.h"
#import "IJKMediaFramework.framework/Headers/IJKFFMoviePlayerController.h"

#import <SetI001/SetI001LoginViewController.h>
#import <TMSDK/TMHttpUser.h>
#import "HLHJAlertTool.h"
#import "UIImage+HLHJAliExtension.h"
#import "UIView+HLHJExtension.h"
#import "BarrageRenderer.h"
#import "HLHJInputToolbar.h"
#import "HLHJNSSafeObject.h"
#import "HLHJBarrageModel.h"
#import "HLHJLiveDesModel.h"
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface HLHJLiveShowViewController ()<HLHJInputToolbarDelegate>

@property (nonatomic, strong)IJKFFMoviePlayerController *playerVC;
/** 评论框 */
@property (nonatomic, strong) HLHJInputToolbar *inputToolbar;

@property (nonatomic, strong) NSArray *titleData;
/** 加载指示器 */
@property (nonatomic, strong) UIActivityIndicatorView *activity;
/** 弹幕数据源 */
@property (nonatomic, strong) NSMutableArray  *danMuDataArr;

@property (nonatomic, strong)  UIButton  *isOppenBarrageBtn;

@property (nonatomic, strong)  UIButton  *commenBtn;

@property (nonatomic, strong) HLHJLiveDesModel *liveDesModel;


@end

static NSInteger  KHeight = 175;
@implementation HLHJLiveShowViewController
{
    BarrageRenderer *_renderer;
    NSTimer * _timer;
    NSInteger  _index ;
}
#pragma mark 标题数组
- (NSArray *)titleData {
    
    if(_model.live_status == 2) {
        return  @[@"简介",@"直播",@"评论"];
    }else {
        return @[@"简介",@"评论"];
    }
}
#pragma mark - 当离开当前直播间的时候，要停止播放
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.playerVC pause];
        [self.playerVC stop];
        [self.playerVC shutdown];
        [_timer invalidate];
        _timer = nil;
        _index = 0;
        [self.inputToolbar  removeFromSuperview];
        self.inputToolbar = nil;
        [_renderer stop];
    }
}
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.titleSizeSelected = 14.0f;
        self.titleSizeNormal = 14.0f;
        self.titleColorNormal = [UIColor blackColor];
        self.titleColorSelected = [UIColor redColor];
        self.menuViewStyle = WMMenuViewStyleLine;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    _index = 0;
    
    self.navigationItem.title = @"直播";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.playerVC.view];
    WS(weakSelf);
    [self.playerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(KHeight);
    }];
    
    UIView *lineView= [UIView new];
    lineView.backgroundColor =[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.playerVC.view.mas_bottom).mas_offset(40);
        make.height.mas_equalTo(1);
    }];
    
    HLHJNSSafeObject * safeObj = [[HLHJNSSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrageBarrageModel)];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];

    ///7 设置弹幕
    _renderer = [[BarrageRenderer alloc] init];
    [self.playerVC.view addSubview:_renderer.view];
    ///4.弹幕
    [self loadBarrage];
    
    ///是否开启弹幕;
    [self loadData];
    
}
-(void)loadData {
    
    WS(weakSelf);
    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/live_detail" parameter:@{@"live_id":_model.ID} successComplete:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            _liveDesModel = [HLHJLiveDesModel yy_modelWithJSON:responseObject[@"data"]];
            if (_liveDesModel.vote_status == 1) {
                weakSelf.isOppenBarrageBtn.hidden = NO;
                weakSelf.commenBtn.hidden = NO;
            }else {
                weakSelf.isOppenBarrageBtn.hidden = YES;
                weakSelf.commenBtn.hidden = YES;
            }
        }
    } failureComplete:^(NSError * _Nonnull error) {
        
    }];
}
- (void)loadBarrage {
    
    WS(weakSelf);
    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/vote_list" parameter:@{@"live_id":_model.ID,} successComplete:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            [weakSelf.danMuDataArr  addObjectsFromArray: [NSArray yy_modelArrayWithClass :[HLHJBarrageModel class] json:responseObject[@"data"]]];
        }
    } failureComplete:^(NSError * _Nonnull error) {
    }];
}

#pragma mark - InputToolbarDelegate
-(void)setTextViewToolbar {
    
    self.inputToolbar = [[HLHJInputToolbar alloc] initWithFrame:CGRectMake(0,self.view.height, self.view.width, 50)];
    self.inputToolbar.textViewMaxLine = 5;
    self.inputToolbar.delegate = self;
    self.inputToolbar.placeholderLabel.text = @"请输入...";
    [self.view addSubview:self.inputToolbar];
}
-(void)inputToolbar:(HLHJInputToolbar *)inputToolbar sendContent:(NSString *)sendContent {
     [self.inputToolbar.textInput  resignFirstResponder];
     [self.inputToolbar removeFromSuperview];
     self.inputToolbar = nil;
 
    WS(weakSelf);
    if ([TMHttpUser token].length == 0) {
        ///1.返回后切换为竖屏
        
        UIAlertController *alert = [HLHJAlertTool createAlertWithTitle:@"提示" message:@"请先登录" preferred:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *confirmAction) {
            
            SetI001LoginViewController *ctr = [SetI001LoginViewController new];
            [weakSelf.playerVC pause];
            [self.navigationController pushViewController:ctr animated:YES];
            
        } cancleHandler:^(UIAlertAction *cancleAction) {
            
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        
        NSDictionary *dict = @{@"token":[TMHttpUser token],
                               @"live_id":_model.ID,
                               @"vote_content":sendContent
                               };
        [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/public_vote" parameter:dict successComplete:^(id  _Nullable responseObject) {
            if ([responseObject[@"code"] integerValue] == 1) {
                
                HLHJBarrageModel *model = [[HLHJBarrageModel alloc]init];
                model.content = sendContent;
                [weakSelf.danMuDataArr addObject:model];
                if (_isOppenBarrageBtn.selected == YES) {
                    [_timer setFireDate:[NSDate date]];
                }
            }
        } failureComplete:^(NSError * _Nonnull error) {
            
        }];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.inputToolbar.textInput resignFirstResponder];
}
#pragma mark - BarrageRendererDelegate
- (void)autoSendBarrageBarrageModel
{
    if (self.danMuDataArr.count > 0) {
        
        _index ++;
        if (_index >= self.danMuDataArr.count) {
            [_timer setFireDate:[NSDate distantFuture]];
            _index = _index -1;
            return;
        }
        HLHJBarrageModel *model  = self.danMuDataArr[_index];
        NSInteger spriteNumber = [_renderer spritesNumberWithName:nil];
        if (spriteNumber <= 50) { // 限制屏幕上的弹幕量
            [_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L barrageModel:model]];
        }
    }
    
}
/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction barrageModel:(HLHJBarrageModel *)model {
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = model.content ? model.content :@"";
    descriptor.params[@"textColor"] = Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"clickAction"] = ^{
    };
    return descriptor;
}
#pragma mark 返回子页面的个数
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {

    return self.titleData.count;
}
#pragma mark --
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    return self.titleData[index];
    
}
#pragma mark 返回子页面的个数
- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
             HLHJIntroduceViewController *vc = [[HLHJIntroduceViewController alloc] init];
            vc.live_id = _model.ID;
            return vc;
        } break;
        case 1:{
            
            if(_model.live_status == 2)
            {
                HLHJGraphicLiveViewController *vc = [[HLHJGraphicLiveViewController alloc] init];
                vc.live_id = _model.ID;
                return vc;
            }else {
                HLHJCommentViewController *vc = [[HLHJCommentViewController alloc] init];
                vc.live_id = _model.ID;
                return vc;
            }
        }break;
        case 2:{
               HLHJCommentViewController *vc = [[HLHJCommentViewController alloc] init];
               vc.live_id = _model.ID;
            return vc;
            
        }break;
        default:{
              HLHJIntroduceViewController *vc = [[HLHJIntroduceViewController alloc] init];
              vc.live_id = _model.ID;
              return vc;
        }
             break;
    }
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    
    return CGRectMake(0, KHeight, ScreenW, 40);
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    
    return CGRectMake(0, KHeight+41, ScreenW, (ScreenH-KHeight-41-kSNavBarHeight));
    
}
- (void)isfullscreenAction:(UIButton *)sender {
    
    [self.playerVC pause];
    HLHJLivePlayViewController *livePlay = [HLHJLivePlayViewController new];
    livePlay.portrait = [NSString stringWithFormat:@"%@%@",BASE_URL,_model.live_thumb];
    livePlay.stream_addr = _model.live_source;
    livePlay.live_id = _model.ID;
    livePlay.isTVPlay = _liveDesModel.vote_status == 1 ? NO: YES;
    [self presentViewController:livePlay animated:YES completion:nil];
    WS(weakSelf);
    livePlay.dismissBlock = ^{
        [weakSelf.playerVC play];
    };
}
- (void)oppenBarrageBtnction:(UIButton *)sender {
       sender.selected = !sender.selected;
       sender.selected ? [_renderer start] : [_renderer stop];
}
- (void)commenBtnAction:(UIButton *)sender {
    ///3.评论框
    [self setTextViewToolbar];
    [self.inputToolbar.textInput  becomeFirstResponder];
    
}
#pragma mark - IJKFFMoviePlayerController Notification
- (void)playerStateDidChange {
    if ((self.playerVC.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!self.playerVC.isPlaying) {
            [self.playerVC play];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.playerVC.view.backgroundColor  = [UIColor whiteColor];
                [self stopActivityView];
            });
        }else{
            // 如果是网络状态不好, 断开后恢复, 也需要去掉加载
            [self stopActivityView];
            [self.playerVC play];
        }
    }else if (self.playerVC.loadState & IJKMPMovieLoadStateStalled){ // 网速不佳, 自动暂停状态
           [self showActivityView];
    }
}
- (NSMutableArray *)danMuDataArr {
    if (!_danMuDataArr) {
        _danMuDataArr = [NSMutableArray array];
    }
    return _danMuDataArr;
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
- (IJKFFMoviePlayerController *)playerVC {
    if (!_playerVC) {
        ///1.播放器
        _playerVC = [[IJKFFMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:_model.live_source?_model.live_source:@""] withOptions:nil];
        _playerVC.scalingMode = IJKMPMovieScalingModeAspectFit;
        [_playerVC prepareToPlay];
  
    
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,_model.live_thumb?_model.live_thumb:@""]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (image) {
                    if (_model.live_status == 1) {
                        UIImage *pimage = [UIImage blurImage:image blur:0.8];
                        _playerVC.view.backgroundColor = [UIColor colorWithPatternImage:pimage];
                    }else {
                        _playerVC.view.backgroundColor = [UIColor colorWithPatternImage:image];
                    }
                }
            });
        }];
        ///1. 监听视频加载状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_playerVC];
        
        ///2.左边控件View
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = [UIColor clearColor];
          [_playerVC.view addSubview:bottomView];
        if (_model.live_status != 1) {
            return _playerVC;
        }
        ///3.弹幕开关
        UIButton  *isOppenBarrageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [isOppenBarrageBtn setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zhibo_danmu1"]
                           forState:UIControlStateNormal];
        [isOppenBarrageBtn setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zhibo_danmu"]
                           forState:UIControlStateSelected];
        [isOppenBarrageBtn addTarget:self action:@selector(oppenBarrageBtnction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView  addSubview:isOppenBarrageBtn];
        _isOppenBarrageBtn = isOppenBarrageBtn;
        
        ///3.评论开关
        UIButton *commenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commenBtn setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zhibo_xiedanmu"]
                   forState:UIControlStateNormal];
        [commenBtn addTarget:self action:@selector(commenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView  addSubview:commenBtn];
        _commenBtn = commenBtn;
        ///4.全屏
        UIButton *fullscreen = [UIButton buttonWithType:UIButtonTypeCustom];
        [fullscreen setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_xw_quanping"] forState:UIControlStateNormal];
        [fullscreen setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_xw_quanping"] forState:UIControlStateSelected];
        [fullscreen addTarget:self action:@selector(isfullscreenAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView  addSubview:fullscreen];
        
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(_playerVC.view);
            make.width.mas_equalTo(50);
        }];
        
        [fullscreen mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(bottomView.mas_bottom).mas_offset(-10);
            make.centerX.equalTo(bottomView);
        }];
        
        [commenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(fullscreen.mas_top).mas_offset(-20);
            make.centerX.equalTo(fullscreen);
        }];
        [isOppenBarrageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(commenBtn.mas_top).mas_offset(-20);
            make.centerX.equalTo(fullscreen);
        }];
        
        
        
    }
    return _playerVC;
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
