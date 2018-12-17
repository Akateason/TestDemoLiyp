//
//  SMSHLocalUser.h
//  SMSHLogin
//
//  Created by teason23 on 2018/11/29.
//  Copyright © 2018 teason23. All rights reserved.
// 任意 登录, 绑定, 修改操作都要 修改此备份.

#import <Foundation/Foundation.h>
#import "SMSHUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMSHLocalUser : NSObject

@property (copy, nonatomic) NSString *accessToken ;
@property (strong, nonatomic) SMSHUserInfo *userInfo ;

//todo
//@property (copy, nonatomic) NSString *wechatinfo ;


@end

NS_ASSUME_NONNULL_END
