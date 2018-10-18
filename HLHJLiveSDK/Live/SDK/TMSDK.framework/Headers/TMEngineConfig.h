//
//  TMEngineConfig.h
//  CordovaLib
//
//  Created by ZhouYou on 2018/1/19.
//

#import <Foundation/Foundation.h>

@class UIColor;
@interface TMEngineConfig : NSObject

/*主题颜色，默认wihteColor
一般会在导航组件加载配置后根据配置设定。（可能为空，导航组件加载后才有）
 */
@property (nonatomic, strong) UIColor *themeColor;

/*导航控制器颜色，默认与themeColor保持一致，也可单独配置。
 一般会在导航组件加载配置后根据配置设定。
 （导航组件加载配置后，设定themeColor同时也将navigationBarTintColor设定为themeColor一致的值，若配置有图片且下载成功后，可将navigationBarTintColor设定为图片的Color
 */
@property (nonatomic, strong) UIColor *navigationBarTintColor;

/*夜间模式主色调，默认0x383838
 */
@property (nonatomic, strong) UIColor *nightColor;

/*域名，http://或者https://开头，+ip+端口
 一般会在导航组件加载配置后根据配置设定
 */
@property (nonatomic, copy) NSString *domain;

/*站点ID
 一般会在导航组件加载配置后根据配置设定
 */
@property (nonatomic, copy) NSString *siteCode;

/*导航的配置文件参数
 file_name：
 */
//@property (nonatomic, copy) NSString *tmConfigName;

/*JPush推送相关key，框架使用
 */
@property (nonatomic, copy) NSString *jpushAppkey;
@property (nonatomic, copy) NSString *jpushChannel;

/*友盟统计相关key，框架使用
 */
@property (nonatomic, copy) NSString *umengAppkey;
@property (nonatomic, copy) NSString *umengChannel;

//根据key取各个组件在“TMBaseConfig.plist”中自定义的配置数据
- (NSDictionary *)featureByName:(NSString *)key;

+ (TMEngineConfig *)instance;

@end
