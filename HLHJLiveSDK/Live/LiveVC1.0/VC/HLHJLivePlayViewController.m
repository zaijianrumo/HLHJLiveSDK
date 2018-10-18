//
//  HLHJLivePlayViewController.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJLivePlayViewController.h"
#import "IJKMediaFramework.framework/Headers/IJKFFOptions.h"
#import "IJKMediaFramework.framework/Headers/IJKFFMoviePlayerController.h"
#import "UIImage+HLHJAliExtension.h"

#import "BarrageRenderer.h"
#import "HLHJBarrageModel.h"
#import "HLHJRotatoUntil.h"
#import "HLHJNSSafeObject.h"
#import "HLHJInputToolbar.h"
#import "UIView+HLHJExtension.h"
#import "HLHJAlertTool.h"

#import "TMSDK.framework/Headers/TMHttpUser.h"
#import <SetI001/SetI001LoginViewController.h>

#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface HLHJLivePlayViewController ()<BarrageRendererDelegate,HLHJInputToolbarDelegate>

/** 直播播放器 */
@property (nonatomic, strong)IJKFFMoviePlayerController *playerVC;
/** 直播开始前的占位图片 */
@property(nonatomic, strong) UIImageView *placeHolderView;
/** 加载指示器 */
@property (nonatomic, strong) UIActivityIndicatorView *activity;
/** 弹幕开关按钮 */
@property (nonatomic, strong) UIButton  *isOppenBarrageBtn;
/** 评论 */
@property (nonatomic, strong) UIButton  *commenBtn;
/** 返回 */
@property (nonatomic, strong) UIButton  *backBtn;
/** 评论框 */
@property (nonatomic, strong) HLHJInputToolbar *inputToolbar;
/** 弹幕数据源 */
@property (nonatomic, strong) NSMutableArray  *danMuDataArr;

@end

@implementation HLHJLivePlayViewController{
    
    BarrageRenderer *_renderer;
    NSTimer * _timer;
    NSInteger  _index ;

}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
    _index = 0;
    [_renderer stop];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
// 支持设备自动旋转
- (BOOL)shouldAutorotate {
    return NO;
}
 - (void)viewDidLoad {
    [super viewDidLoad];
    
    _index = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    ///1.强行切换为横屏
    [HLHJRotatoUntil forceOrientation: UIInterfaceOrientationLandscapeRight];
    ///2.set UI
    [self initUI];
    ///3.评论框
    [self setTextViewToolbar];
    ///4.弹幕
    [self loadBarrage];
    
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscapeRight;
    
}
- (void)initUI {

    if (_playerVC) {
        if (_playerVC) {
            [self.view insertSubview:self.placeHolderView aboveSubview:_playerVC.view];
        }
        [_playerVC shutdown];
        [_playerVC.view removeFromSuperview];
        _playerVC = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_portrait] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showActivityView];
            if (image) {
                self.placeHolderView.image = [UIImage blurImage:image blur:0.8];
            } 
        });
    }];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
    IJKFFMoviePlayerController *FFvc = [[IJKFFMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:_stream_addr] withOptions:options];
    ///需要强引用
    self.playerVC = FFvc;
    
    self.playerVC.scalingMode = IJKMPMovieScalingModeAspectFit;
    ///1 设置自动播放(必须设置为NO, 防止自动播放, 才能更好的控制直播的状态)
    self.playerVC.shouldAutoplay = NO;
    ///2 默认不显示
    self.playerVC.shouldShowHudView = NO;
    [self.playerVC prepareToPlay];
    self.playerVC.view.frame = [UIScreen mainScreen].bounds;
    [self.view insertSubview:_playerVC.view atIndex:1];

    ///3 返回按钮
    [_playerVC.view addSubview:self.backBtn];
    
    WS(weakSelf);
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.playerVC.view).mas_offset(15);
        make.top.equalTo(weakSelf.playerVC.view).mas_offset(15);
    }];
    
    if (!self.isTVPlay) {
        ///4 弹幕按钮
        [_playerVC.view  addSubview:self.isOppenBarrageBtn];
        ///5 评论按钮
        [_playerVC.view addSubview:self.commenBtn];
        
        [self.isOppenBarrageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.playerVC.view).mas_offset(-15);
            make.centerY.equalTo(weakSelf.playerVC.view).mas_offset(-20);
        }];
        [self.commenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.isOppenBarrageBtn);
            make.top.equalTo(weakSelf.isOppenBarrageBtn.mas_bottom).mas_offset(20);
        }];
    }

    ///6 设置监听
    [self initObserver];
    
    ///7 设置弹幕
    _renderer = [[BarrageRenderer alloc] init];
    [self.view addSubview:_renderer.view];
    
    HLHJNSSafeObject * safeObj = [[HLHJNSSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrageBarrageModel)];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
    
}
#pragma mark - InputToolbarDelegate
-(void)setTextViewToolbar {
    
    self.inputToolbar = [[HLHJInputToolbar alloc] initWithFrame:CGRectMake(0,self.view.height, self.view.height, 50)];
    self.inputToolbar.textViewMaxLine = 5;
    self.inputToolbar.delegate = self;
    self.inputToolbar.isRectEdgeNone = YES;
    self.inputToolbar.placeholderLabel.text = @"请输入...";
    [self.view addSubview:self.inputToolbar];
}
-(void)inputToolbar:(HLHJInputToolbar *)inputToolbar sendContent:(NSString *)sendContent {

    [self.inputToolbar.textInput resignFirstResponder];
     WS(weakSelf);
    if ([TMHttpUser token].length == 0) {
        ///1.返回后切换为竖屏
        [HLHJRotatoUntil forceOrientation: UIInterfaceOrientationPortrait];
    
        UIAlertController *alert = [HLHJAlertTool createAlertWithTitle:@"提示" message:@"请先登录" preferred:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *confirmAction) {
            
            SetI001LoginViewController *ctr = [SetI001LoginViewController new];
            [weakSelf.playerVC pause];
            ctr.paramStr = @"{\"needDismiss\":\"true\"}";
            [weakSelf presentViewController:ctr animated:YES completion:nil];
            
        } cancleHandler:^(UIAlertAction *cancleAction) {
            
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
    NSDictionary *dict = @{@"token":[TMHttpUser token],
                           @"live_id":_live_id,
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
- (void)loadBarrage {
    
    WS(weakSelf);
    [HLHJNetworkTool hlhjRequestWithType:GET requestUrl:@"/api/vote_list" parameter:@{@"live_id":_live_id,} successComplete:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            [weakSelf.danMuDataArr  addObjectsFromArray: [NSArray yy_modelArrayWithClass :[HLHJBarrageModel class] json:responseObject[@"data"]]];
        }
    } failureComplete:^(NSError * _Nonnull error) {
    }];
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
- (void)didFinish
{
 
    // 因为网速或者其他原因导致直播stop了, 也要显示GIF
    if (self.playerVC.loadState & IJKMPMovieLoadStateStalled) {
        [self showActivityView];
        return;
    }else {
        ///播放完成就退出
        [self backAction];
    }
}


#pragma mark - 点击事件方法
- (void)backAction{
    
    ///1.返回后切换为竖屏
    [HLHJRotatoUntil forceOrientation: UIInterfaceOrientationPortrait];
    if (_playerVC) {
        [self.playerVC shutdown];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    [_renderer stop];
    [_renderer.view removeFromSuperview];
     _renderer = nil;
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
     if (_dismissBlock) {
        _dismissBlock();
    }
    
}

- (void)oppenBarrageBtnction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    sender.selected ? [_renderer start] : [_renderer stop];
}
- (void)commenBtnAction:(UIButton *)sender {
    [self.inputToolbar.textInput becomeFirstResponder];
}
#pragma mark - getter & setter methods
- (UIButton *)backBtn {

    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zb_guanbi"]
                  forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn ;
}
- (UIButton *)isOppenBarrageBtn {
    if (!_isOppenBarrageBtn) {
        _isOppenBarrageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_isOppenBarrageBtn setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zhibo_danmu1"]
                  forState:UIControlStateNormal];
        [_isOppenBarrageBtn setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zhibo_danmu"]
                            forState:UIControlStateSelected];
        [_isOppenBarrageBtn addTarget:self action:@selector(oppenBarrageBtnction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _isOppenBarrageBtn ;
}
- (UIButton *)commenBtn {
    if (!_commenBtn) {
        _commenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commenBtn setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zhibo_xiedanmu"]
                            forState:UIControlStateNormal];
        [_commenBtn addTarget:self action:@selector(commenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commenBtn ;
}
- (UIImageView *)placeHolderView
{
    if (!_placeHolderView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = self.view.bounds;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:imageView];
        _placeHolderView = imageView;
        [self showActivityView];
        // 强制布局
        [_placeHolderView layoutIfNeeded];
    }
    return _placeHolderView;
}
///加载指示器
- (void)showActivityView{
    if (!_activity) {
        _activity= [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.frame = CGRectMake((ScreenW-100)*0.5, (ScreenH-100)*0.5, 100, 100);
    }
    [self.activity startAnimating];
    [self.view addSubview:self.activity];
}
///加载关闭指示器
- (void)stopActivityView{
    if ([_activity isAnimating]) {
        [_activity startAnimating];
    }
    [_activity removeFromSuperview];
    _activity = nil;
}
- (NSMutableArray *)danMuDataArr {
    if (!_danMuDataArr) {
        
        _danMuDataArr = [NSMutableArray array];
    }
    return _danMuDataArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
