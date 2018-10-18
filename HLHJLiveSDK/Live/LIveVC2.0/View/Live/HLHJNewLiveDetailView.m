//
//  HLHJNewLiveDetailView.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewLiveDetailView.h"
#import "UIImage+HLHJAliExtension.h"


#import "BarrageRenderer.h"
#import "HLHJBarrageModel.h"
#import "HLHJRotatoUntil.h"
#import "HLHJNSSafeObject.h"
#import "HLHJInputToolbar.h"
#import "UIView+HLHJExtension.h"
#import "HLHJAlertTool.h"
#import "HLHJLivePlayViewController.h"
#import <TMSDK/TMHttpUser.h>

#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface HLHJNewLiveDetailView()<BarrageRendererDelegate,HLHJInputToolbarDelegate>

/** 直播开始前的占位图片 */
@property(nonatomic, strong) UIImageView *placeHolderView;
/** 加载指示器 */
@property (nonatomic, strong) UIActivityIndicatorView *activity;
/** 弹幕，评论-Btn */
@property (nonatomic, strong)  UIButton  *isOppenBarrageBtn,*commenBtn;
/** 评论框 */
@property (nonatomic, strong) HLHJInputToolbar *inputToolbar;
/** 弹幕数据源 */
@property (nonatomic, strong) NSMutableArray  *danMuDataArr;
/** YES:电视 .NO：直播****/
@property (nonatomic, assign) BOOL  isTv;
/** 退出全屏或者二级界面****/
@property (nonatomic, assign) BOOL  isExit;

@end

@implementation HLHJNewLiveDetailView{
    
    BarrageRenderer *_renderer;
    NSTimer * _timer;
    NSInteger  _index ;
    
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame isTv:(BOOL )isTV {
    if (self == [super initWithFrame:frame]) {
        
        _isTv = isTV;
        _isExit = NO;
        _index = 0;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}
- (void)setLiveDesModel:(HLHJLiveDesModel *)liveDesModel {
    _liveDesModel = liveDesModel;
    if (_liveDesModel.vote_status == 1) {
        self.isOppenBarrageBtn.hidden = NO;
        self.commenBtn.hidden = NO;
    }else {
        self.isOppenBarrageBtn.hidden = YES;
        self.commenBtn.hidden = YES;
    }
}
- (void)setPrama:(NSDictionary *)prama {

    _prama = prama;

    [self clean];

    self.playerVC.view.frame = self.bounds;
    [self addSubview:self.playerVC.view];

    //1 设置监听
    [self initObserver];

    HLHJNSSafeObject * safeObj = [[HLHJNSSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrageBarrageModel)];

    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];

    ///2 设置弹幕
    _renderer = [[BarrageRenderer alloc] init];
    [self.playerVC.view addSubview:_renderer.view];

    ///4.弹幕数据
    [self loadBarrage];
}
///TV设置URL
- (void)setPlayUrl:(NSString *)playUrl  {

    _playUrl = playUrl;

    [self clean];
    
    self.playerVC.view.frame = self.bounds;
    
    [self addSubview:self.playerVC.view];
}
#pragma mark - InputToolbarDelegate
-(void)setTextViewToolbar {
    
    self.inputToolbar = [[HLHJInputToolbar alloc] initWithFrame:CGRectMake(0,self.frame.size.height, self.frame.size.width, 50)];
    self.inputToolbar.textViewMaxLine = 5;
    self.inputToolbar.delegate = self;
    self.inputToolbar.isRectEdgeNone = YES;
    self.inputToolbar.placeholderLabel.text = @"请输入...";
   [[UIApplication sharedApplication].keyWindow addSubview:self.inputToolbar];
    
}
-(void)inputToolbar:(HLHJInputToolbar *)inputToolbar sendContent:(NSString *)sendContent {
    [self.inputToolbar.textInput  resignFirstResponder];
    [self.inputToolbar removeFromSuperview];
    self.inputToolbar = nil;
    WS(weakSelf);
    [self.inputToolbar.textInput resignFirstResponder];
    if (![HLHJLoginTool isLogin:[HLHJLoginTool getCurrentVC]]) return;
    
        NSDictionary *dict = @{@"token":[TMHttpUser token],
                               @"live_id":_prama[@"ID"],
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

#pragma mark - BarrageRendererDelegate
///加载弹幕数据
- (void)loadBarrage {
    
    WS(weakSelf);
    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/vote_list" parameter:@{@"live_id":_prama[@"ID"]} successComplete:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            [weakSelf.danMuDataArr  addObjectsFromArray: [NSArray yy_modelArrayWithClass :[HLHJBarrageModel class] json:responseObject[@"data"]]];
        }
    } failureComplete:^(NSError * _Nonnull error) {
    }];
}

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
///是否全屏
- (void)isfullscreenAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(fullScreenAction:)]) {
        [self.delegate fullScreenAction:sender.selected];
    }
}
///是否开启弹幕
- (void)oppenBarrageBtnction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    sender.selected ? [_renderer start] : [_renderer stop];
}
///评论 写弹幕
- (void)commenBtnAction:(UIButton *)sender {
    
    ///3.评论框
    [self setTextViewToolbar];
    [self.inputToolbar.textInput becomeFirstResponder];
}

///返回
- (void)nacBackAction:(UIButton *)sender {

    if (self.state == MovieViewStateFullscreen) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(fullScreenAction:)]) {
            [self.delegate fullScreenAction:NO];
        }
        return;
    }
    
    _isExit = YES;
    
    [_timer invalidate];
    
    _timer = nil;
    
    _index = 0;
    
    [self.inputToolbar  removeFromSuperview];
    
    self.inputToolbar = nil;
    
    [_renderer stop];

    if (self.delegate && [self.delegate respondsToSelector:@selector(navbackAcction)]) {
        [self.delegate navbackAcction];
    }
    
}
#pragma mark - 播放器监听
- (void)initObserver
{
    ///1. 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.playerVC];
    
    ///1. 监听视频加载状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.playerVC];
}

- (void)stateDidChange
{
    if ((self.playerVC.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!self.playerVC.isPlaying) {
            [self.playerVC play];
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_placeHolderView) {
                    [_placeHolderView removeFromSuperview];
                    _placeHolderView = nil;
                    [self.playerVC.view addSubview:_renderer.view];
                }
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
- (void)didFinish {
    
    // 因为网速或者其他原因导致直播stop了, 也要显示GIF
    if (self.playerVC.loadState & IJKMPMovieLoadStateStalled) {
        [self showActivityView];
        return;
    }else {
        ///播放完成就退出
        
    }
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
///加载关闭指示器
- (void)stopActivityView{
    if ([_activity isAnimating]) {
        [_activity startAnimating];
    }
    [_activity removeFromSuperview];
    _activity = nil;
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

- (IJKFFMoviePlayerController *)playerVC {
    if (!_playerVC) {
        ///1.播放器
        
        NSString *url = @"";
        if (_isTv) {
            url = _playUrl ?_playUrl:@"";
        }else {
            url = _prama[@"live_source"]?_prama[@"live_source"]:@"";
        }

        _playerVC = [[IJKFFMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:url] withOptions:nil];
        _playerVC.scalingMode = IJKMPMovieScalingModeAspectFit;
        [_playerVC setPauseInBackground:YES];
        [_playerVC prepareToPlay];
        
        NSString *imgurl = _prama[@"live_thumb"] ? [NSString stringWithFormat:@"%@%@",BASE_URL,_prama[@"live_thumb"]]:@"";
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imgurl] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (image) {
                    if ([_prama[@"live_status"] integerValue] == 1) {
                        UIImage *pimage = [UIImage blurImage:image blur:0.5];
                        _playerVC.view.backgroundColor = [UIColor colorWithPatternImage:pimage];
                    }else {
                        _playerVC.view.backgroundColor = [UIColor colorWithPatternImage:image];
                    }
                }
            });
        }];
        ///1. 监听视频加载状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_playerVC];
        
        ///1.左上角返回
        UIButton *navBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [navBackBtn setImage:HLHJImage(@"nav_back") forState:UIControlStateNormal];
        [_playerVC.view  addSubview:navBackBtn];
        [navBackBtn addTarget:self action:@selector(nacBackAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [navBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(_playerVC.view);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(70);
        }];
        navBackBtn.hidden = _isTv ? YES:NO;

        ///2.左边控件View
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = [UIColor clearColor];
        [_playerVC.view addSubview:bottomView];
    
        ///3.弹幕开关
        UIButton  *isOppenBarrageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [isOppenBarrageBtn setImage:HLHJImage(@"ic_close")
                           forState:UIControlStateNormal];
        [isOppenBarrageBtn setImage:HLHJImage(@"ic_open")
                           forState:UIControlStateSelected];
        [isOppenBarrageBtn addTarget:self action:@selector(oppenBarrageBtnction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView  addSubview:isOppenBarrageBtn];
        _isOppenBarrageBtn = isOppenBarrageBtn;
        
        ///3.评论开关
        UIButton *commenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commenBtn setImage:HLHJImage(@"ic_writ")
                   forState:UIControlStateNormal];
        [commenBtn addTarget:self action:@selector(commenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView  addSubview:commenBtn];
        _commenBtn = commenBtn;
        ///4.全屏
        UIButton *fullscreen = [UIButton buttonWithType:UIButtonTypeCustom];
        [fullscreen setImage:HLHJImage(@"ic_fullscr") forState:UIControlStateNormal];
        [fullscreen addTarget:self action:@selector(isfullscreenAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView  addSubview:fullscreen];
        

        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(_playerVC.view);
            make.width.mas_equalTo(50);
        }];
        
        [fullscreen mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bottomView);
            make.bottom.equalTo(bottomView).mas_offset(-20);
        }];
        [commenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bottomView);
            make.bottom.equalTo(fullscreen.mas_top).mas_offset(-20);
        }];
        [isOppenBarrageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bottomView);
            make.bottom.equalTo(commenBtn.mas_top).mas_offset(-20);
        }];
    
        commenBtn.hidden = _isTv  ? YES:NO;
        
        isOppenBarrageBtn.hidden = _isTv ? YES:NO;
        
        
    }
    return _playerVC;
}
- (void)clean {

    [self.playerVC pause];
    [self.playerVC stop];
    [self.playerVC shutdown];
    [self.playerVC.view removeFromSuperview];
    self.playerVC = nil;

}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_isExit) {
        self.playerVC.view.frame = self.bounds;
    }
}
- (NSMutableArray *)danMuDataArr {
    if (!_danMuDataArr) {
        _danMuDataArr = [NSMutableArray array];
    }
    return _danMuDataArr;
}
@end
