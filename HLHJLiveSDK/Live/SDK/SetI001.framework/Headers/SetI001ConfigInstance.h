//
//  SetI001ConfigInstance.h
//  TmCompDemo
//
//  Created by ZhouYou on 2018/1/16.
//  Copyright © 2018年 ZhouYou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SetI001Define.h"

@interface SetI001ConfigInstance : NSObject

/*推送开关
 TMDataCacheKey:@"local_apnsEnable"
 LocalData
 Default:YES
 */
@property (nonatomic, assign) BOOL apnsEnable;

/*夜间模式开关
 TMDataCacheKey:@"local_nightModel"
 LocalData
 Default:NO
 */
@property (nonatomic, assign) BOOL nightModel;

/*正文字体大小
 TMDataCacheKey:@"local_font"
 LocalData
 Default:SetI001_Config_FontNormal
 */
@property (nonatomic, assign) SetI001_Config_Font font;


+ (SetI001ConfigInstance *)instance;

//只会统计及清除Document/Caches、Tmp、Caches三个路径下的缓存
- (void)cleanCache:(void(^)(BOOL))result;

- (uint64_t)cacheSize:(void(^)(uint64_t))sizeHander;

/*
//根据key，自动判断是否页面模式返回对应颜色
 */
- (unsigned long)corlorByKey:(NSString *)key;

/*
 //添加更多颜色进去，key  color相对应
 */
- (void)addColors:(NSDictionary *)corlors isNight:(BOOL)night;
@end
