//
//  UploadManager.h
//  Yunpan
//
//  Created by teason23 on 2018/10/16.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XTlib/XTlib.h>
#import <Photos/Photos.h>

// Notification
static NSString * _Nullable const kNOTIFICATION_UPLOAD_CHANGED = @"kNOTIFICATION_UPLOAD_CHANGED" ;


@class UploadRecordTB ;


NS_ASSUME_NONNULL_BEGIN

@interface UploadManager : NSObject
XT_SINGLETON_H(UploadManager)

@property (strong, nonatomic, readonly) NSOperationQueue *uploadQueue ;

/**
 upload list from album
 */
- (void)addAssetList:(NSArray<PHAsset *> *)assetlist parentID:(NSString *)parentID ;


/**
 upload a file from file
 */
- (void)addOneFile:(UploadRecordTB *)rec ;


// cancel one
- (void)cancelOneOperationWitnFileGuid:(NSString *)guid ;

@end

NS_ASSUME_NONNULL_END
