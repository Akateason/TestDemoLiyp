//
//  YPFolderMananger.h
//  Yunpan
//
//  Created by teason23 on 2018/9/12.
//  Copyright © 2018年 teason23. All rights reserved.
// 操作文件工具类

#import <Foundation/Foundation.h>
#import <XTlib.h>
#import "YPFiles.h"
#import "DownloadRecordTB.h"

typedef enum : NSUInteger {
    YPFileClickFrom_List,
    YPFileClickFrom_Download,
    YPFileClickFrom_Upload,
} YPFileClickFrom_Type ;


@interface YPFolderMananger : NSObject
XT_SINGLETON_H(YPFolderMananger)

// 当前文件or文件夹
- (NSString *)currentFileName:(YPFiles *)afile ;
- (BOOL)isRootFolder:(YPFiles *)afile ; // 是否在最顶部(我的云盘)

/**
 展示文件大小
 */
- (NSString *)transformFileSize:(NSNumber *)value ;

/**
 获取filelist中的图片列表 . 和当前idx
 */
- (void)takeImageListFromWholeList:(NSArray <YPFiles *>*)wholeList
                      currentImage:(YPFiles *)currentFile
                        takeFinish:(void(^)(NSArray <YPFiles *>* list, NSInteger idx))takeFinish ;

/**
 点击文件后
 点击了文件,判断是否可以预览(图片,三件套), 可以预览并且未下载就去下载. 下载了直接读取
 */
- (void)clickFile:(YPFiles *)aFile
      fromCtrller:(UIViewController *)fromCtrller
        wholeList:(NSArray *)wholeList
    clickFromType:(YPFileClickFrom_Type)type ;

/**
 从云删除
 */
- (void)deleteFileOnServerWithGuids:(NSArray *)guids
                           complete:(void(^)(bool success))complete ;

/**
 本地删除(已下载中)
 */
- (void)deleteFileFromLocal:(NSArray<YPFiles *> *)list
                   complete:(void(^)(bool success))complete ;

@end

