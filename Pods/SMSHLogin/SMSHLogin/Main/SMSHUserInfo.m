//
//  SMSHUserInfo.m
//  SMSHLogin
//
//  Created by teason23 on 2018/12/3.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "SMSHUserInfo.h"
#import <XTBase/XTBase.h>

@implementation SMSHUserInfo

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"userID" : @"id"
             };
}

XT_encodeWithCoderRuntimeCls(SMSHUserInfo)

XT_initWithCoderRuntimeCls(SMSHUserInfo)

@end
