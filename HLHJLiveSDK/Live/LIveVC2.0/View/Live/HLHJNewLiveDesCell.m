//
//  HLHJNewLiveDesCell.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewLiveDesCell.h"
#import "HLHJNewLiveToolView.h"
#import "HLHJLiveDesModel.h"
#import <TMSDK//TMHttpUser.h>
#import <TMShare/TMShare.h>

@interface HLHJNewLiveDesCell()<HLHJNewLiveToolViewDelete>
///分享，收藏
@property (nonatomic, strong)  HLHJNewLiveToolView *toolView ;
///标题,简介
@property (nonatomic, strong) UILabel  *titleLabel,*desLabel;
///收藏ID
@property (nonatomic, copy) NSString *star_id;
///是否收藏
@property (nonatomic, assign)BOOL isCollenct;

@end

@implementation HLHJNewLiveDesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle  = 0;
        self.backgroundColor = [UIColor whiteColor];

        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"茂县旅游推荐";
        titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [self.contentView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(16);
            make.top.equalTo(self.contentView).mas_offset(15);
            make.right.equalTo(self.contentView).mas_offset(-16);
        }];
        self.titleLabel = titleLabel;
        
        UILabel *desLabel = [[UILabel alloc] init];
        desLabel.text = @"简介：带你一睹茂县的多姿风采  带你一睹茂县的多姿风采  带你一睹茂县的多姿风采  带你一睹茂县的多姿风...查看更多";
        desLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        desLabel.numberOfLines = 0;
        desLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [self.contentView addSubview:desLabel];
        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(titleLabel);
            make.top.equalTo(titleLabel.mas_bottom).mas_offset(11);
        }];
        self.desLabel = desLabel;

        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(desLabel);
            make.top.equalTo(desLabel.mas_bottom).mas_offset(11);
            make.height.mas_offset(1);
        }];

        HLHJNewLiveToolView *toolView = [[HLHJNewLiveToolView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:toolView];
        [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(lineView.mas_bottom);
            make.height.mas_offset(38);
        }];
        toolView.delegate = self;
        _toolView = toolView;
    }
    return self;
}

- (void)giveLiveBtnAciton:(UIButton *)sender {
    
    if (![HLHJLoginTool isLogin:[HLHJLoginTool getCurrentVC]]) return;
    
     [HLHJNetworkTool hlhjRequestWithType:POST requestUrl:@"/api/laud" parameter:@{@"token":[TMHttpUser token],@"type":@"1",@"id":_model.ID} successComplete:^(id  _Nullable responseObject) {
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 1) {
            _model.is_laud = !_model.is_laud;
            _model.laud_num = _model.is_laud == YES ? _model.laud_num + 1 : _model.laud_num -1;
            _toolView.giveLiveBtn.selected = _model.is_laud;
            [_toolView.giveLiveBtn setTitle:[NSString stringWithFormat:@" %ld",(long)_model.laud_num]
                                   forState:UIControlStateNormal];
        }
    } failureComplete:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)setModel:(HLHJLiveDesModel *)model {
    
    _model = model;
    
    self.titleLabel.text = model.live_desc;
    
    self.desLabel.text = model.live_title;
    
    _toolView.giveLiveBtn.selected = model.is_laud ? YES:NO;
    
    [_toolView.commenBtn setImage:HLHJImage(@"ic_views") forState:UIControlStateNormal];
    
    
    [_toolView.giveLiveBtn setTitle:[NSString stringWithFormat:@" %ld",(long)model.laud_num] forState:UIControlStateNormal];
    
    [_toolView.commenBtn setTitle:[NSString stringWithFormat:@" %ld",(long)model.read_num] forState:UIControlStateNormal];

    if ([TMHttpUser token]) {
        [self querrCollection];
    }
}


- (void)collentAciton:(UIButton *)sender {
    
    if (![HLHJLoginTool isLogin:[HLHJLoginTool getCurrentVC]]) return;

    if (self.isCollenct) {
        ///取消收藏

        NSDictionary *parma = @{@"star_id":self.star_id};

        NSString *url = [NSString stringWithFormat:@"%@/member/Memberstar/deleteStar",BASE_URL];
        [HLHJNetworkTool hlhjRequestWithType:POST requestUrl:url parameter:parma successComplete:^(id  _Nullable responseObject) {

            if ([responseObject[@"code"] integerValue]== 200) {
                NSDictionary *dict = @{@"id":_model.ID,@"type":@"2",@"sid":self.star_id,@"token":[TMHttpUser token]};
                NSString *collenUrl = [NSString stringWithFormat:@"%@/hlhj_webcast/Api/collection",BASE_URL];
                [HLHJNetworkTool hlhjRequestWithType:POST requestUrl:collenUrl parameter:dict successComplete:^(id  _Nullable responseObject) {
                    if ([responseObject[@"code"] integerValue]== 200) {

                        _toolView.collentBtn.selected = NO;
                        self.isCollenct = NO;

                    }} failureComplete:^(NSError * _Nonnull error) {

                    }];
            }
        } failureComplete:^(NSError * _Nonnull error) {

        }];

    }else {

        ///添加收藏
        NSDictionary *paramStr  = @{@"ID":_model.ID,@"live_thumb":_model.live_thumb,@"live_status":[@(_model.live_status) stringValue],@"live_source":_model.live_source};

        NSMutableDictionary *extent = [NSMutableDictionary dictionary];
        [extent setDictionary:@{
                                @"iosInfo":
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
                        _toolView.collentBtn.selected = YES;
                        _isCollenct = YES;
                    }
                }failureComplete:^(NSError * _Nonnull error) {}];
            }

        } failureComplete:^(NSError * _Nonnull error) {

        }];
    }

}

-(void)shareAciton:(UIButton *)sender {
//    NSLog(@"---%s",__func__);
    
    TMShareConfig *config = [[TMShareConfig alloc] initWithTMBaseConfig];
    [[TMShareInstance instance] configWith:config];
    
    NSString * thumbUrl  = _model.live_thumb.length > 0 ? [NSString stringWithFormat:@"%@%@",BASE_URL,_model.live_thumb]:@"https://www.baidu.com/img/bd_logo1.png";
    
    [[TMShareInstance instance] showShare:shareUrl thumbUrl:thumbUrl title:_model.live_title descr:_model.live_title currentController:[HLHJLoginTool getCurrentVC] finish:nil];
    
}
- (void)querrCollection {
    
    
    NSDictionary *parma = @{@"member_code":[TMHttpUserInstance instance].member_code?[TMHttpUserInstance instance].member_code:@"",
                            @"app_id":@"HLHJLiveSDK2.0",
                            @"article_id":_model.ID
                            };
    NSString *url = [NSString stringWithFormat:@"%@/member/Memberstar/checkIsStar",BASE_URL];
    [HLHJNetworkTool hlhjRequestWithType:POST requestUrl:url parameter:parma successComplete:^(id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject[@"data"];
        if (dict.allKeys.count == 0) {
            _isCollenct= NO;
            _toolView.collentBtn.selected = NO;
        }else {
            _star_id = dict[@"star_id"];
            _isCollenct= YES;
            _toolView.collentBtn.selected = YES;
        }
//        if([dict isKindOfClass:[NSArray class]]){
        //    _isCollenct= NO;
        //            _toolView.collentBtn.selected = NO;
//        }else if([dict isKindOfClass:[NSDictionary class]]) {
//            _star_id = dict[@"star_id"];
//            _isCollenct= YES;
//            _toolView.collentBtn.selected = YES;
//        }
    } failureComplete:^(NSError * _Nonnull error) {
        
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
