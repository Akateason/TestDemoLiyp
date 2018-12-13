//
//  YPDownloadManager.m
//  Yunpan
//
//  Created by teason23 on 2018/10/17.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPDownloadManager.h"
#import "YPFiles.h"
#import "YPFiles+Request.h"
#import "DownloadRecordTB.h"
#import "SHMDriveSDK.h"


@interface YPDownloadManager ()
@property (strong, nonatomic, readwrite) NSOperationQueue *downloadQueue ; // max concurent count 5
@end

@implementation YPDownloadManager
XT_SINGLETON_M(YPDownloadManager)


/**
 Download file list . add files in download queue
 目前不支持文件夹. 纯文件列表
 */
- (void)addFileList:(NSArray<YPFiles *> *)fileList {
    WEAK_SELF
    [fileList enumerateObjectsUsingBlock:^(YPFiles * _Nonnull aFile, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf addOneFile:aFile complete:^(BOOL success, DownloadRecordTB * _Nonnull rec) {}] ;
    }] ;
}

/**
 Download one file . add file in download queue
 */
- (void)addOneFile:(YPFiles *)afile
          complete:(void(^)(BOOL success, DownloadRecordTB *rec))complete {
 
    NSString *user = @([SHMDriveSDK sharedInstance].delegate.userID).stringValue ;
    DownloadRecordTB *rec = [[DownloadRecordTB alloc] initWithFile:afile userID:user] ;
    
    if ([DownloadRecordTB xt_hasModelWhere:STR_FORMAT(@"guid == '%@'",afile.guid)]) {
        rec = [DownloadRecordTB xt_findFirstWhere:STR_FORMAT(@"guid == '%@'",afile.guid)] ;
        if (rec.isDownloaded != 1) {
            // 已存在记录, 但未下载完成.
            rec.isDownloaded = 2 ; // 正在下载
            [rec xt_update] ;
            
            YPSingleDownloadOperation *operation = [[YPSingleDownloadOperation alloc] initWithFile:afile rec:rec finish:complete] ;
            [self.downloadQueue addOperation:operation] ;
        }
        else {
            // 已经下载过.
            if (complete) complete(YES,rec) ;
        }
    }
    else {
        // 未存在记录, 去下载
        [rec xt_insert] ;
        
        YPSingleDownloadOperation *operation = [[YPSingleDownloadOperation alloc] initWithFile:afile rec:rec finish:complete] ;
        [self.downloadQueue addOperation:operation] ;
    }
}


/**
 file has downloaded ?
 */
- (BOOL)fileHasDownloaded:(YPFiles *)afile {
    NSString *user = @([SHMDriveSDK sharedInstance].delegate.userID).stringValue ;
    DownloadRecordTB *rec = [[DownloadRecordTB alloc] initWithFile:afile userID:user] ;
    if ([DownloadRecordTB xt_hasModelWhere:STR_FORMAT(@"guid == '%@'",afile.guid)]) {
        rec = [DownloadRecordTB xt_findFirstWhere:STR_FORMAT(@"guid == '%@'",afile.guid)] ;
        if (!rec.isDownloaded) return NO ;
        else return YES ;
    }
    else return NO ;
}

// cancel one
- (void)cancelOneOperationWitnFileGuid:(NSString *)guid {
    [self.downloadQueue.operations enumerateObjectsUsingBlock:^(__kindof YPSingleDownloadOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.afile.guid isEqualToString:guid]) {
            [obj cancel] ;
            *stop = YES ;
            return ;
        }
    }] ;
}

#pragma mark - prop

- (NSOperationQueue *)downloadQueue {
    if (!_downloadQueue) {
        _downloadQueue = [[NSOperationQueue alloc] init] ;
        _downloadQueue.maxConcurrentOperationCount = 5 ;
    }
    return _downloadQueue ;
}

@end
