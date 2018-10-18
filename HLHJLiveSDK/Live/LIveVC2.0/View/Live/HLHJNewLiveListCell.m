//
//  HLHJNewLiveListCell.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewLiveListCell.h"
#import "HLHJLiveModel.h"
#import "HLHJNewLiveToolView.h"
#import <TMSDK/TMHttpUser.h>
#import "HLHJNewLiveDetilController.h"
#import <TMShare/TMShare.h>
@interface HLHJNewLiveListCell()<HLHJNewLiveToolViewDelete>

@property (nonatomic, strong) UIImageView  *coverView;
@property (nonatomic, strong) UIButton  *staBtn,*playBtn,*playVolumeBtn;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) HLHJNewLiveToolView *toolView;
///收藏ID
@property (nonatomic, copy) NSString *star_id;
@end

@implementation HLHJNewLiveListCell

@synthesize toolView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
  
        
        self.selectionStyle = 0;
        
        UIImageView *coverView = [[UIImageView alloc]init];
        coverView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        coverView.contentMode = UIViewContentModeScaleAspectFill;
        coverView.clipsToBounds = YES;
        [self.contentView addSubview:coverView];
        [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(210);
        }];
        self.coverView = coverView;
        
        //正在直播状态
        UIImageView *staView = [[UIImageView alloc]init];
        staView.image = HLHJImage(@"img_camera_bg");
        [coverView addSubview:staView];
        [staView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(coverView);
            make.top.equalTo(coverView.mas_top).mas_offset(12);
        }];
        
        UIButton *staBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [staBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [staBtn setTitle:@" 正在直播" forState:UIControlStateNormal];
        [staBtn setImage:HLHJImage(@"ic_camera") forState:UIControlStateNormal];
        [staBtn setTitle:@" 回放" forState:UIControlStateSelected];
        [staBtn setImage:HLHJImage(@"ic_player") forState:UIControlStateSelected];
        staBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [staView addSubview:staBtn];
        [staBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(staView);
        }];
        self.staBtn = staBtn;
        
        ///播放或者暂停
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [playBtn setImage:HLHJImage(@"ic_play") forState:UIControlStateNormal];
        [playBtn setImage:HLHJImage(@"ic_stop") forState:UIControlStateSelected];
        [coverView addSubview:playBtn];
        [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(coverView);
        }];
        self.playBtn = playBtn;
        
        ///播放量
        UIButton *playVolumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [playVolumeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [playVolumeBtn setImage:HLHJImage(@"ic_home_views") forState:UIControlStateNormal];
        playVolumeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [coverView addSubview:playVolumeBtn];
        self.playVolumeBtn = playVolumeBtn;
        
        ///直播标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"法治中国法治中国法治中国 法治...";
        titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        titleLabel.textAlignment  = NSTextAlignmentLeft;
        [coverView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.bottom.equalTo(coverView.mas_bottom).mas_offset(-21);
            make.left.equalTo(coverView.mas_left).mas_offset(15);
            make.right.equalTo(playVolumeBtn.mas_left).mas_offset(-5);
        }];
        
        [playVolumeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel);
            make.right.equalTo(coverView.mas_right).mas_offset(-10);
        }];
 
        toolView = [[HLHJNewLiveToolView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:toolView];
        [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.contentView);
            make.top.equalTo(coverView.mas_bottom);
        }];
    
    }
    return self;
}

- (void)setModel:(HLHJLiveModel *)model {
    
    _model = model;
    
    [_coverView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,model.live_thumb]] placeholderImage:[UIImage imageNamed:HLHJImage(@"")]];
    
    _titleLabel.text = _model.live_title;

    _staBtn.selected = _model.live_type == 1 ? NO:YES;
    

    [self.playVolumeBtn setTitle:[NSString stringWithFormat:@" %ld",(long)model.read_num] forState:UIControlStateNormal];
    
    [toolView.giveLiveBtn setTitle:[NSString stringWithFormat:@" %ld",(long)model.laud_num] forState:UIControlStateNormal];
    
    [toolView.commenBtn setTitle:[NSString stringWithFormat:@" %ld",(long)model.comment_num] forState:UIControlStateNormal];
    
    toolView.giveLiveBtn.selected = _model.is_laud == YES ? YES:NO;

    toolView.collentBtn.selected = _model.is_collection == YES ? YES:NO;
    
    toolView.delegate = self;
   
}

- (void)giveLiveBtnAciton:(UIButton *)sender {
    
    if (![HLHJLoginTool isLogin:[HLHJLoginTool getCurrentVC]]) return;
    
     [HLHJNetworkTool hlhjRequestWithType:POST requestUrl:@"/api/laud" parameter:@{@"token":[TMHttpUser token],@"type":@"1",@"id":_model.ID} successComplete:^(id  _Nullable responseObject) {

        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 1) {

            _model.is_laud = !_model.is_laud;
            
            _model.laud_num = _model.is_laud == YES ? _model.laud_num + 1 : _model.laud_num -1;
            
            toolView.giveLiveBtn.selected = _model.is_laud;
            
            [toolView.giveLiveBtn setTitle:[NSString stringWithFormat:@" %ld",(long)_model.laud_num] forState:UIControlStateNormal];
        }
    } failureComplete:^(NSError * _Nonnull error) {

    }];

}
- (void)commenAciton:(UIButton *)sender {
    
    HLHJNewLiveDetilController *liveDetail = [HLHJNewLiveDetilController new];
//    liveDetail.navigationController.navigationBar.alpha = 0.0;
    liveDetail.hidesBottomBarWhenPushed = YES;
    NSDictionary *dict = @{@"ID":_model.ID,@"live_thumb":_model.live_thumb,@"live_status":[@(_model.live_status) stringValue]};
    liveDetail.paramStr = [dict yy_modelToJSONString];
    [[HLHJLoginTool getCurrentVC].navigationController pushViewController:liveDetail animated:YES];
    
}

- (void)collentAciton:(UIButton *)sender {
    
    if (![HLHJLoginTool isLogin:[HLHJLoginTool getCurrentVC]]) return;

    if (_model.is_collection) {
                ///取消收藏

           NSDictionary *parma = @{@"star_id":self.star_id ? self.star_id:_model.sid};

                NSString *url = [NSString stringWithFormat:@"%@/member/Memberstar/deleteStar",BASE_URL];
                [HLHJNetworkTool hlhjRequestWithType:POST requestUrl:url parameter:parma successComplete:^(id  _Nullable responseObject) {

                    if ([responseObject[@"code"] integerValue]== 200) {
                        NSDictionary *dict = @{@"id":_model.ID,@"type":@"2",@"sid":self.star_id ? self.star_id:_model.sid,@"token":[TMHttpUser token]};
                        NSString *collenUrl = [NSString stringWithFormat:@"%@/hlhj_webcast/Api/collection",BASE_URL];
                        [HLHJNetworkTool hlhjRequestWithType:POST requestUrl:collenUrl parameter:dict successComplete:^(id  _Nullable responseObject) {
                            if ([responseObject[@"code"] integerValue]== 200) {

                              toolView.collentBtn.selected = NO;
                              _model.is_collection = NO;

                            }} failureComplete:^(NSError * _Nonnull error) {

                            }];
                    }
                } failureComplete:^(NSError * _Nonnull error) {

                }];

    }else {

     ///添加收藏
        NSDictionary *paramStr  = @{@"ID":_model.ID,@"live_thumb":_model.live_thumb,@"live_status":[@(_model.live_status) stringValue],@"live_source":_model.live_source};

        NSMutableDictionary *extent = [NSMutableDictionary dictionary];
        [extent setDictionary:@{@"iosInfo":
                                    @{@"native":@"ture",@"src":@"HLHJNewLiveDetilController",
                                      @"paramStr":[paramStr yy_modelToJSONString],
                                      @"wwwFolder":@""
                                      },
                                @"androidInfo" :@{@"native":@"ture",
                                                  @"src":@"hlhj.fhp.tvlib.activitys.NewLiveAty",
                                                  @"paramStr":[paramStr yy_modelToJSONString],@"wwwFolder":@""}
                                }];
        NSDictionary *dict = @{@"member_code":[TMHttpUserInstance instance].member_code,
                               @"title":_model.live_title,
                               @"intro":_model.live_title,
                               @"app_id":@"HLHJLiveSDK2.0",
                               @"article_id":_model.ID,
                               @"type":@"1",
                               @"pic":[NSString stringWithFormat:@"%@%@",BASE_URL,_model.live_thumb],
                               @"extend":[extent yy_modelToJSONString]
                               };


        NSString *addCollen = [NSString stringWithFormat:@"%@/member/Memberstar/addStar",BASE_URL];
        [HLHJNetworkTool hlhjRequestWithType:POST requestUrl:addCollen parameter:dict successComplete:^(id  _Nullable responseObject) {

            if ([responseObject[@"code"] integerValue]== 200) {
                _star_id = responseObject[@"data"][@"star_id"];
                NSDictionary *dict = @{@"id":_model.ID,
                                       @"type":@"2",
                                       @"sid":_star_id,
                                       @"token":[TMHttpUser token]};
                NSString *collenUrl = [NSString stringWithFormat:@"%@/hlhj_webcast/Api/collection",BASE_URL];
                [HLHJNetworkTool hlhjRequestWithType:POST requestUrl:collenUrl parameter:dict successComplete:^(id  _Nullable responseObject) {
                    if ([responseObject[@"code"] integerValue]== 200) {
                        toolView.collentBtn.selected = YES;
                        _model.is_collection = YES;
                    }
                }failureComplete:^(NSError * _Nonnull error) {}];
            }

        } failureComplete:^(NSError * _Nonnull error) {

        }];
    }
}

-(void)shareAciton:(UIButton *)sender {
    
    TMShareConfig *config = [[TMShareConfig alloc] initWithTMBaseConfig];
    [[TMShareInstance instance] configWith:config];
    
    NSString * thumbUrl  = _model.live_thumb.length > 0 ? [NSString stringWithFormat:@"%@%@",BASE_URL,_model.live_thumb]:@"https://www.baidu.com/img/bd_logo1.png";
    
    [[TMShareInstance instance] showShare:shareUrl thumbUrl:thumbUrl title:_model.live_title descr:_model.live_title currentController:[HLHJLoginTool getCurrentVC] finish:nil];
    
  
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
