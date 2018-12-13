//
//  NoneEditorVC.m
//  Yunpan
//
//  Created by teason23 on 2018/10/15.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "NoneEditorVC.h"
#import <XTlib/XTlib.h>
#import "YPFiles.h"
#import "YPDownloadManager.h"
#import "YPFolderMananger.h"

@interface NoneEditorVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imgFile;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle1;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle2;
@property (weak, nonatomic) IBOutlet UIButton *btDownload;

@end

@implementation NoneEditorVC

+ (instancetype)showNoneEditorFromCtrller:(UIViewController *)fromCtrller file:(YPFiles *)file {
    NoneEditorVC *vc = [NoneEditorVC getCtrllerFromStory:@"Editors" bundle:[NSBundle bundleForClass:self.class] controllerIdentifier:@"NoneEditorVC"] ;
    vc.afile = file ;
    [fromCtrller.navigationController pushViewController:vc animated:YES] ;
    return vc ;
}

- (IBAction)downloadAction:(id)sender {
    WEAK_SELF
    
    [[YPDownloadManager sharedInstance] addOneFile:self.afile complete:^(BOOL success, DownloadRecordTB * _Nonnull rec) {
        if (success) {
            weakSelf.btDownload.hidden = YES ;
        }
    }] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _lbTitle1.text = STR_FORMAT(@"无法预览.%@文件",self.afile.subtype) ;
    _lbTitle2.text = STR_FORMAT(@"%@ | %@",self.afile.name,[[YPFolderMananger sharedInstance] transformFileSize:@(self.afile.size)]) ;
    _btDownload.hidden = [[YPDownloadManager sharedInstance] fileHasDownloaded:self.afile] ;
}

@end
