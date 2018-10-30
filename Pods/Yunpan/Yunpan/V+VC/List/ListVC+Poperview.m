//
//  ListVC+Poperview.m
//  Yunpan
//
//  Created by teason23 on 2018/10/18.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "ListVC+Poperview.h"
#import <FTPopOverMenu.h>
#import <XTlib.h>
#import "AlbumVC.h"
#import "YPFiles.h"
#import "YPFiles+Request.h"
#import "YPFolderMananger.h"

@implementation ListVC (Poperview)

- (void)poperClickWithParentFile:(YPFiles *)parentFile {
    
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuRowHeight = 48 ;
    configuration.textColor = UIColorRGB(65, 70, 75) ;
    configuration.textFont = [UIFont systemFontOfSize:14] ;
    configuration.backgroundColor = [UIColor whiteColor] ;
    configuration.borderColor = UIColorRGBA(191, 191, 191, .4) ;
    configuration.borderWidth = 0.5 ;
    configuration.textAlignment = NSTextAlignmentCenter ;
    configuration.separatorColor = UIColorRGB(229, 229, 229) ;
    
    [FTPopOverMenu showFromSenderFrame:CGRectMake(APP_WIDTH - 53, 45, 40, 40)
                         withMenuArray:@[@"新建文件夹",@"上传图片"]
                            imageArray:@[@"bt_newfolder",@"bt_uploadImage"]
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
                                 
                             } dismissBlock:^{
                                 
                             }] ;

}

@end
