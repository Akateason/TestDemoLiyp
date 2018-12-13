//
//  SingleUploadOperation.m
//  Yunpan
//
//  Created by teason23 on 2018/9/18.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "SingleUploadOperation.h"
#import <Photos/Photos.h>
#import "UploadRecordTB.h"
#import "YPFiles+Request.h"
#import <XTlib/XTlib.h>

NSString *const kNotificationUPloadProgressChanged = @"kNotificationUPloadProgressChanged" ;

@interface SingleUploadOperation ()
{
    BOOL m_executing ;
    BOOL m_finished ;
}
@property (strong, nonatomic)   PHAsset         *asset ;
@property (copy, nonatomic)     NSString        *parentGuid ;
@property (copy, nonatomic)     NSString        *fileName ;
@property (copy, nonatomic)     NSString        *mimType ;
@property (strong, nonatomic)   UploadRecordTB  *uploadRec ;
@property (nonatomic, copy)     uploadCompleted blkUploadCompleted ;
@end

@implementation SingleUploadOperation

- (instancetype)initWithUploadrecord:(UploadRecordTB *)rec
                          parentGuid:(NSString *)parentGuid
                            fileName:(NSString *)fileName
                             mimType:(NSString *)mimType
                      uploadComplete:(uploadCompleted)uploadCompletion {
    
    self = [super init] ;
    if (self) {
        _parentGuid = parentGuid ;
        _uploadRec = rec ;
        _fileName = fileName ;
        _mimType = mimType ;
        _blkUploadCompleted = uploadCompletion ;
    }
    return self;
}

- (void)start {
    @autoreleasepool {
        
        [self willChangeValueForKey:@"isExecuting"] ;
        m_executing = YES ;
        [self didChangeValueForKey:@"isExecuting"] ;
        
        if (self.isCancelled) {
            [self willChangeValueForKey:@"isFinished"] ;
            self->m_finished = YES ;
            [self didChangeValueForKey:@"isFinished"] ;
            return ;
        }
        
        NSDictionary *dic = @{ @"progressVal":@(0) ,
                               @"key":self.uploadRec.uniqueLocalKey } ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUPloadProgressChanged object:dic] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [YPFiles fileUploadWithFileName:self.fileName
                       parentGuid:self.parentGuid
                         fileType:self.mimType
                             file:self.uploadRec.aData
                         progress:^(double progressVal) {
                             
                             NSDictionary *dic = @{ @"progressVal":@(progressVal) ,
                                                    @"key":self.uploadRec.uniqueLocalKey } ;
//                             NSLog(@"send dic : %@",dic) ;
                             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUPloadProgressChanged object:dic] ;
                             
                         } complete:^(YPFiles *aFile) {
                             
                             if (self.isCancelled) {
                                 [self willChangeValueForKey:@"isFinished"] ;
                                 self->m_finished = YES ;
                                 [self didChangeValueForKey:@"isFinished"] ;
                                 return ;
                             }
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 self.uploadRec.serverFiles = aFile ;
                                 self.uploadRec.serverGuid = aFile.guid ;
                                 [self.uploadRec xt_updateWhereByProp:@"uniqueLocalKey"] ;
                                 
                                 self.blkUploadCompleted(self.uploadRec) ;
                                 
                                 [self willChangeValueForKey:@"isExecuting"] ;
                                 self->m_executing = NO ;
                                 [self didChangeValueForKey:@"isExecuting"] ;
                                 
                                 [self willChangeValueForKey:@"isFinished"] ;
                                 self->m_finished = YES ;
                                 [self didChangeValueForKey:@"isFinished"] ;
                                 
                             }) ;
                             
                         }] ;
            
        }) ;
    }
}

+ (NSString *)fileNameWithAsset:(PHAsset *)asset PHImageFileUTIKey:(NSString *)PHImageFileUTIKey {
    NSString *namePrefix = [asset.creationDate xt_getStrWithFormat:@"YYYY-MM-dd HHmmss"] ;
    if ([PHImageFileUTIKey hasSuffix:@".png"]) {
        return [namePrefix stringByAppendingString:@".png"] ;
    }
    return [namePrefix stringByAppendingString:@".jpg"] ;
}

+ (NSString *)mmtypeWithPHImageFileUTIKey:(NSString *)PHImageFileUTIKey {
    if ([PHImageFileUTIKey hasSuffix:@".png"]) {
        return @"image/png" ;
    }
    else if ([PHImageFileUTIKey hasSuffix:@".heic"]) {
        return @"image/jpeg" ;
    }
    return @"image/jpeg" ;
}

- (BOOL)isExecuting {
    return m_executing ;
}

- (BOOL)isFinished {
    return m_finished ;
}

- (BOOL)isConcurrent {
    return YES ;
}


@end
