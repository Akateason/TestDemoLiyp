//
//  SMSHLoginManager.h
//  SMSHLogin
//
//  Created by teason23 on 2018/11/28.
//  Copyright © 2018 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XTBase/XTBase.h>
#import "SMSHLocalUser.h"
#import "SMSHUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SMSHLoginManagerConfigure <NSObject>
@optional
- (BOOL)isDevEnvironment ;
- (UIView *)containCustomView ;
- (NSString *)weixinAppID ; // if nil hide wechat login button

@required
- (NSString *)clientId ;
- (NSString *)clientSecret ;
@end


@interface SMSHLoginManager : NSObject
XT_SINGLETON_H(SMSHLoginManager)

@property (weak, nonatomic)     id <SMSHLoginManagerConfigure> configure ;
@property (copy, nonatomic)     NSString                       *host ;
@property (strong, nonatomic)   SMSHLocalUser                  *currentUser ;
@property (nonatomic)           BOOL                           isLogin ;

- (void)doLogout ;

- (void)loginMainVCPresentFromCtrller:(UIViewController *)fromCtrller ;
@end

NS_ASSUME_NONNULL_END
