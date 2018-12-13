//
//  YPDownloadListVC.m
//  Yunpan
//
//  Created by teason23 on 2018/9/28.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPDownloadListVC.h"
#import "UploadCell.h"
#import "DownloadRecordTB.h"
#import "UploadStatusHeader.h"
#import <XTlib/XTlib.h>
#import "YPFolderMananger.h"
#import "YPDownloadManager.h"


@interface YPDownloadListVC () <UITableViewDelegate,UITableViewDataSource,UITableViewXTReloaderDelegate>

@end

@implementation YPDownloadListVC

#pragma mark -

- (instancetype)init {
    self = [super init] ;
    if (self) {
        @weakify(self)
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kNotificationOneFileDownloadClick object:nil] deliverOnMainThread] subscribeNext:^(NSNotification * _Nullable x) {
            @strongify(self)
            [self.table xt_loadNewInfoInBackGround:YES] ;
        }] ;
        
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kNotificationOneFileDownloadComplete object:nil] deliverOnMainThread] subscribeNext:^(NSNotification * _Nullable x) {
            @strongify(self)
            [self.table xt_loadNewInfoInBackGround:YES] ;
        }] ;
    }
    return self ;
}

- (void)refresh {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.table reloadData] ;
    }) ;
}

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    _table = [[UITableView alloc] init] ;
    [self.view addSubview:_table] ;
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view) ;
    }] ;
    

    [UploadCell xt_registerNibFromTable:_table bundleOrNil:[NSBundle bundleForClass:UploadCell.class]] ;

    [_table registerClass:[UploadStatusHeader class] forHeaderFooterViewReuseIdentifier:@"UploadStatusHeader"] ;
    _table.dataSource   = self ;
    _table.delegate     = self ;
    _table.xt_Delegate = self ;
    [_table xt_setup] ;
    _table.mj_footer = nil ;
    
    [_table xt_loadNewInfoInBackGround:YES] ;
    
    // download queue all done
    @weakify(self)
    [[[[RACObserve([YPDownloadManager sharedInstance].downloadQueue, operationCount) skip:1] filter:^BOOL(id  _Nullable value) {
        return [value intValue] == 0 ;
    }] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self)
        [self.table xt_loadNewInfoInBackGround:YES] ;
        if (!self.downloadingList.count) return ;
        
        [self.downloadingList enumerateObjectsUsingBlock:^(DownloadRecordTB *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isDownloaded = -1 ;
            [obj xt_update] ;
        }] ;
        [self.table reloadData] ;
    }] ;

}

#pragma mark - UITableView

- (void)tableView:(UITableView *)table loadNew:(void(^)(void))endRefresh {
    @synchronized (self.downloadingList) {

        NSArray *listInDownloading = [[DownloadRecordTB xt_findWhere:[NSString stringWithFormat:@"isDownloaded == 2"]] xt_orderby:@"xt_createTime" descOrAsc:YES] ;
        NSArray *listWaiting = [[DownloadRecordTB xt_findWhere:[NSString stringWithFormat:@"isDownloaded == 0"]] xt_orderby:@"xt_createTime" descOrAsc:YES] ;
        NSArray *listFailed = [[DownloadRecordTB xt_findWhere:[NSString stringWithFormat:@"isDownloaded == -1"]] xt_orderby:@"xt_createTime" descOrAsc:YES] ;
        NSMutableArray *tmplist = [@[] mutableCopy] ;
        [tmplist addObjectsFromArray:listInDownloading] ;
        [tmplist addObjectsFromArray:listWaiting] ;
        [tmplist addObjectsFromArray:listFailed] ;
        self.downloadingList = tmplist ;
    }
    self.downloadedList  = [[DownloadRecordTB xt_findWhere:[NSString stringWithFormat:@"isDownloaded == 1"]] xt_orderby:@"xt_updateTime" descOrAsc:YES] ;

//    if ([YPDownloadManager sharedInstance].downloadQueue.operationCount == 0 && self.downloadingList.count) {
//        [self.downloadingList enumerateObjectsUsingBlock:^(DownloadRecordTB *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            obj.isDownloaded = -1 ;
//            [obj update] ;
//        }] ;
//    }
    
    endRefresh() ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        @synchronized (self.downloadingList) {
            return self.downloadingList.count ;
        }
    }
    else if (section == 1) {
        return self.downloadedList.count ;
    }
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = (int)indexPath.section ;
    UploadCell *cell = [UploadCell xt_fetchFromTable:tableView] ;
    if (section == 0) {
        @synchronized (self.downloadingList) {
            [cell xt_configure:self.downloadingList[indexPath.row] indexPath:indexPath] ;
        }
    }
    else if (section == 1) {
        [cell xt_configure:self.downloadedList[indexPath.row] indexPath:indexPath] ;
    }
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UploadCell xt_cellHeight] ;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UploadStatusHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UploadStatusHeader"] ;
    if (!header) header = [[UploadStatusHeader alloc] initWithReuseIdentifier:@"UploadStatusHeader"] ;
    
    if (section == 0) {
        header.sectionTitle = STR_FORMAT(@"正在下载 (%lu)",(unsigned long)self.downloadingList.count) ;
    }
    else if (section == 1) {
        header.sectionTitle = STR_FORMAT(@"下载成功 (%lu)",(unsigned long)self.downloadedList.count)  ;
    }
    return header ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.downloadingList.count ? 36. : 0 ;
    }
    else if (section == 1) {
        return self.downloadedList.count ? 36. : 0 ;
    }
    return 36. ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = (int)indexPath.section ;
    if (section == 0) {
        // not download
        // 此任务是否正在进行中
        DownloadRecordTB *recSelected = self.downloadingList[indexPath.row] ;
        if (recSelected.isDownloaded == 2 && [YPDownloadManager sharedInstance].downloadQueue.operationCount > 0) return ;
        
        // 是否有在进行中的任务,如果有只进一个. 没有全进.
        if ([YPDownloadManager sharedInstance].downloadQueue.operationCount > 0) {
            [[YPDownloadManager sharedInstance] addFileList:@[recSelected.aFile]] ;
        }
        else {
            for (DownloadRecordTB *rec in self.downloadingList) {
                [[YPDownloadManager sharedInstance] addFileList:@[rec.aFile]] ;
            }
        }
    }
    else if (section == 1) {
        // has download
        DownloadRecordTB *aRec = self.downloadedList[indexPath.row] ;
        
        NSMutableArray *tmplist = [@[] mutableCopy] ;
        [self.downloadedList enumerateObjectsUsingBlock:^(DownloadRecordTB *  _Nonnull rec, NSUInteger idx, BOOL * _Nonnull stop) {
            [tmplist addObject:rec.aFile] ;
        }] ;
        [self.delegate clickFile:aRec.aFile fileList:tmplist] ;
    }
    NSLog(@"点击") ;
}

@end
