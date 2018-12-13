//
//  YPDownloadManager.h
//  Yunpan
//
//  Created by teason23 on 2018/10/17.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XTlib/XTlib.h>
#import "YPSingleDownloadOperation.h"
@class YPFiles,DownloadRecordTB ;

NS_ASSUME_NONNULL_BEGIN

@interface YPDownloadManager : NSObject
XT_SINGLETON_H(YPDownloadManager)
@property (strong, nonatomic, readonly) NSOperationQueue *downloadQueue ;

/**
 Download file list . add files in download queue
 目前不支持文件夹. 纯文件列表
 */
- (void)addFileList:(NSArray<YPFiles *> *)fileList ;

/**
 Download one file . add file in download queue
 */
- (void)addOneFile:(YPFiles *)afile
          complete:(void(^)(BOOL success, DownloadRecordTB *rec))complete ;

/**
 file has downloaded ?
 */
- (BOOL)fileHasDownloaded:(YPFiles *)afile ;

// cancel one
- (void)cancelOneOperationWitnFileGuid:(NSString *)guid ;

@end

NS_ASSUME_NONNULL_END
