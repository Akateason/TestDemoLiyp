//
//  SMSHLoginManager.m
//  SMSHLogin
//
//  Created by teason23 on 2018/11/28.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "SMSHLoginManager.h"
#import <XTReq/XTReq.h>
#import "SMLMainVC.h"
#import "ShimoLoginNavVC.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "OpenShare+Weixin.h"

@interface SMSHLoginManager ()

@end

@implementation SMSHLoginManager
@synthesize currentUser = _currentUser ;
XT_SINGLETON_M(SMSHLoginManager)

/**
 线上环境      https://api.shimo.im
 dev 环境     https://api.shimodev.com
 release 环境 https://release.shimodev.com
 pre 环境     https://staging.shimo.run
 */
- (NSString *)host {
    if (!_host) {
        _host =
        [[SMSHLoginManager sharedInstance].configure isDevEnvironment] ?
        @"https://api.shimodev.com"
        :
        @"https://api.shimo.im" ;
    }
    return _host ;
}

- (void)setConfigure:(id<SMSHLoginManagerConfigure>)configure {
    _configure = configure ;
    
    // setup
    [self setup] ;
}

- (void)setup {
    [XTReqSessionManager shareInstance].isDebug = YES ;
    
    [self hudStyle] ;
    
    if ([self.configure respondsToSelector:@selector(weixinAppID)] && self.configure.weixinAppID.length) {
        [OpenShare connectWeixinWithAppId:self.configure.weixinAppID];
    }
}

- (void)hudStyle {
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleDark)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setDefaultAnimationType:(SVProgressHUDAnimationTypeNative)];
    [SVProgressHUD setInfoImage:nil] ;
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"mark_fail"]] ;
    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"mark_success"]];
    [SVProgressHUD dismissWithDelay:1.5] ;
}


#define kPathOfLocalUserInLibrary   XT_LIBRARY_PATH_TRAIL_(@"localUser.arc")
- (void)setCurrentUser:(SMSHLocalUser *)currentUser {
    _currentUser = currentUser ;
    
    [XTArchive archiveSomething:currentUser path:kPathOfLocalUserInLibrary] ;
}

- (SMSHLocalUser *)currentUser {
    if (!_currentUser) {
        _currentUser = [XTArchive unarchiveSomething:kPathOfLocalUserInLibrary] ;
    }
    return _currentUser ;
}

- (BOOL)isLogin {
    return self.currentUser.accessToken.length ;
}

- (void)doLogout {
    [XTFileManager deleteFile:kPathOfLocalUserInLibrary] ;
    _currentUser = nil ;
}

- (void)loginMainVCPresentFromCtrller:(UIViewController *)fromCtrller {
    [fromCtrller presentViewController:[self onlyGetLoginRootNavCtrller] animated:YES completion:nil] ;
}

- (UINavigationController *)onlyGetLoginRootNavCtrller {
    SMLMainVC *vc = [SMLMainVC getCtrllerFromStory:@"SMSHLogin"
                                            bundle:[NSBundle bundleForClass:self.class]
                              controllerIdentifier:@"SMLMainVC"] ;
    ShimoLoginNavVC *nav = [[ShimoLoginNavVC alloc] initWithRootViewController:vc] ;
    return nav ;
}

+ (BOOL)applicationHandleWithUrl:(NSURL *)url {
    return [OpenShare handleOpenURL:url] ;
}

@end
// Yunpan.app/Frameworks/SMSHLogin.framework 1
// Yunpan.app/Frameworks/SMSHLogin.framework
