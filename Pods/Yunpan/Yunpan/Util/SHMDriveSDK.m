//
//  SHMDriveSDK.m
//  Yunpan
//
//  Created by teason23 on 2018/9/27.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "SHMDriveSDK.h"
#import "YPFolderMananger.h"
#import "UploadRecordTB.h"
#import "DownloadRecordTB.h"
#import "YPListSortView.h"
#import <XTlib/XTlib.h>
#import "UrlConfig.h"
#import "ListVC.h"

@implementation SHMDriveSDK
@synthesize delegate = _delegate ;
XT_SINGLETON_M(SHMDriveSDK)

- (void)prepareInAppDidLaunch {
    NSString *dbPath = XT_LIBRARY_PATH_TRAIL_(@"ShmYunpan") ;
    [[XTFMDBBase sharedInstance] configureDBWithPath:dbPath] ;
    [XTCacheRequest configXTCacheReqWhenAppDidLaunchWithDBPath:dbPath] ;
    
    [[YPListSortManager sharedInstance] setup] ;
    [[UrlConfig sharedInstance] setup] ;
    
}

- (void)setDelegate:(id<SHMDriveSDKDelegate>)delegate {
    _delegate = delegate ;
    
    NSInteger userID = delegate.userID ;
//    NSCAssert((userID > 0), @"SHMYunpanSDK Error. userID is null !!!") ;
    
    [XTFileManager createFolder:XT_DOCUMENTS_PATH_TRAIL_(@"download")] ;
    [XTFileManager createFolder:XT_DOCUMENTS_PATH_TRAIL_(@"uploadFiles")] ;
    if (userID > 0) [XTFileManager createFolder:[self defaultDownloadFolderPath]] ;
    
    [self prepareInAppDidLaunch] ;
}

- (void)setIsDebug:(BOOL)isDebug {
    _isDebug = isDebug ;
    
    [XTReqSessionManager shareInstance].isDebug = isDebug ;
    [XTFMDBBase sharedInstance].isDebugMode = isDebug ;
}

- (NSString *)defaultDownloadFolderPath {
    return XT_DOCUMENTS_PATH_TRAIL_(STR_FORMAT(@"download/%@",@(self.delegate.userID))) ;
}

- (UIViewController *)getStartCtrller {
    ListVC *listVc = [ListVC getCtrllerFromStory:@"YPHome" bundle:[NSBundle bundleForClass:self.class] controllerIdentifier:@"ListVC"] ;
    return listVc ;
}

- (void)prepareWhenUserHasLogin {
    [XTFileManager createFolder:XT_DOCUMENTS_PATH_TRAIL_(@"download")] ;
    [XTFileManager createFolder:XT_DOCUMENTS_PATH_TRAIL_(@"uploadFiles")] ;
    NSInteger userID = self.delegate.userID ;
    if (userID > 0) [XTFileManager createFolder:[self defaultDownloadFolderPath]] ;
    
    [self prepareInAppDidLaunch] ;
}

@end
