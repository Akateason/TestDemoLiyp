//
//  UploadManager.m
//  Yunpan
//
//  Created by teason23 on 2018/10/16.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "UploadManager.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "SingleUploadOperation.h"
#import "UploadRecordTB.h"
#import "YPFiles.h"

@interface UploadManager ()
@property (strong, nonatomic, readwrite) NSOperationQueue *uploadQueue ;
@end

@implementation UploadManager
XT_SINGLETON_M(UploadManager)



- (void)addAssetList:(NSArray<PHAsset *> *)assetlist parentID:(NSString *)parentID {
    
    for (int i = 0; i < assetlist.count; i++) {
        PHAsset *asset = assetlist[i] ;
        __block UploadRecordTB *rec = [[UploadRecordTB alloc] initWithAsset:asset parentID:parentID] ;
        BOOL canInsert = [rec xt_insert] ;
        if (!canInsert) {
            NSLog(@"已有记录") ;
            rec = [UploadRecordTB xt_findFirstWhere:STR_FORMAT(@"uniqueLocalKey == '%@'",asset.localIdentifier)] ;
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
            [rec xt_update] ;
            
            // single asset relase done. wait to upload .
            SingleUploadOperation *singleUploadOperation = [[SingleUploadOperation alloc] initWithUploadrecord:rec parentGuid:parentID fileName:fileName mimType:mmtype uploadComplete:^(UploadRecordTB *rec) {
                
                if (!rec) {
                    NSLog(@"error 失败 , %@",fileName) ;
                    rec.isUploaded = -1 ;
                    [rec xt_update] ;
                }
                else {
                    rec.isUploaded = 1 ;
                    [rec xt_updateWhereByProp:@"uniqueLocalKey"] ;
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

- (void)addOneFile:(UploadRecordTB *)rec {
    
    SingleUploadOperation *op = [[SingleUploadOperation alloc] initWithUploadrecord:rec parentGuid:rec.parentGuid fileName:rec.fileName mimType:rec.mimeType uploadComplete:^(UploadRecordTB *rec) {
        
        if (!rec) {
            NSLog(@"error 失败 , %@",rec.fileName) ;
            rec.isUploaded = -1 ;
            [rec xt_update] ;
        }
        else {
            rec.isUploaded = 1 ;
            [rec xt_updateWhereByProp:@"uniqueLocalKey"] ;
        }
        
        // one asset uploaded
        [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_UPLOAD_CHANGED object:nil] ;

    }] ;
    [self.uploadQueue addOperation:op] ;
}

// cancel one
- (void)cancelOneOperationWitnFileGuid:(NSString *)guid {
    [self.uploadQueue.operations enumerateObjectsUsingBlock:^(__kindof SingleUploadOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.uploadRec.serverFiles.guid isEqualToString:guid]) {
            [obj cancel] ;
            *stop = YES ;
            return ;
        }
    }] ;
}



- (NSOperationQueue *)uploadQueue {
    if (!_uploadQueue) {
        _uploadQueue = [[NSOperationQueue alloc] init] ;
        _uploadQueue.maxConcurrentOperationCount = 1 ;
    }
    return _uploadQueue ;
}

@end


