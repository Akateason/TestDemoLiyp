//
//  YPSingleDownloadOperation.m
//  Yunpan
//
//  Created by teason23 on 2018/10/17.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPSingleDownloadOperation.h"
#import "YPFolderMananger.h"
#import "YPFiles+Request.h"
#import <ReactiveObjC.h>

NSString *const kNotificationOneFileDownloadClick    = @"kNotificationOneFileDownloadClick" ;
NSString *const kNotificationOneFileDownloadProgress = @"kNotificationOneFileDownloadProgress" ;
NSString *const kNotificationOneFileDownloadComplete = @"kNotificationOneFileDownloadComplete" ;


@interface YPSingleDownloadOperation ()
{
    BOOL m_executing ;
    BOOL m_finished ;
}
@property (strong, nonatomic) YPFiles           *afile ;
@property (strong, nonatomic) DownloadRecordTB  *rec ;
@property (copy, nonatomic)   DownloadFinishBlk finishBlk ;
@end

@implementation YPSingleDownloadOperation

- (instancetype)initWithFile:(YPFiles *)file
                         rec:(DownloadRecordTB *)rec
                      finish:(DownloadFinishBlk)blk {
    
    self = [super init];
    if (self) {
        _afile = file ;
        _rec = rec ;
        _finishBlk = blk ;
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

        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOneFileDownloadClick object:self.rec] ;
            
            @weakify(self)
            [YPFiles downloadFileWithGuid:self.afile.guid savePath:self.rec.localPath progress:^(float progressVal) {
                NSDictionary *dic = @{@"guid":self.afile.guid ,
                                      @"progress":@(progressVal)} ;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOneFileDownloadProgress object:dic] ;
            } complete:^(BOOL success) {
                
                @strongify(self)
                if (self.isCancelled) {
                    [self willChangeValueForKey:@"isFinished"] ;
                    self->m_finished = YES ;
                    [self didChangeValueForKey:@"isFinished"] ;
                    return ;
                }
                
                if (success) {
                    self.rec.isDownloaded = 1 ;
                    [self.rec updateWhereByProp:@"guid"] ;
                    self.finishBlk(YES, self.rec) ;
                }
                else {
                    NSLog(@"下载失败 %@",self.afile.name) ;
                    self.rec.isDownloaded = -1 ;
                    [self.rec updateWhereByProp:@"guid"] ;
                    self.finishBlk(NO, nil) ;
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOneFileDownloadComplete object:self.rec] ;
                
                [self willChangeValueForKey:@"isExecuting"] ;
                self->m_executing = NO ;
                [self didChangeValueForKey:@"isExecuting"] ;

                [self willChangeValueForKey:@"isFinished"] ;
                self->m_finished = YES ;
                [self didChangeValueForKey:@"isFinished"] ;
                
            }] ;
            
        }) ;
    }
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
