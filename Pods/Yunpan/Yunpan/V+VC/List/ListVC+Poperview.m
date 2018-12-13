//
//  ListVC+Poperview.m
//  Yunpan
//
//  Created by teason23 on 2018/10/18.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "ListVC+Poperview.h"
#import <FTPopOverMenu/FTPopOverMenu.h>
#import <XTlib/XTlib.h>
#import "AlbumVC.h"
#import "YPFiles.h"
#import "YPFiles+Request.h"
#import "YPFolderMananger.h"
#import "UploadRecordTB.h"
#import "UploadManager.h"
#import "UIImage+Yunpan.h"

@implementation ListVC (Poperview)

- (void)poperClickWithParentFile:(YPFiles *)parentFile {
    
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration] ;
    configuration.menuRowHeight = 48 ;
    configuration.textColor = UIColorRGB(65, 70, 75) ;
    configuration.textFont = [UIFont systemFontOfSize:14] ;
    configuration.backgroundColor = [UIColor whiteColor] ;
    configuration.borderColor = UIColorRGBA(191, 191, 191, .4) ;
    configuration.borderWidth = 0.5 ;
    configuration.textAlignment = NSTextAlignmentCenter ;
    configuration.separatorColor = UIColorRGB(229, 229, 229) ;
    configuration.shadowColor = UIColorRGBA(191, 191, 191, .4) ;
    configuration.shadowOpacity = .4 ;
    configuration.shadowOffsetX = 0 ;
    configuration.shadowOffsetY = 0 ;

    
    [FTPopOverMenu showFromSenderFrame:CGRectMake(APP_WIDTH - 53,
                                                  self.view.window.safeAreaInsets.top,
                                                  40,
                                                  40)
                         withMenuArray:@[@"新建文件夹",@"上传图片",@"上传文件"]
                            imageArray:@[
                                         [UIImage shmyp_imageNamed:@"bt_newfolder" fromBundleClass:self.class] ,
                                         [UIImage shmyp_imageNamed:@"bt_uploadImage" fromBundleClass:self.class] ,
                                         [UIImage shmyp_imageNamed:@"t_uploadFiles" fromBundleClass:self.class]
                                         ]
                         configuration:configuration
                             doneBlock:^(NSInteger selectedIndex) {
                                 
        if (selectedIndex == 0) {
            // 新建文件夹
            WEAK_SELF
            [UIAlertController xt_showTextFieldAlertWithTitle:@"新建文件夹" subtitle:nil cancel:@"取消" commit:@"确定" placeHolder:@"请输入 ..." callback:^(NSString *atext) {
                
                 [YPFiles createFolderWithName:atext
                                    parentGuid:parentFile.guid
                                      complete:^(YPFiles *aFile) {
                                          [weakSelf.table xt_loadNewInfoInBackGround:YES] ;
                                      }] ;
            }] ;
        }
        else if (selectedIndex == 1) {
            // 去相册, 上传
            [AlbumVC showAlbumFrom:self
                     parentGuid:parentFile.guid ?: @""
                     parentName:[[YPFolderMananger sharedInstance] currentFileName:parentFile]] ;
        }
        else if (selectedIndex == 2) {
            // 文件
            NSArray *documentTypes = @[@"public.content", @"public.text", @"public.source-code ", @"public.image", @"public.audiovisual-content", @"com.adobe.pdf", @"com.apple.keynote.key", @"com.microsoft.word.doc", @"com.microsoft.excel.xls", @"com.microsoft.powerpoint.ppt"];
            UIDocumentPickerViewController *vc = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeOpen] ;
            vc.delegate = (id)self;
            [self.navigationController presentViewController:vc animated:YES completion:nil] ;
        }
    } dismissBlock:nil] ;
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    BOOL fileUrlAuthozied = [url startAccessingSecurityScopedResource] ;
    if (fileUrlAuthozied) {
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init] ;
        NSError *error ;
        [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
            NSString *fileName = [newURL lastPathComponent] ;
            NSData *fileData = [[NSData alloc] initWithContentsOfURL:url] ;
            
            UploadRecordTB *rec = [[UploadRecordTB alloc] initWithData:fileData url:newURL fileName:fileName parentID:self.currentFiles.guid] ;
            [rec xt_insert] ;
            [[UploadManager sharedInstance] addOneFile:rec] ;
            
            [url stopAccessingSecurityScopedResource] ;
        }] ;
        NSLog(@"error : %@",error) ;
    }
    else {
        //  Error handling
    }
}


@end
