//
//  UploadRecordTB.h
//  Yunpan
//
//  Created by teason23 on 2018/9/18.
//  Copyright © 2018年 teason23. All rights reserved.
//上传记录

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@class YPFiles ;

@interface UploadRecordTB : NSObject

// db
@property (copy, nonatomic)     NSString    *uniqueLocalKey ; // PK : local key in photo asset
@property (nonatomic)           NSInteger   isUploaded ;      // 是否已经上传    -1失败,0未上传,1下载上传
@property (copy, nonatomic)     NSString    *fileName ;
@property (copy, nonatomic)     NSString    *mimeType ;
@property (copy, nonatomic)     NSString    *parentGuid ;
@property (nonatomic)           NSInteger   fileSize ;
@property (copy, nonatomic)     NSString    *shm_userId ;     // shm sdk
@property (strong, nonatomic)   YPFiles     *serverFiles ;    // exist when uploaded
@property (copy, nonatomic)     NSString    *serverGuid ;

// vm
@property (strong, nonatomic)   PHAsset     *asset ;          // ignore , localId - only photo has asset
@property (copy, nonatomic)     NSString    *pathInLocal ;    // ignore
@property (strong, nonatomic)   NSData      *aData ;          // ignore , write to file in local

// initial with photo asset .
- (instancetype)initWithAsset:(PHAsset *)asset
                     parentID:(NSString *)parentID ;

- (void)appendProperties:(NSString *)name
                    type:(NSString *)mimeType
             dataToWrite:(NSData *)data ;

// initial with any file .
- (instancetype)initWithData:(NSData *)data
                         url:(NSURL *)newUrl                        
                    fileName:(NSString *)name
                    parentID:(NSString *)parentID ;
@end
