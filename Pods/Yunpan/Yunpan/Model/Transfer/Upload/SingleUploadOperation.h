//
//  SingleUploadOperation.h
//  Yunpan
//
//  Created by teason23 on 2018/9/18.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const kNotificationUPloadProgressChanged ;

@class UploadRecordTB,PHAsset ;

typedef void(^uploadCompleted)(UploadRecordTB *rec) ;

@interface SingleUploadOperation : NSOperation
@property (strong, nonatomic, readonly)   UploadRecordTB  *uploadRec ;

- (instancetype)initWithUploadrecord:(UploadRecordTB *)rec
                          parentGuid:(NSString *)parentGuid
                            fileName:(NSString *)fileName
                             mimType:(NSString *)mimType
                      uploadComplete:(uploadCompleted)uploadCompletion ;

+ (NSString *)fileNameWithAsset:(PHAsset *)asset PHImageFileUTIKey:(NSString *)PHImageFileUTIKey ;
+ (NSString *)mmtypeWithPHImageFileUTIKey:(NSString *)PHImageFileUTIKey ;

    
@end
