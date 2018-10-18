//
//  HLHJCommentModel.h
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/25.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLHJCommentModel : NSObject
//"id": 1,
//"content": "dsfsdfafdaf",//评论内容
//"user_id": 38,//评论用户ID
//"create_at": 1527229649,//评论时间
//"live_id": 2,//直播ID
//"head_pic": "\uploads\portal\luodong\20180104\318acc067a5c3c218e35f4e35d619530.jpg",//用户头像
//"user_name": "luodong"//用户昵称

@property (nonatomic, copy) NSString  *ID;

@property (nonatomic, copy) NSString  *content;

@property (nonatomic, copy) NSString  *user_id;

@property (nonatomic, copy) NSString  *create_at;

@property (nonatomic, copy) NSString  *live_id;

@property (nonatomic, copy) NSString  *head_pic;

@property (nonatomic, copy) NSString  *user_name;

@property (nonatomic, assign) BOOL  is_laud;

@property (nonatomic, assign) NSInteger  laud_num;

@end
