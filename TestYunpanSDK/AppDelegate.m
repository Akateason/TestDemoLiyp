//
//  AppDelegate.m
//  TestYunpanSDK
//
//  Created by teason23 on 2018/10/18.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "AppDelegate.h"
#import <Yunpan/SHMDriveSDK.h>
#import <SMSHLogin/SMSHLoginManager.h>
#import <XTBase/XTBase.h>
#import <Yunpan/ListVC.h>

@interface AppDelegate () <SHMDriveSDKDelegate,SMSHLoginManagerConfigure>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Nav style
    [[UIApplication sharedApplication] keyWindow].tintColor = [UIColor whiteColor] ;
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]] ;
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}] ;
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]] ;
    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]] ;

    [SHMDriveSDK sharedInstance].isDevEnviroment = NO ;
    [SHMDriveSDK sharedInstance].isDebug = YES ;
    [SHMDriveSDK sharedInstance].delegate = self ;

    // Login
    [SMSHLoginManager sharedInstance].configure = self ;
    
    
    UIViewController *vc = [[SHMDriveSDK sharedInstance] getStartCtrller] ;
    YPNavVC *nav = [[YPNavVC alloc] initWithRootViewController:vc] ;
//    [self presentViewController:nav animated:YES completion:nil] ;
    
    self.window.rootViewController = nav ;
    
    return YES;
}



#pragma mark - SHMDriveSDKDelegate
//@required
- (NSInteger)userID {
    return [SMSHLoginManager sharedInstance].currentUser.userInfo.userID ;
}

- (NSString *)userInfo {
    return [[SMSHLoginManager sharedInstance].currentUser yy_modelToJSONString] ;
}

- (NSString *)tokenString {
    return [SMSHLoginManager sharedInstance].currentUser.accessToken ?: @"" ;
}

- (BOOL)onOpenFiletoEditor:(NSDictionary *)aFile localPath:(NSString *)path fromCtrller:(UIViewController *)fromCtrller {
    return NO ;
}

- (BOOL)hiddenExitButton {
    return YES ;
}

- (void)funcInHomeVCDidload:(UIViewController *)listVC {
    if (![SMSHLoginManager sharedInstance].isLogin) {
        [[SMSHLoginManager sharedInstance] loginMainVCPresentFromCtrller:listVC] ;
    }
    
    UIButton *cusBt = [UIButton new] ;
    [cusBt setImage:[UIImage imageNamed:@"userPlaceHolder"] forState:0] ;
    [[cusBt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self tapLogin:(ListVC *)listVC] ;
    }] ;
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:cusBt];
    listVC.navigationItem.leftBarButtonItem = item;
}

- (void)tapLogin:(ListVC *)listVC {
    if (![SMSHLoginManager sharedInstance].isLogin) {
        [[SMSHLoginManager sharedInstance] loginMainVCPresentFromCtrller:[UIViewController xt_topViewController]] ;
    }
    else {
        [UIAlertController xt_showAlertCntrollerWithAlertControllerStyle:(UIAlertControllerStyleAlert) title:@"" message:@"退出登录?" cancelButtonTitle:@"否" destructiveButtonTitle:@"是的" otherButtonTitles:nil callBackBlock:^(NSInteger btnIndex) {
            
            if (btnIndex == 1) {
                [[SMSHLoginManager sharedInstance] doLogout] ;
                [listVC.table xt_loadNewInfoInBackGround:NO] ;
            }
        }] ;
    }
}

#pragma mark - login

- (BOOL)isDevEnvironment {
    return [SHMDriveSDK sharedInstance].isDevEnviroment ;
}

//- (UIView *)containCustomView ;
//- (NSString *)weixinAppID  // if nil hide wechat login button}

- (NSString *)clientId {
    return kSHMDriveSDK_isDevEnviroment ? @"C5348F2D3384F4E522263523C9F61" : @"C8BA527C783AB2AB644CC3FF6CC7D" ;
}

- (NSString *)clientSecret {
    return kSHMDriveSDK_isDevEnviroment ? @"AFA9514F795DABC9B7A19954944CE" : @"E5DCCF96EBB6BE9A3193DDE39B1B3" ;
}

- (void)userLoginComplete:(BOOL)success {
//    NSLog(@"asdfasfdasdfadsfasf323423423423434") ;
    
    [[SHMDriveSDK sharedInstance] prepareWhenUserHasLogin] ;
}

@end
