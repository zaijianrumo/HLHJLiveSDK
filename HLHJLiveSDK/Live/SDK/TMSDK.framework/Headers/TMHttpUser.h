//
//  TMHttpUser.h
//  CordovaLib
//
//  Created by ZhouYou on 2018/1/9.
//

#import <Foundation/Foundation.h>
#import "TMHttpDefine.h"
#import "TMHttpUserInstance.h"

@interface TMHttpUser : NSObject

/*
 保存登录时的返回的token
 token用于其它接口Header中
 */
+ (void)saveToken:(NSString *)token;

/*
 获取saveToken保存的token
 */
+ (NSString *)token;

/*登录
 phoneNumber        string      必填      手机号
 state              Int         必填      登录验证方式(1:验证码, 2:密码)
 siteId             String      必填      站点id
 psd                String      必填      密码/验证码
 */
+ (void)loginWithNumber:(NSString *)phoneNumber
               password:(NSString *)psd
                  state:(int)state
                 siteId:(NSString *)siteId
                success:(TMHttpSuccess)success
                 failed:(TMHttpFailed)failed;
/*三方登录
 uid              string      必填      第三方唯一id
 site_code        string      必填      站点code
 type             Int         必填      第三方登录方式 1:qq 2:微信 3:微博
 member_name      String      必填      昵称
 head_pic         String      必填      头像
 sex              String      必填      性别 1 男 2女
 */
+ (void)thirdLoginWithParm:(NSDictionary *)parmDic
                   success:(TMHttpSuccess)success
                    failed:(TMHttpFailed)failed;
                    
/*获取消息列表
 index              string      必填     当前页码
 member_code        Int      	选填     用户code
 */
+ (void)requestMsgListWithIndex:(NSInteger )index
					member_code:(NSString*)member_code
                   success:(TMHttpSuccess)success
                    failed:(TMHttpFailed)failed;
                    
/*删除消息
 push_id              string      必填     消息id
 */
+ (void)deleteMsgWithPushId:(NSString* )push_id
                   success:(TMHttpSuccess)success
                    failed:(TMHttpFailed)failed;
                    
/*已读消息
 push_id              string      必填     消息id
 */
+ (void)isReadMsgWithPushId:(NSString* )push_id
                   success:(TMHttpSuccess)success
                    failed:(TMHttpFailed)failed;

/*获取收藏列表
 index              string      必填     当前页码
 member_code        Int      	选填     用户code
 */
+ (void)requestCollectListWithIndex:(NSInteger )index
					member_code:(NSString*)member_code
                   success:(TMHttpSuccess)success
                    failed:(TMHttpFailed)failed;
                    
/*添加收藏
 member_code      string      必填      用户code
 title	          string      必填      文章标题
 app_id           string      必填      开发者创建应用时填的唯一id
 article_id       int         必填      文章id
 */
+ (void)addCollectWithParm:(NSDictionary *)parmDic
                   success:(TMHttpSuccess)success
                    failed:(TMHttpFailed)failed;
                    
/*取消收藏
 star_id              int      必填     收藏id
 */
+ (void)cancelCollectWithStarId:(int )star_id
                   success:(TMHttpSuccess)success
                    failed:(TMHttpFailed)failed;
                    

/*获取历史记录列表
 member_code        Int      	必填     用户code
 */
+ (void)requestHistoryListWithMember_code:(NSString*)member_code
                   success:(TMHttpSuccess)success
                    failed:(TMHttpFailed)failed;
                    
/*添加历史记录
 member_code      string      必填      用户code
 title	          string      必填      文章标题
 app_id           string      必填      开发者创建应用时填的唯一id
 article_id       int         必填      文章id
 */
+ (void)addHistoryWithParm:(NSDictionary *)parmDic
                   success:(TMHttpSuccess)success
                    failed:(TMHttpFailed)failed;

/*删除历史记录
 member_code          string      必填      用户code
 type	              int         必填      1:清除一条  2:清除所有
 history_id           string      必填      历史记录id
 */
+ (void)deleteHistoryWithParm:(NSDictionary *)parmDic
                   success:(TMHttpSuccess)success
                    failed:(TMHttpFailed)failed;
                    
/*获取评论列表
 index              string      必填     当前页码
 member_code        Int      	选填     用户code
 */
+ (void)requestCommentListWithIndex:(NSInteger )index
					member_code:(NSString*)member_code
                   success:(TMHttpSuccess)success
                    failed:(TMHttpFailed)failed;
                    
/*添加评论
 member_code      			  string      必填      用户code
 article_content	          string      必填      文章内容节选
 app_id          			  string      必填      开发者创建应用时填的唯一id
 article_id      			  int         必填      文章id
 comment_content      		  string      必填      评论内容
 */
+ (void)addCommentWithParm:(NSDictionary *)parmDic
                   success:(TMHttpSuccess)success
                    failed:(TMHttpFailed)failed;
                    
/*删除评论
 comment_id          int      必填      评论id
 */
+ (void)deleteCommentWithCommentId:(int )comment_id
                   success:(TMHttpSuccess)success
                    failed:(TMHttpFailed)failed;

/*发送短信验证码
 phoneNumber        string    必填    手机号码
 state              Int       必填    类型: 1: 登录 2: 密码找回 3: 修改密码 4: 原手机号验证 5: 新手机号验证
 */
+ (void)sendSMSCheck:(NSString *)phoneNumber
               state:(int)state
             success:(TMHttpSuccess)success
              failed:(TMHttpFailed)failed;

/*修改用户信息
 userCode           String  必填  会员code
 nickName           string  选填  会员昵称
 birthday           string  选填  生日
 sex                Int     选填  性别 1 男 2 女
 password           string  选填  新密码
 mobile             string  选填  新手机号
 siteCode           string  必填  站点code
 */
+ (void)updateUser:(NSString *)userCode
          nickName:(NSString *)nickName
          birthday:(NSString *)birthday
               sex:(int)sex
          password:(NSString *)password
            mobile:(NSString *)mobile
          siteCode:(NSString *)siteCode
           success:(TMHttpSuccess)success
            failed:(TMHttpFailed)failed;

/*校验密码
 userCode       String  必填  会员code
 password       String  必填  会员密码
 */
+ (void)checkPassword:(NSString *)password
             userCode:(NSString *)userCode
              success:(TMHttpSuccess)success
               failed:(TMHttpFailed)failed;

/*修改用户头像
 picBase64      String  必填  头像图片数据,base64编码
 phoneNumber    String  必填  会员手机号
 */
+ (void)updateUserHeadPic:(NSString *)picBase64
                   mobile:(NSString *)phoneNumber
                  success:(TMHttpSuccess)success
                   failed:(TMHttpFailed)failed;

/*验证短信验证码
 phoneNumber        String  必填  会员手机号
 code               String  必填  输入的验证码
 */
+ (void)checkSMSCode:(NSString *)code
              mobile:(NSString *)phoneNumber
             success:(TMHttpSuccess)success
              failed:(TMHttpFailed)failed;

/*根据手机号修改密码
 mobile             String  必填  会员手机号
 password           String  必填  新密码
 siteCode           string  必填  站点code
 */
+ (void)updatePassword:(NSString *)password
                mobile:(NSString *)mobile
              siteCode:(NSString *)siteCode
               success:(TMHttpSuccess)success
                failed:(TMHttpFailed)failed;
@end
