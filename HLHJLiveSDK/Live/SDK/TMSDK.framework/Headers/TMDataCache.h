//
//  TMDataCache.h
//  CordovaLib
//
//  Created by ZhouYou on 2018/1/25.
//

#import <Foundation/Foundation.h>

@interface TMDataCache : NSObject

+ (id)localDataByKey:(NSString *)key;
+ (void)saveLocalData:(id)data key:(NSString *)key;


+ (id)temporaryDataByKey:(NSString *)key;
+ (void)saveTemporaryData:(id)data key:(NSString *)key;
@end
