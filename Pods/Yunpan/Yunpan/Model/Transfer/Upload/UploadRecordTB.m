//
//  UploadRecordTB.m
//  Yunpan
//
//  Created by teason23 on 2018/9/18.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "UploadRecordTB.h"
#import <XTlib/XTlib.h>
#import "SHMDriveSDK.h"

@implementation UploadRecordTB

- (instancetype)initWithData:(NSData *)data
                         url:(NSURL *)newUrl                        
                    fileName:(NSString *)name
                    parentID:(NSString *)parentID {
    
    self = [super init];
    if (self) {
        _shm_userId = @([SHMDriveSDK sharedInstance].delegate.userID).stringValue ;
        NSCAssert((_shm_userId && _shm_userId.length), @"SHMYunpanSDK Error. userID is null !!!") ;
        
        _uniqueLocalKey = newUrl.absoluteString ;
        _asset = nil ;
        _fileName = name ;
        _parentGuid = parentID ;
        _fileSize = data.length ;
        _aData = data ;
        _pathInLocal = XT_DOCUMENTS_PATH_TRAIL_(STR_FORMAT(@"uploadFiles/%@",_fileName)) ;
        
        NSError *error ;
        BOOL success = [_aData writeToFile:_pathInLocal options:NSDataWritingAtomic error:&error] ;
        NSLog(@"error : %@",error) ;
        if (success) {
            _mimeType = [YPFiles mimeTypeForFileAtPath:_pathInLocal] ;
        }
    }
    return self;
}

- (instancetype)initWithAsset:(PHAsset *)asset
                     parentID:(NSString *)parentID {
    
    self = [super init];
    if (self) {
        _shm_userId = @([SHMDriveSDK sharedInstance].delegate.userID).stringValue ;
        NSCAssert((_shm_userId && _shm_userId.length), @"SHMYunpanSDK Error. userID is null !!!") ;

        _asset = asset ;
        _uniqueLocalKey = asset.localIdentifier ;
        _parentGuid = parentID ;
    }
    return self;
}

- (void)appendProperties:(NSString *)name
                    type:(NSString *)mimeType
             dataToWrite:(NSData *)data {
    
    _fileName = name ;
    _mimeType = mimeType ;
    _fileSize = data.length ;
    _aData = data ;
    
    _pathInLocal = XT_DOCUMENTS_PATH_TRAIL_(STR_FORMAT(@"uploadFiles/%@",_fileName)) ;
    [_aData writeToFile:_pathInLocal atomically:NO] ;
}

- (instancetype)initWithUniqueKey:(NSString *)uniqueKey
                            asset:(PHAsset *)asset
                         fileName:(NSString *)name
                             type:(NSString *)mimetype
                       parentGuid:(NSString *)parentGuid
                  datawritetoPath:(NSData *)data {
    
    self = [super init] ;
    if (self) {
        _shm_userId = @([SHMDriveSDK sharedInstance].delegate.userID).stringValue ;
        NSCAssert((_shm_userId && _shm_userId.length), @"SHMYunpanSDK Error. userID is null !!!") ;
        
        _uniqueLocalKey = uniqueKey ;
        _asset = asset ;
        _fileName = name ;
        _mimeType = mimetype ;
        _parentGuid = parentGuid ;
        _fileSize = data.length ;
        _aData = data ;
        
        [_aData writeToFile:_pathInLocal atomically:NO] ;
    }
    return self ;
}

- (PHAsset *)asset {
    if (!_asset) {
        _asset = [[PHAsset fetchAssetsWithLocalIdentifiers:@[self.uniqueLocalKey] options:nil] firstObject] ;
    }
    return _asset ;
}

- (NSString *)pathInLocal {
    if (!_pathInLocal) {
        _pathInLocal = XT_DOCUMENTS_PATH_TRAIL_(STR_FORMAT(@"uploadFiles/%@",self.fileName)) ;
    }
    return _pathInLocal ;
}

#pragma mark - db config

+ (NSDictionary *)modelPropertiesSqliteKeywords {
    return @{
                @"uniqueLocalKey" : @"unique"
             } ;
}

+ (NSArray *)ignoreProperties {
    return @[@"pathInLocal",@"aData",@"asset"] ;
}

@end
