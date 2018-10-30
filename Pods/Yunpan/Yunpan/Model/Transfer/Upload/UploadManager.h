//
//  UploadManager.h
//  Yunpan
//
//  Created by teason23 on 2018/10/16.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XTlib.h>
#import <Photos/Photos.h>

// Notification
static NSString * _Nullable const kNOTIFICATION_UPLOAD_CHANGED = @"kNOTIFICATION_UPLOAD_CHANGED" ;





NS_ASSUME_NONNULL_BEGIN

@interface UploadManager : NSObject
XT_SINGLETON_H(UploadManager)

@property (strong, nonatomic, readonly) NSOperationQueue *uploadQueue ;
//@property (nonatomic) NSInteger countInOperation ;


/**
 add photo in upload queue 
 */
- (void)addAssetList:(NSArray<PHAsset *> *)assetlist parentID:(NSString *)parentID ;


@end

NS_ASSUME_NONNULL_END
