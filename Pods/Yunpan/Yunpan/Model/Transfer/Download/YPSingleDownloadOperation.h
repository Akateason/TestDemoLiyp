//
//  YPSingleDownloadOperation.h
//  Yunpan
//
//  Created by teason23 on 2018/10/17.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XTlib/XTlib.h>
@class YPFiles,DownloadRecordTB ;

extern NSString *const kNotificationOneFileDownloadClick ;
extern NSString *const kNotificationOneFileDownloadProgress ;
extern NSString *const kNotificationOneFileDownloadComplete ;

typedef void(^DownloadFinishBlk)(BOOL success, DownloadRecordTB *rec) ;

@interface YPSingleDownloadOperation : NSOperation
@property (strong, nonatomic, readonly) YPFiles           *afile ;
- (instancetype)initWithFile:(YPFiles *)file
                         rec:(DownloadRecordTB *)rec
                      finish:(DownloadFinishBlk)blk ;

@end


