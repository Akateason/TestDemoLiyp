//
//  UrlConfig.m
//  Yunpan
//
//  Created by teason23 on 2018/9/11.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "UrlConfig.h"
#import <XTReq.h>
#import "SHMDriveSDK.h"
#import <SDWebImageDownloader.h>

static NSString *const kDevBaseUrl      = @"https://drive.shimodev.com/drive-api" ;
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
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader] ;
    [manager setValue:[[SHMDriveSDK sharedInstance].delegate cookieInfo] forHTTPHeaderField:@"Cookie"] ;
    
    
}

@end
