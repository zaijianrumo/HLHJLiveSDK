//
//  HLHJRadioingViewController.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJRadioingViewController.h"
#import "HLHJRotating.h"

#import "IJKMediaFramework.framework/Headers/IJKFFOptions.h"
#import "IJKMediaFramework.framework/Headers/IJKFFMoviePlayerController.h"

@interface HLHJRadioingViewController ()

///封面图
@property (nonatomic, strong) HLHJRotating  *iconImg;
///播放的标题
@property (nonatomic, strong) UILabel  *titleLab;
///是否播放
@property (nonatomic, strong) UIButton  *isPlayBtn;
///进度条
@property (nonatomic, strong) UIView  *progressView;
///上一曲
@property (nonatomic, strong) UIButton  *inSongBtn;
///下一曲
@property (nonatomic, strong) UIButton  *inNextBtn;

@property (nonatomic, strong)IJKFFMoviePlayerController *playerVC;


@end

@implementation HLHJRadioingViewController

#pragma mark - 当离开当前直播间的时候，要停止播放
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [self.playerVC pause];
        [self.playerVC stop];
        [self.playerVC shutdown];
    }
}


- (void)viewDidLoad {

   [super viewDidLoad];
    
    self.navigationItem.title = _model.radio_name;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initUI];
    
   
}

- (void)initUI {
  
    /***封面****/
    _iconImg = [[HLHJRotating alloc]init];
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,_model.radio_thumb]] placeholderImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zhibo_xiedanmu"]];
    _iconImg.backgroundColor = [UIColor whiteColor];
    _iconImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_iconImg];

  
    /***播放标题****/
    _titleLab = [UILabel new];
    _titleLab.text = _model.radio_name;
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:_titleLab];
    
    /***进度****/
    _progressView = [UIView new];
    _progressView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_progressView];
    
    /***播放/赞停****/
    _isPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_isPlayBtn setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_bf_bofang"] forState:UIControlStateNormal];
    [_isPlayBtn setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_bf_zanting"] forState:UIControlStateSelected];
    [_isPlayBtn addTarget:self action:@selector(palyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_isPlayBtn];
    
    /***上一曲****/
    _inSongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_inSongBtn setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_bf_shangyige"] forState:UIControlStateNormal];
    [_inSongBtn addTarget:self action:@selector(songBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_inSongBtn];
    
    /***下一曲****/
    _inNextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_inNextBtn setImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_bf_xiayige"] forState:UIControlStateNormal];
    [_inNextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_inNextBtn];
    
    
    NSInteger iconWidth = 180;
    WS(weakSelf);
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(40);
        make.width.mas_equalTo(iconWidth);
        make.width.equalTo(_iconImg.mas_height);
        
    }];
    _iconImg.clipsToBounds = YES;
    _iconImg.layer.cornerRadius = iconWidth/2;
    
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).mas_offset(10);
        make.right.equalTo(weakSelf.view).mas_offset(-10);
        make.centerX.equalTo(weakSelf.view);
        make.centerY.equalTo(weakSelf.view);
    }];

    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).mas_offset(50);
        make.right.equalTo(weakSelf.view).mas_offset(-50);
        make.height.mas_equalTo(1);
        make.top.equalTo(_titleLab.mas_bottom).mas_offset(80);
    }];

    
    
    [_isPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(_progressView.mas_bottom).mas_offset(80);
    }];
    
    [_inSongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_isPlayBtn);
        make.right.equalTo(_isPlayBtn.mas_left).mas_offset(-20);
    }];

    
    [_inNextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_isPlayBtn);
        make.left.equalTo(_isPlayBtn.mas_right).mas_offset(20);
    }];

    
    IJKFFMoviePlayerController *FFvc = [[IJKFFMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:_model.radio_source ? _model.radio_source : @""] withOptions:nil];
    FFvc.view.frame = CGRectMake(0, 0, ScreenW, .2);
    FFvc.view.backgroundColor = [UIColor clearColor];
    ///需要强引用
    self.playerVC = FFvc;
    self.playerVC.scalingMode = IJKMPMovieScalingModeAspectFit;
    [self.view addSubview:self.playerVC.view];

    
}

#pragma mark Action
- (void)palyBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        [self.playerVC prepareToPlay];
        [self.playerVC play];
        [self.iconImg hlhjresumeRotate];
        
    }else {
       [self.playerVC pause];
       [self.iconImg hlhjstopRotating];
        
    }
}
- (void)songBtnAction:(UIButton *)sender {
    
}
- (void)nextBtnAction:(UIButton *)sender {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
