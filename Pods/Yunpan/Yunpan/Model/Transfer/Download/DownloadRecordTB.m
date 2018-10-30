//
//  DownloadRecordTB.m
//  Yunpan
//
//  Created by teason23 on 2018/9/28.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "DownloadRecordTB.h"
#import "SHMDriveSDK.h"

@implementation DownloadRecordTB

- (instancetype)initWithFile:(YPFiles *)file
                      userID:(NSString *)userid {
    
    self = [super init] ;
    if (self) {
        _aFile = file ;        
        _strShmUserID = userid ;
        _guid = file.guid ;
    }
    return self ;
}

+ (NSDictionary *)modelPropertiesSqliteKeywords {
    return @{@"guid":@"UNIQUE"} ;
}

+ (NSArray *)ignoreProperties {
    return @[@"localPath"] ;
}

- (NSString *)localPath {
    if (!_localPath) {
        _localPath = STR_FORMAT(@"%@/%@",[[SHMDriveSDK sharedInstance] defaultDownloadFolderPath],self.aFile.name) ;
    }
    return _localPath ;
}

@end
