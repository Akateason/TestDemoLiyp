//
//  YPUploadListVC.m
//  Yunpan
//
//  Created by teason23 on 2018/9/28.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPUploadListVC.h"
#import <XTlib/XTlib.h>
#import "UploadCell.h"
#import <Photos/Photos.h>
#import "YPFiles+Request.h"
#import "UploadRecordTB.h"
#import "SingleUploadOperation.h"
#import "UploadStatusHeader.h"
#import "UploadManager.h"

@interface YPUploadListVC () <UITableViewDelegate,UITableViewDataSource,UITableViewXTReloaderDelegate>



@end

@implementation YPUploadListVC


#pragma mark -

- (instancetype)init {
    self = [super init] ;
    if (self) {
        @weakify(self)
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kNOTIFICATION_UPLOAD_CHANGED object:nil] subscribeNext:^(NSNotification * _Nullable noti) {
            @strongify(self)
            [self.table xt_loadNewInfoInBackGround:YES] ;
        }] ;
    }
    return self;
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
    _table.dataSource = self ;
    _table.delegate = self ;
    _table.xt_Delegate = self ;
    [_table xt_setup] ;
    _table.mj_footer = nil ;
    
    [_table xt_loadNewInfoInBackGround:YES] ;
    
    // upload queue all done
    @weakify(self)
    [[[RACObserve([UploadManager sharedInstance].uploadQueue, operationCount) skip:1] filter:^BOOL(id  _Nullable value) {
        return [value intValue] == 0 ;
    }] subscribeNext:^(id  _Nullable x) {
     
        @strongify(self)
        self.uploadingList = [[UploadRecordTB xt_findWhere:@"isUploaded != 1"] xt_orderby:@"xt_createTime" descOrAsc:YES] ;
        if (!self.uploadingList.count) return ;
        
        [self.uploadingList enumerateObjectsUsingBlock:^(UploadRecordTB *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isUploaded = -1 ;
            [obj xt_update] ;
        }] ;
        [self.table reloadData] ;
        
    }] ;
    
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)table loadNew:(void(^)(void))endRefresh {
    @synchronized (self.uploadingList) {
        self.uploadingList = [[UploadRecordTB xt_findWhere:@"isUploaded != 1"] xt_orderby:@"xt_createTime" descOrAsc:YES] ;
    }    
    self.uploadedList = [[UploadRecordTB xt_findWhere:@"isUploaded == 1"] xt_orderby:@"xt_updateTime" descOrAsc:YES] ;
    endRefresh() ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.uploadingList.count ;
    }
    else if (section == 1) {
        return self.uploadedList.count ;
    }
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = (int)indexPath.section ;
    UploadCell *cell = [UploadCell xt_fetchFromTable:tableView] ;
    if (section == 0) {
        [cell xt_configure:self.uploadingList[indexPath.row] indexPath:indexPath] ;
    }
    else if (section == 1) {
        [cell xt_configure:self.uploadedList[indexPath.row] indexPath:indexPath] ;
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
        header.sectionTitle = STR_FORMAT(@"未上传 (%lu)",(unsigned long)self.uploadingList.count) ;
    }
    else if (section == 1) {
        header.sectionTitle = STR_FORMAT(@"上传成功 (%lu)", (unsigned long)self.uploadedList.count) ;
    }
    return header ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.uploadingList.count ? 36. : 0 ;
    }
    else if (section == 1) {
        return self.uploadedList.count ? 36. : 0 ;
    }
    return 36. ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = (int)indexPath.section ;
    if (!section) {
        // not upload
        // 此任务是否正在进行中 ... todo
        UploadRecordTB *rec = self.uploadingList[indexPath.row] ;
        if (rec.isUploaded == 2) return ;                    
        
        // 是否有在进行中的任务,如果有只进一个. 没有全进.
        if ([UploadManager sharedInstance].uploadQueue.operationCount > 0) {
            [self addSingleAssetRec:rec] ;
        }
        else {
            for (UploadRecordTB *rec in self.uploadingList) {
                [self addSingleAssetRec:rec] ;
            }
        }
    }
    else if ( !(section - 1) ) {
        // uploaded
        UploadRecordTB *aRec = self.uploadedList[indexPath.row] ;
        
        NSMutableArray *tmplist = [@[] mutableCopy] ;
        [self.uploadedList enumerateObjectsUsingBlock:^(UploadRecordTB *  _Nonnull rec, NSUInteger idx, BOOL * _Nonnull stop) {
            if (rec.serverFiles) [tmplist addObject:rec.serverFiles] ;
        }] ;
        [self.delegate clickFile:aRec.serverFiles fileList:tmplist] ;
    }
}

- (void)addSingleAssetRec:(UploadRecordTB *)rec {
    if (rec.asset != nil) {
        [[UploadManager sharedInstance] addAssetList:@[rec.asset] parentID:rec.parentGuid] ; // from album
    }
    else {
        [[UploadManager sharedInstance] addOneFile:rec] ; // from file
    }
}

@end
