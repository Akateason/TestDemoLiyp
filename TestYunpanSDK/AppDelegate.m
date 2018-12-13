//
//  AppDelegate.m
//  TestYunpanSDK
//
//  Created by teason23 on 2018/10/18.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "AppDelegate.h"
#import <Yunpan/SHMDriveSDK.h>


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

- (BOOL)onOpenFiletoEditor:(NSDictionary *)aFile localPath:(NSString *)path fromCtrller:(UIViewController *)fromCtrller {
    return NO ;
}

- (BOOL)hiddenExitButton {
    return YES ;
}

- (nonnull NSString *)tokenString {
    return @"12" ;
}

@end
