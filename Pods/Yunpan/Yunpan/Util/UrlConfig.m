//
//  UrlConfig.m
//  Yunpan
//
//  Created by teason23 on 2018/9/11.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "UrlConfig.h"
#import <XTReq/XTReq.h>
#import "SHMDriveSDK.h"
#import <YYWebImage/YYWebImage.h>
#import "YPFiles+Request.h"

static NSString *const kDevBaseUrl      = @"https://shimodev.com/drive-api" ;
static NSString *const kFomalBaseUrl    = @"https://shimo.im/drive-api" ;


@implementation UrlConfig
XT_SINGLETON_M(UrlConfig)

- (NSString *)UrlAppend:(NSString *)partUrlStr {
    if (kSHMDriveSDK_isDevEnviroment) {
        return [kDevBaseUrl stringByAppendingString:partUrlStr] ;
    }
    else {
        return [kFomalBaseUrl stringByAppendingString:partUrlStr] ;
    }    
}

- (void)setup {
    [YYWebImageManager sharedManager].headers = kMutableYPHeader ;
}

@end
