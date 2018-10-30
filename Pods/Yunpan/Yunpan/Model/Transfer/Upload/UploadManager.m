//
//  UploadManager.m
//  Yunpan
//
//  Created by teason23 on 2018/10/16.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "UploadManager.h"
#import <ReactiveObjC.h>
#import "SingleUploadOperation.h"
#import "UploadRecordTB.h"

@interface UploadManager ()
@property (strong, nonatomic, readwrite) NSOperationQueue *uploadQueue ;
@end

@implementation UploadManager
XT_SINGLETON_M(UploadManager)

- (void)addAssetList:(NSArray<PHAsset *> *)assetlist parentID:(NSString *)parentID {
    
    for (int i = 0; i < assetlist.count; i++) {
        PHAsset *asset = assetlist[i] ;
        __block UploadRecordTB *rec = [[UploadRecordTB alloc] initWithAsset:asset parentID:parentID] ;
        BOOL canInsert = [rec insert] ;
        if (!canInsert) {
            NSLog(@"已有记录") ;
            rec = [UploadRecordTB findFirstWhere:STR_FORMAT(@"uniqueLocalKey == '%@'",asset.localIdentifier)] ;
            if (rec.isUploaded == 1) {
                NSLog(@"已有记录, 且上传过") ;
                continue ;
            }
        }
        
        @weakify(self)
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init] ;
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            
            @strongify(self)
            NSString *strPHImageFileUTIKey = [info[@"PHImageFileURLKey"] absoluteString] ;
            NSString *fileName = [SingleUploadOperation fileNameWithAsset:asset PHImageFileUTIKey:strPHImageFileUTIKey] ;
            NSString *mmtype = [SingleUploadOperation mmtypeWithPHImageFileUTIKey:strPHImageFileUTIKey] ;
            BOOL isHEIF = ([strPHImageFileUTIKey hasSuffix:@"HEIF"] || [strPHImageFileUTIKey hasSuffix:@"HEIC"]) ;
            if (isHEIF) {
                CIImage *ciImage = [CIImage imageWithData:imageData];
                CIContext *context = [CIContext context];
                imageData = [context JPEGRepresentationOfImage:ciImage colorSpace:ciImage.colorSpace options:@{}];
            }
            
            [rec appendProperties:fileName type:mmtype dataToWrite:imageData] ;
            [rec update] ;
            
            // single asset relase done. wait to upload .
            SingleUploadOperation *singleUploadOperation = [[SingleUploadOperation alloc] initWithPhAsset:asset uploadrecord:rec parentGuid:parentID fileName:fileName mimType:mmtype uploadComplete:^(UploadRecordTB *rec) {
                
                if (!rec) {
                    NSLog(@"error 失败") ;
                    rec.isUploaded = -1 ;
                    [rec update] ;
                }
                else {
                    rec.isUploaded = 1 ;
                    [rec updateWhereByProp:@"uniqueLocalKey"] ;
                }
                
                // one asset uploaded
                [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_UPLOAD_CHANGED object:nil] ;
                
            }] ;
            
            [self.uploadQueue addOperation:singleUploadOperation] ;
            
        }] ;
    }
    
    // refresh UI when assets are ready .
    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_UPLOAD_CHANGED object:nil] ;
}

- (NSOperationQueue *)uploadQueue {
    if (!_uploadQueue) {
        _uploadQueue = [[NSOperationQueue alloc] init] ;
        _uploadQueue.maxConcurrentOperationCount = 1 ;
    }
    return _uploadQueue ;
}

@end


