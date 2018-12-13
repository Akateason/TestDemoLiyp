//
//  YPFolderMananger.m
//  Yunpan
//
//  Created by teason23 on 2018/9/12.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPFolderMananger.h"
#import "SHMDriveSDK.h"
#import <XTlib/XTlib.h>
#import "YPFiles+Request.h"
#import "UploadRecordTB.h"
#import "DownloadRecordTB.h"
#import "YPImageEditorVC.h"
#import "NoneEditorVC.h"
#import "YPDownloadManager.h"
#import "YPQuicklookVC.h"

@interface YPFolderMananger ()

@end

@implementation YPFolderMananger
XT_SINGLETON_M(YPFolderMananger)

- (NSString *)currentFileName:(YPFiles *)afile {
    if ([self isRootFolder:afile]) {
        return @"石墨云盘" ;
    }
    return afile.name ;
}

- (BOOL)isRootFolder:(YPFiles *)afile {
    return !afile ;
}

- (NSString *)getLocalPathWithFile:(YPFiles *)afile {
    return STR_FORMAT(@"%@/%@",[[SHMDriveSDK sharedInstance] defaultDownloadFolderPath],afile.name) ;
}

- (NSString *)transformFileSize:(NSNumber *)value {
    double convertedValue = [value doubleValue] ;
    int multiplyFactor = 0 ;
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB", @"ZB", @"YB",nil] ;
    while (convertedValue > 1024) {
        convertedValue /= 1024 ;
        multiplyFactor++ ;
    }
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]] ;
}

/**
    获取filelist中的图片列表 . 和当前idx
 */
- (void)takeImageListFromWholeList:(NSArray <YPFiles *>*)wholeList
                      currentImage:(YPFiles *)currentFile
                        takeFinish:(void(^)(NSArray <YPFiles *>* list, NSInteger idx))takeFinish {
    
    NSMutableArray *tmplist = [@[] mutableCopy] ;
    __block NSInteger currentImgIdx = -1 ;
    [wholeList enumerateObjectsUsingBlock:^(YPFiles * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isImageType) {
            [tmplist addObject:obj] ;
            if (obj.idFiles == currentFile.idFiles) {
                currentImgIdx = tmplist.count - 1 ;
            }
        }
    }] ;
    
    if (takeFinish) takeFinish(tmplist, currentImgIdx) ;
}


/**
 点击文件后
 点击了文件,判断是否可以预览(图片,三件套), 可以预览并且未下载就去下载. 下载了直接读取
 */
- (void)clickFile:(YPFiles *)aFile
      fromCtrller:(UIViewController *)fromCtrller
        wholeList:(NSArray *)wholeList
    clickFromType:(YPFileClickFrom_Type)type {
    
    if (aFile.isImageType) { // 图片
        [[YPFolderMananger sharedInstance] takeImageListFromWholeList:wholeList currentImage:aFile takeFinish:^(NSArray<YPFiles *> *list, NSInteger idx) {
            
            if (idx < 0) return ;
            
            YPImageEditorVC *editVC = [YPImageEditorVC showFromCtrller:fromCtrller] ;
            [editVC setupWithImgFileList:list currentImageIdx:idx fromType:type] ;
            
        }] ;
    }
    else if (aFile.isOfficeType) { // 三件套
        [SVProgressHUD show] ;
        
        [[YPDownloadManager sharedInstance] addOneFile:aFile complete:^(BOOL success, DownloadRecordTB * _Nonnull rec) {
            [SVProgressHUD dismiss] ;
            
            BOOL isSMAppDoSth = [[SHMDriveSDK sharedInstance].delegate onOpenFiletoEditor:[aFile yy_modelToJSONObject] localPath:rec.localPath fromCtrller:fromCtrller] ;
            if (!isSMAppDoSth) {                
                YPQuicklookVC *vc = [[YPQuicklookVC alloc] initWithRec:rec] ;
                [fromCtrller.navigationController pushViewController:vc animated:YES] ;
            }
            
        }] ;
        
    }
    else { // 不支持预览
        [NoneEditorVC showNoneEditorFromCtrller:fromCtrller file:aFile] ;
    }
}


/**
 从云删除
 */
- (void)deleteFileOnServerWithGuids:(NSArray *)guids
                           complete:(void(^)(bool success))complete {
    
    [UIAlertController xt_showAlertCntrollerWithAlertControllerStyle:UIAlertControllerStyleAlert title:STR_FORMAT(@"确认删除(%lu)",(unsigned long)guids.count) message:@"确认删除文件吗？删除后，所有协作者都无法访问此文件" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认删除" otherButtonTitles:nil callBackBlock:^(NSInteger btnIndex) {
        
        if (btnIndex == 1) {
            [YPFiles deleteFilesWithGuids:guids complete:^(bool bOk) {
                if (complete) {
                    [guids enumerateObjectsUsingBlock:^(NSString *  _Nonnull strGuid, NSUInteger idx, BOOL * _Nonnull stop) {
                        UploadRecordTB *rec = [UploadRecordTB xt_findFirstWhere:STR_FORMAT(@"serverGuid == '%@'",strGuid)] ;
                        [rec xt_deleteModel] ;
                    }] ;
                    
                    complete(bOk) ;
                }
            }] ;
        }
        
    }] ;
}

/**
 本地删除(已下载中)
 */
- (void)deleteFileFromLocal:(NSArray<YPFiles *> *)list
                   complete:(void(^)(bool success))complete {
    
    [UIAlertController xt_showAlertCntrollerWithAlertControllerStyle:UIAlertControllerStyleAlert title:STR_FORMAT(@"确认从已下载中删除(%ld)",list.count) message:@"确认删除文件吗" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认删除" otherButtonTitles:nil callBackBlock:^(NSInteger btnIndex) {
        
        if (btnIndex == 1) {
            
            __block int allSuccessCount = 0 ;
            [list enumerateObjectsUsingBlock:^(YPFiles * _Nonnull file, NSUInteger idx, BOOL * _Nonnull stop) {
                
                DownloadRecordTB *rec = [DownloadRecordTB xt_findFirstWhere:STR_FORMAT(@"guid == '%@'",file.guid)] ;
                NSError *error = nil ;
                BOOL isDel = [[NSFileManager defaultManager] removeItemAtPath:rec.localPath error:&error] ; //[XTFileManager deleteFile:rec.localPath] ;
                if (isDel) isDel = [rec xt_deleteModel] ;
                if (!isDel) {
                    NSLog(@"本地删除失败 %@",file.name) ;
                }
                else allSuccessCount ++ ;
            }] ;
            
            if (complete) complete(allSuccessCount == list.count) ;

        }
        
    }] ;

}

@end
