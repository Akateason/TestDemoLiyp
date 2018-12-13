//
//  DownloadRecordTB.h
//  Yunpan
//
//  Created by teason23 on 2018/9/28.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPFiles.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadRecordTB : NSObject

@property (strong, nonatomic)   YPFiles     *aFile ;
@property (copy, nonatomic)     NSString    *localPath ; // ignore db
@property (copy, nonatomic)     NSString    *strShmUserID ;
@property (nonatomic)           NSInteger   isDownloaded ; // 是否已经下载 -1失败,0未下载(等待中),1下载完成,2下载中
@property (copy, nonatomic)     NSString    *guid ; // pk 

- (instancetype)initWithFile:(YPFiles *)file                        
                      userID:(NSString *)userid ;
    
    
@end

NS_ASSUME_NONNULL_END
