//
//  HLHJNewRadioPalyController.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewRadioPalyController.h"

/** Controllers **/
#import "IJKMediaFramework.framework/Headers/IJKFFOptions.h"
#import "IJKMediaFramework.framework/Headers/IJKFFMoviePlayerController.h"
/** Model **/
#import "HLHJRadioModel.h"
/** Views**/
#import "HLHJNewToash.h"
/** #define **/
#import "HLHJRotating.h"

@interface HLHJNewRadioPalyController ()


@property (nonatomic, strong) UIImageView  *bgImageView;

///封面图
@property (nonatomic, strong) HLHJRotating  *iconImg;
///播放的标题
@property (nonatomic, strong) UILabel  *titleLab,*desLab;
///是否播放
@property (nonatomic, strong) UIButton  *isPlayBtn;
///进度条
@property (nonatomic, strong) UIView  *progressView;
///上一曲
@property (nonatomic, strong) UIButton  *inSongBtn;
///下一曲
@property (nonatomic, strong) UIButton  *inNextBtn;

@property (nonatomic, strong)IJKFFMoviePlayerController *playerVC;

@property (nonatomic, strong) NSMutableArray *masonryViewArray;

@end

@implementation HLHJNewRadioPalyController


#pragma mark - LifeCycle

#pragma mark - LifeCycle
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.alpha = 1.0;
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.alpha = 0.0;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initUI];
    
}

#pragma mark - Delegate/DataSource Methods

#pragma mark - Notification Methods

#pragma mark - KVO Methods

#pragma mark - Public Methods

- (void)initUI {
    
     /***背景图片****/
    _bgImageView = [[UIImageView alloc]init];
    _bgImageView = [[HLHJRotating alloc]init];
    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,self.model.banner]] placeholderImage:HLHJImage(@"img_gb_bg")];
    _bgImageView.backgroundColor = [UIColor whiteColor];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.clipsToBounds = YES;
    _bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:_bgImageView];
    
     /***返回按钮****/
    UIButton *navBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navBackBtn setImage:HLHJImage(@"nav_back") forState:UIControlStateNormal];
    [navBackBtn addTarget:self action:@selector(nacBackAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:navBackBtn];
    
    
    /***封面****/
    _iconImg = [[HLHJRotating alloc]init];
    _iconImg.backgroundColor = [UIColor whiteColor];
    _iconImg.contentMode = UIViewContentModeScaleAspectFill;
    [_bgImageView addSubview:_iconImg];
    
    
    /***播放标题****/
    _titleLab = [UILabel new];
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:20];
    [_bgImageView addSubview:_titleLab];
    
    /***播放的内容****/
     _desLab = [UILabel new];
    _desLab.textColor = [UIColor blackColor];
    _desLab.textAlignment = NSTextAlignmentCenter;
    _desLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [self.view addSubview:_desLab];
    

    UIView *animView = [UIView new];
    [self.view addSubview:animView];

    /***播放/赞停****/
    _isPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_isPlayBtn setImage:HLHJImage(@"ic_play_xq") forState:UIControlStateNormal];
    [_isPlayBtn setImage:HLHJImage(@"ic_stop_xq") forState:UIControlStateSelected];
    [_isPlayBtn addTarget:self action:@selector(palyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_isPlayBtn];
    
    /***上一曲****/
    _inSongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_inSongBtn setImage:HLHJImage(@"ic_fallback")  forState:UIControlStateNormal];
    [_inSongBtn addTarget:self action:@selector(songBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_inSongBtn];
    
    /***下一曲****/
    _inNextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_inNextBtn setImage:HLHJImage(@"ic_forward") forState:UIControlStateNormal];
    [_inNextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_inNextBtn];
    
    
    NSInteger iconWidth = 123;
    WS(weakSelf);
    
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(292);
    }];
    
    [navBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(38);
    }];
    
    
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_bgImageView);
        make.width.mas_equalTo(iconWidth);
        make.width.equalTo(_iconImg.mas_height);
        
    }];
    _iconImg.clipsToBounds = YES;
    _iconImg.layer.cornerRadius = iconWidth/2;
    
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgImageView).mas_offset(10);
        make.right.equalTo(_bgImageView).mas_offset(-10);
        make.centerX.equalTo(_bgImageView);
        make.top.equalTo(_iconImg.mas_bottom).mas_offset(37);
    }];
    
    
    
    [_desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_bgImageView.mas_bottom).mas_offset(35);
    }];
    
    [animView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_desLab.mas_bottom).mas_offset(50);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
    }];

    [_isPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(-106);
    }];
    
    [_inSongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_isPlayBtn);
        make.right.equalTo(_isPlayBtn.mas_left).mas_offset(-45);
    }];
    
    
    [_inNextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_isPlayBtn);
        make.left.equalTo(_isPlayBtn.mas_right).mas_offset(45);
    }];
    
    ListRadioModel *model = self.model.list[_chooseIndex];
      [self setConent:model isChange:NO];
    
    _masonryViewArray = [NSMutableArray array];
    for (NSInteger i = 0; i <= 6 ; i ++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        NSString *str = [NSString stringWithFormat:@"cm2_list_icn_play%d",arc4random() % 7];
        imageView.image = HLHJImage(str);
        [animView addSubview:imageView];
        [_masonryViewArray addObject:imageView];
    }
    // 实现masonry水平固定间隔方法
    [_masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    // 设置array的垂直方向的约束
    [_masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(animView);
        make.height.equalTo(animView);
    }];
    
    
}
#pragma mark - Private Methods

#pragma mark - Action Methods

#pragma mark Action


- (void)palyBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        [self.playerVC prepareToPlay];
        [self.playerVC play];
        [self.iconImg hlhjresumeRotate];
        
        NSMutableArray *images1 = [NSMutableArray array];
        NSMutableArray *images2 = [NSMutableArray array];
        NSMutableArray *images3 = [NSMutableArray array];
        NSMutableArray *images4 = [NSMutableArray array];
        NSMutableArray *images5 = [NSMutableArray array];
        NSMutableArray *images6 = [NSMutableArray array];
        NSMutableArray *images7 = [NSMutableArray array];

        for (NSInteger i = 0; i <= 6; i++) {
            NSString *str1 = [NSString stringWithFormat:@"cm2_list_icn_play%ld",i];
            [images1 addObject:HLHJImage(str1)];
            [images2 addObject:HLHJImage(str1)];
            [images3 addObject:HLHJImage(str1)];
            [images4 addObject:HLHJImage(str1)];
            [images5 addObject:HLHJImage(str1)];
            [images6 addObject:HLHJImage(str1)];
            [images7 addObject:HLHJImage(str1)];
        }

          NSMutableArray *arc = [NSMutableArray array];
          [arc addObject:images1];
          [arc addObject:images2];
          [arc addObject:images3];
          [arc addObject:images4];
          [arc addObject:images5];
          [arc addObject:images6];
          [arc addObject:images7];

        for (UIImageView *imageView in _masonryViewArray) {
            imageView.animationImages = arc[arc4random_uniform(6)];
            imageView.animationDuration = 3;
            //设置重复次数，0表示无限
            imageView.animationRepeatCount = 0;
            [imageView startAnimating];
        }
        
    }else {
        [self.playerVC pause];
        [self.iconImg hlhjstopRotating];
        for (UIImageView *imgView in _masonryViewArray) {
            [imgView stopAnimating];
        }
        
    }
}
- (void)songBtnAction:(UIButton *)sender {
 
    if (_chooseIndex == 0) {
        
        [HLHJNewToash hsShowBottomWithText:@"已经到顶了哟~"];
        return;
    }
    _chooseIndex = _chooseIndex - 1;
    
    ListRadioModel *model = self.model.list[_chooseIndex];
    
    [self setConent:model isChange:YES];
    
}
- (void)nextBtnAction:(UIButton *)sender {
    
    if (_chooseIndex == self.model.list.count - 1) {
        
        [HLHJNewToash hsShowBottomWithText:@"已经到底了哟~"];
        return;
    }
    _chooseIndex = _chooseIndex + 1;
    
    ListRadioModel *model = self.model.list[_chooseIndex];
    
    [self setConent:model isChange:YES];
    
}

- (void)setConent:(ListRadioModel *)model isChange:(BOOL)flag{
    
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,model.radio_thumb]] placeholderImage:[UIImage imageNamed:@"HLHJLiveImgs.bundle/ic_zhibo_xiedanmu"]];
    _titleLab.text = model.radio_name;
    _desLab.text = model.online;
    
    
    [self.playerVC pause];
    [self.playerVC stop];
    [self.playerVC shutdown];
    [self.playerVC.view removeFromSuperview];
    self.playerVC= nil;
    
    self.playerVC = [[IJKFFMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:model.radio_source ? model.radio_source : @""] withOptions:nil];
    self.playerVC.view.frame = CGRectMake(0, 0, ScreenW, .2);
    self.playerVC.view.backgroundColor = [UIColor clearColor];
    self.playerVC.scalingMode = IJKMPMovieScalingModeAspectFit;
    if (flag) {
        
        [self.playerVC prepareToPlay];
        [self.playerVC play];
    }
    [self.view addSubview:self.playerVC.view];

}

- (void)nacBackAction:(UIButton *)sender {
    
    [self.playerVC pause];
    [self.playerVC stop];
    [self.playerVC shutdown];
    
    self.navigationController.navigationBar.alpha = 1.0;
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - Getter Methods

#pragma mark - Setter Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
