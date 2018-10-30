//
//  YPUploadListVC.m
//  Yunpan
//
//  Created by teason23 on 2018/9/28.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPUploadListVC.h"
#import <XTlib.h>
#import "UploadCell.h"
#import <Photos/Photos.h>
#import "YPFiles+Request.h"
#import "UploadRecordTB.h"
#import "SingleUploadOperation.h"
#import "UploadStatusHeader.h"
#import "UploadManager.h"

@interface YPUploadListVC () <UITableViewDelegate,UITableViewDataSource,UITableViewXTReloaderDelegate>

@property (copy, nonatomic) NSArray *uploadingList ;
@property (copy, nonatomic) NSArray *uploadedList ;

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
    
    [UploadCell registerNibFromTable:_table] ;
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
        self.uploadingList = [[UploadRecordTB selectWhere:@"isUploaded != 1"] xt_orderby:@"createTime" descOrAsc:YES] ;
        if (!self.uploadingList.count) return ;
        
        [self.uploadingList enumerateObjectsUsingBlock:^(UploadRecordTB *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isUploaded = -1 ;
            [obj update] ;
        }] ;
        [self.table reloadData] ;
        
    }] ;
    
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)table loadNew:(void(^)(void))endRefresh {
    @synchronized (self.uploadingList) {
        self.uploadingList = [[UploadRecordTB selectWhere:@"isUploaded != 1"] xt_orderby:@"createTime" descOrAsc:YES] ;
    }    
    self.uploadedList = [[UploadRecordTB selectWhere:@"isUploaded == 1"] xt_orderby:@"createTime" descOrAsc:YES] ;
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
    UploadCell *cell = [UploadCell fetchFromTable:tableView] ;
    if (section == 0) {
        [cell configure:self.uploadingList[indexPath.row] indexPath:indexPath] ;
    }
    else if (section == 1) {
        [cell configure:self.uploadedList[indexPath.row] indexPath:indexPath] ;
    }
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UploadCell cellHeight] ;
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
        UploadRecordTB *recSelected = self.uploadingList[indexPath.row] ;
        [[UploadManager sharedInstance] addAssetList:@[recSelected.asset] parentID:recSelected.parentGuid] ; //
    }
    else if ( !(section - 1) ) {
        // uploaded
    }
}

@end
