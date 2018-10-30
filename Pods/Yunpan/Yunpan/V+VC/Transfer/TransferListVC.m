//
//  TransferListVC.m
//  Yunpan
//
//  Created by teason23 on 2018/9/14.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "TransferListVC.h"
#import <XTlib.h>
#import <XTlib/XTSegment.h>
#import "UploadList/YPUploadListVC.h"
#import "DownloadList/YPDownloadListVC.h"
#import "TransVCTitleView.h"
#import "YPFolderMananger.h"


@interface TransferListVC () <XTSegmentDelegate,YPDownloadListVCDelegate>
@property (strong, nonatomic) TransVCTitleView *segment ;

@property (strong, nonatomic) YPUploadListVC *uploadVC ;
@property (strong, nonatomic) YPDownloadListVC *downloadVC ;
@end

@implementation TransferListVC

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self downloadVC] ;
        [self uploadVC] ;
    }
    return self;
}

#pragma mark - props

- (TransVCTitleView *)segment {
    if (!_segment) {        
        _segment = [TransVCTitleView newOne] ;        
        _segment.delegate = self ;
    }
    return _segment ;
}

- (YPUploadListVC *)uploadVC {
    if (!_uploadVC) {
        _uploadVC = [YPUploadListVC new] ;
    }
    return _uploadVC ;
}

- (YPDownloadListVC *)downloadVC {
    if (!_downloadVC) {
        _downloadVC = [YPDownloadListVC new] ;
        _downloadVC.delegate = self ;
    }
    return _downloadVC ;
}

#pragma mark - XTSegmentDelegate

- (void)clickSegmentWith:(int)index {
    self.uploadVC.view.hidden = index == 0 ;
    self.downloadVC.view.hidden = index != 0 ;
    if (index) {
        [self.uploadVC refresh] ;
    }
    else {
        [self.downloadVC refresh] ;
    }
}

#pragma mark -

- (void)prepareUI {
    [super prepareUI] ;
    
    self.navigationItem.titleView = self.segment ;
    
    [self.view addSubview:self.uploadVC.view] ;
    [self.uploadVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view) ;
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom) ;
    }] ;
    [self.view addSubview:self.downloadVC.view] ;
    [self.downloadVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view) ;
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom) ;
    }] ;
    [self clickSegmentWith:0] ;
    
    [self.uploadVC refresh] ;
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - YPDownloadListVCDelegate <NSObject>

- (void)clickFile:(YPFiles *)aFile fileList:(NSArray *)list {
    [[YPFolderMananger sharedInstance] clickFile:aFile fromCtrller:self wholeList:list clickFromType:YPFileClickFrom_Download] ;
}

@end
