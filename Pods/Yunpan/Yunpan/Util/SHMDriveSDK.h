//
//  SHMDriveSDK.h
//  Yunpan
//
//  Created by teason23 on 2018/9/27.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XTlib/XTlib.h>
#import "YPFiles.h"
#import "YPNavVC.h"


#define kSHMDriveSDK_isDevEnviroment        [SHMDriveSDK sharedInstance].isDevEnviroment


NS_ASSUME_NONNULL_BEGIN

@protocol SHMDriveSDKDelegate <NSObject>
@required
- (NSInteger)userID ;
- (NSString *)userInfo ; // userInfo in JsonString
- (NSString *)tokenString ;
- (BOOL)onOpenFiletoEditor:(NSDictionary *)aFile localPath:(NSString *)path fromCtrller:(UIViewController *)fromCtrller ;
- (BOOL)hiddenExitButton ;
- (void)funcInHomeVCDidload:(UIViewController *)listVC ;
@end


@interface SHMDriveSDK : NSObject
XT_SINGLETON_H(SHMDriveSDK)
@property (weak, nonatomic) id <SHMDriveSDKDelegate> delegate ;
@property (nonatomic) BOOL isDebug ; // show log
@property (nonatomic) BOOL isDevEnviroment ; // 测试环境 or 生产环境
- (void)prepareInAppDidLaunch ; // appDidfinishload
- (void)prepareWhenUserHasLogin ; // user has login
- (NSString *)defaultDownloadFolderPath ;
- (UIViewController *)getStartCtrller ;
@end

NS_ASSUME_NONNULL_END
