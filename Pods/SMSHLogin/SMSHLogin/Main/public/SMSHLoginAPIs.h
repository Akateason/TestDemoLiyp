//
//  SMSHLoginAPIs.h
//  SMSHLogin
//
//  Created by teason23 on 2018/11/28.
//  Copyright © 2018 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SMSHUserInfo ;

@interface SMSHLoginAPIs : NSObject

+ (NSString *)UrlAppend:(NSString *)nail;
+ (NSMutableDictionary *)defaultHeader ;

/**
 发验证码
 type    sms 或者 voice，不传默认 sms    sms 表示短信，voice 表示语音，目前语音只支持大陆手机号
 mobile    示例: +8617288970986    手机号
 scenes    login/change_password/change_mobile/bind/register/authentication    用途：登录/修改密码/修改手机号/绑定/注册/安全验证
 */
+ (void)sendVerificationCodeWithType:(NSString *)type
                              mobile:(NSString *)mobile
                              scenes:(NSString *)scenes
                          geetestDic:(NSDictionary *)geetestDic
                            complete:(void(^)(BOOL bSuccess))completion ;

/**
 POST /action/send_email_code
 发送验证码到邮箱
 
 email    xx@xx.xx    邮箱地址
 scenes    change_password/bind/authentication    场景，目前支持修改密码和绑定邮箱  安全验证：authentication
 */
+ (void)sendEmailCodeWithEmail:(NSString *)email
                       scences:(NSString *)scence
                    geetestDic:(NSDictionary *)geetestDic
                      complete:(void(^)(BOOL bSuccess))completion ;

/**
 注册
 POST /users
 name    字符串，长度在 1~ 20 之间，  具体校验规则见👇    用户名，必填
 email    符合邮箱规则，具体校验逻辑见 @shimo/referee    邮箱，邮箱或者手机号必须提供一个
 mobile    符合手机号规则，具体校验逻辑在👆    手机号，邮箱或者手机号必须提供一个
 mobileVerifyCode    字符串，手机号验证码    手机号验证码，提供手机号时必填
 password    具体校验规则见 @shimo/referee    密码，必填
 avatar    字符串    头像地址，非必填
 parentId    字符串，邀请者 id    是哪个用户邀请来的，非必填
 
 ref    字符串，用户来源    用户是从哪个链接跳转到石墨的，非必填
 referer    字符串  mail_team_invite  mail_collaborator_invite  wechat_collaborator_invite  link_file_invite  link_team_invite    用户是通过什么内部渠道来的，非必填
 inviter    邀请者 id    仅限于上述 referer 的邀请者
 */
+ (void)registUserName:(NSString *)name
                 email:(NSString *)email
              orMobile:(NSString *)mobile
      mobileVerifyCode:(NSString *)mobileVerifyCode
              password:(NSString *)password
                avatar:(NSString *)avatar
              parentId:(NSString *)parentId
                   ref:(NSString *)ref
               referer:(NSString *)referer
               inviter:(NSString *)inviter
            geetestDic:(NSDictionary *)geetestDic
              complete:(void(^)(BOOL bSuccess))completion ;

/**
 GET /users/mobile
 通过手机号获取用户信息
 mobile 可以带区号如 +86 但注意要 encode 一下"+"，也可以不带 +86, 直接写手机号，这种情况下认为默认区号 +86
 */
+ (void)getUserWithMobile:(NSString *)mobile
                 complete:(void(^)(BOOL bSuccess, id json))completion ;

/*
获取我的信息
*/
+ (void)getMyUserInfoComplete:(void(^)(BOOL bSuccess, SMSHUserInfo *userInfo))completion ;

/**
 POST /users/action/reset_password_by_code
 通过手机号和验证码重置密码
 邮箱，与手机号二选一
 */
+ (void)resetPasswordWithMobile:(NSString *)mobile
                        orEmail:(NSString *)email
                     verifyCode:(NSString *)verifyCode
                       password:(NSString *)password
                       complete:(void(^)(BOOL bSuccess))completion ;

/**
 POST /users/:userId/action/bind_mobile
 已有账号绑定手机号
 
 mobile             示例: +8613145678765    手机号，校验规则同上
 mobileVerifyCode   示例: 1234    验证码
 password    xxxxxxxxx    密码，携带此参数会覆盖旧密码
 filing    true 或 false    该手机号如果已被其他账号绑定，是否用作备案手机号  默认为 false  打开公开链接时，需要传 true，这样在发现手机号已被绑定时会绑定到备案
 手机号中
 premium    ['true', 'false']    是否赠送15天高级版
 
 响应示例： {
 isMobileAccount: true // 该手机号是否绑定为该用户的登录凭证
 }
 */
+ (void)accoutnBindMobile:(NSString *)mobile
         mobileVerifyCode:(NSString *)mobileVerifyCode
                 password:(NSString *)password
                   filing:(NSString *)filing
                  premium:(NSString *)premium ;

/**
 GET /wechat/action/binding_info
 获取账号绑定情况 -- 微信、手机号、邮箱
 userId    用户 id，非必填    根据用户 id 获取用户绑定情况
 openId    微信提供的 openId，非必填    根据微信 openId 获取用户绑定情况
 unionId    微信提供的 unionId，非必填    根据微信 unionId 获取用户绑定情况
 code    微信提供的 code，非必填    根据微信 code 获取用户绑定情况
 email    邮箱，非必填    根据邮箱获取用户绑定情况
 mobile    手机号，非必填    根据手机号获取用户绑定情况
 */
+ (void)getWechatBindInfoWithUserId:(NSString *)userId
                             openId:(NSString *)openId
                            unionId:(NSString *)unionId
                               code:(NSString *)code
                              email:(NSString *)email
                             mobile:(NSString *)mobile
                           complete:(void(^)(BOOL bSuccess))completion ;

/**
 POST /captchas
 获取验证码
 type    web 或者 mobile    验证码类型，默认为 web
 
 返回数据示例：{
 challenge: 'e4adb286f449854be74f9bb4e6c144cf'
 }
 */
+ (void)captchasComplete:(void(^)(BOOL bSuccess))completion ;


/**
 POST /oauth/token
 获取 oauth token
 
 手机号验证码登录：
 grant_type: password
 username: +86xxxxxxxxx
 mobileVerifyCode: xxxx
 
 手机号密码登录:
 grant_type: password
 username: +86xxxxxxxxx
 password: xxxxxxxx
 
 client_id    客户端 ID
 client_secret    客户端密码
 grant_type    授权类型    本次修改了授权类型为 password 的接口
 username    邮箱或手机号    本次添加对于手机号的支持，password 授权类型必填
 password    密码    password 授权类型必填
 scope    权限    password 授权类型必填
 code    微信提供的 code，非必填    绑定微信需要
 mobileVerifyCode    4 位验证码    username 不是邮箱时需要提供此参数
 */
+ (void)getOauthTokenWithMobile:(NSString *)mobile
                           mail:(NSString *)mail
                       password:(NSString *)password
                           code:(NSString *)code
               mobileVerifyCode:(NSString *)mobileVerifyCode
                     geetestDic:(NSDictionary *)geetestDic
                       complete:(void(^)(BOOL bSuccess, id json))completion ;

/**
 POST /users/me/action/unbind
 被禁用用户解绑微信、手机号、邮箱
 
 @param type     wechat / mobile / email    通过 type 指定解绑类型
 */
+ (void)unbindUserWithType:(NSString *)type
                  complete:(void(^)(BOOL bSuccess, id json))completion ;

/**
 POST /action/verify_verification_code
 验证验证码是否正确
 
 mobile    +8619877362245                               手机号
 scenes    login/change_password/change_mobile/bind     场景
 code    xxxx                                           验证码
 email    xxx@xx.xx                                     邮箱
 */
+ (void)verifyVerificationCodeWithMobile:(NSString *)mobile
                                 orEmail:(NSString *)email
                                  scenes:(NSString *)scenes
                                    code:(NSString *)code
                                complete:(void(^)(BOOL bSuccess))completion ;

/**
 POST /users/:id/action/verify_password
 验证密码是否正确
 */
+ (void)verifyPassword:(NSString *)pwd
            geetestDic:(NSDictionary *)geetestDic
              complete:(void(^)(BOOL bSuccess))completion ;

/**
 POST /users/:id/action/bind_email
 绑定邮箱
 
 email    abc@shimo.im    邮箱
 code    1234             邮箱验证码
 premium    ['true', 'false']    是否赠送15天高级版
 password    xxxxxxxxx    设置新密码，当用户无密码，此字段有效。mengda
 */
+ (void)bindEmail:(NSString *)email
             code:(NSString *)code
          premium:(NSString *)premium
         password:(NSString *)password
         complete:(void(^)(BOOL bSuccess))completion ;

/**
 POST /users/:user/action/change_mobile
 修改手机号
 用户密码和原手机验证码只填一个
 
 mobile      +8613111111111
 password    123456    用户密码
 lastCode    1234    原手机验证码
 code        1234    新手机验证码
 authToken   xxxxxxxxxxxxxxxx    安全验证验证码
 */
+ (void)changeMobile:(NSString *)mobile
                 pwd:(NSString *)pwd
            lastCode:(NSString *)lastCode
                code:(NSString *)code
            complete:(void(^)(BOOL bSuccess))completion ;

/**
 POST /users/:user/action/change_email
 通过安全验证的验证码，修改邮箱
 
 email    abc@shimo.im
 code    1234    邮箱验证码
 authToken    xxxxxxxxxxxxxxxx    安全验证验证码
 */
+ (void)changeEmail:(NSString *)email
               code:(NSString *)code
           complete:(void(^)(BOOL bSuccess))completion ;

/**
 POST /login (cow)
 cow 登录接口使用手机号登录
 可使用登录组合：email+password; mobile+password; mobile+code
 
 email    abc@shimo.im
 mobile    +8613122223333
 password    123456
 code    1234    手机验证码
 */
+ (void)loginWithEmail:(NSString *)email
                mobile:(NSString *)mobile
                   pwd:(NSString *)pwd
                  code:(NSString *)code
              complete:(void(^)(BOOL bSuccess, id json))completion ;

/**
 POST /action/get_auth_token
 获取安全验证码
 
 mobile  +8619877362245     手机号
 code    xxxx               验证码
 email    xxx@xx.xx         邮箱
 */
+ (void)getAuthToken:(NSString *)mobile
                code:(NSString *)code
               email:(NSString *)email
            complete:(void(^)(BOOL bSuccess, id json))completion ;

@end

