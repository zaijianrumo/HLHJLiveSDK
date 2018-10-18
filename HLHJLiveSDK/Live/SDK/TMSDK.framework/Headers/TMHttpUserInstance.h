//
//  TMHttpUserInstance.h
//  TmCompDemo
//
//  Created by ZhouYou on 2018/1/15.
//  Copyright © 2018年 ZhouYou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMHttpUserInstance : NSObject<NSCoding>
@property (nonatomic, strong) NSDictionary *loginInfo;

@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *member_code;
@property (nonatomic, assign) int member_id;
@property (nonatomic, copy) NSString *member_name;
//@property (nonatomic, copy) NSString *member_nickname;
@property (nonatomic, copy) NSString *member_real_name;
@property (nonatomic, copy) NSString *mobile;
//@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, assign) int sex;
@property (nonatomic, copy) NSString *site_code;
@property (nonatomic, assign) int status;

+ (TMHttpUserInstance *)instance;
//销毁数据
+ (void)terminateInstance;
//持久化数据
+ (void)persist;
- (void)setLoginInfo:(NSDictionary *)loginInfo;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
