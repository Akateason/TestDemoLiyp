//
//  YPQuicklookVC.h
//  Yunpan
//
//  Created by teason23 on 2018/11/2.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quicklook/Quicklook.h>
@class DownloadRecordTB ;

NS_ASSUME_NONNULL_BEGIN

@interface YPQuicklookVC : QLPreviewController <QLPreviewControllerDataSource,QLPreviewControllerDelegate>
@property (strong, nonatomic) DownloadRecordTB *rec ;
- (instancetype)initWithRec:(DownloadRecordTB *)rec ;
@end

NS_ASSUME_NONNULL_END
