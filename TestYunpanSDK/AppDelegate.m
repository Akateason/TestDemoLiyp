//
//  AppDelegate.m
//  TestYunpanSDK
//
//  Created by teason23 on 2018/10/18.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "AppDelegate.h"
#import "SHMDriveSDK.h"

@interface AppDelegate () <SHMDriveSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [SHMDriveSDK sharedInstance].isDebug = YES ;
    [SHMDriveSDK sharedInstance].delegate = self ;

    return YES;
}



#pragma mark - SHMDriveSDKDelegate

//@required
- (NSInteger)userID {
    return 12428 ;
}

- (NSString *)userInfo {
    return nil ;
}

- (NSString *)cookieInfo {
    return
    kSHMDriveSDK_isDevEnviroment
    ?
    @"shimo_dev_sid=s%3ARr4Gdi-Vs7EXhINUUpS8KKStKyMfgHLs.tTMpYPUDllikiY%2BBDtSUE9e%2FDBXioJxiXSYfPhxpE%2Fg"
    :
    @"shimo_sid=s%3ALEAh_cU10mMFOiZlbw_kmYeVvDMhzzsv.FSxWwyQNmxcSiN3DBxxxAKNduV9dmpNicAuVylHR6bE"
    ;
}

- (void)onOpenFiletoEditor:(NSDictionary *)aFile localPath:(NSString *)path fromCtrller:(UIViewController *)fromCtrller {
    
}



@end
