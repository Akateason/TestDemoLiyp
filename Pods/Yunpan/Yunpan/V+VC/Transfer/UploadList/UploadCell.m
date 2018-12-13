//
//  UploadCell.m
//  Yunpan
//
//  Created by teason23 on 2018/9/17.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "UploadCell.h"
#import "UploadRecordTB.h"
#import "DownloadRecordTB.h"
#import <Photos/Photos.h>
#import <XTlib/XTlib.h>
#import <ReactiveObjC/ReactiveObjC.h>
//#import <SDWebImage/UIImageView+WebCache.h>
#import <YYWebImage/YYWebImage.h>
#import "YPFolderMananger.h"
#import "SingleUploadOperation.h"
#import "YPDownloadManager.h"
#import "YPDownloadListVC.h"
#import "YPUploadListVC.h"
#import "UploadManager.h"
#import "UIImage+Yunpan.h"


@implementation UploadCell

- (DALabeledCircularProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[DALabeledCircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 18.0f, 18.0f)];
        _progressView.xt_completeRound = YES ;
        _progressView.roundedCorners = NO ;
        _progressView.trackTintColor = UIColorRGB(216, 235, 255) ;
        _progressView.progressTintColor = UIColorRGB(109, 160, 227) ;
        _progressView.progressLabel.font = [UIFont systemFontOfSize:7] ;
        _progressView.progressLabel.text = @"0" ;
        _progressView.progressLabel.textColor = UIColorRGB(109, 160, 227) ;
        _progressView.progressLabel.xt_completeRound = YES ;
        _progressView.progress = 0 ;
        _progressView.backgroundColor = UIColorRGB(216, 235, 255) ;
        
        if (!_progressView.superview) {
            [self.progresContainer addSubview:_progressView] ;
            [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.progresContainer) ;
                make.size.mas_equalTo(CGSizeMake(18, 18)) ;
            }] ;
        }
    }
    return _progressView ;
}

static NSString *kStringStatusWaiting = @"正在等待..." ;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    WEAK_SELF
    // 左滑删除.
    MGSwipeButton *swipeBt = [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"t_cell_right_delete"] backgroundColor:UIColorHex(@"e95555") callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        
        if ([weakSelf.xt_model isKindOfClass:[UploadRecordTB class]]) { // 上传
            UploadRecordTB *rec = weakSelf.xt_model ;
            YPUploadListVC *vc = (YPUploadListVC *)weakSelf.xt_viewController ;
            if (weakSelf.xt_indexPath.section == 0) {
                // not yet
                [[UploadManager sharedInstance] cancelOneOperationWitnFileGuid:rec.serverFiles.guid] ;
                
                NSMutableArray *tmplist = [vc.uploadingList mutableCopy] ;
                [tmplist removeObjectAtIndex:weakSelf.xt_indexPath.row] ;
                vc.uploadingList = tmplist ;
            }
            else {
                // done
                NSMutableArray *tmplist = [vc.uploadedList mutableCopy] ;
                [tmplist removeObjectAtIndex:weakSelf.xt_indexPath.row] ;
                vc.uploadedList = tmplist ;
            }
            [vc.table deleteRowsAtIndexPaths:@[weakSelf.xt_indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [vc.table reloadData] ; // refresh your indexpath .
            [rec xt_deleteModel] ;
        }
        else { //下载
            DownloadRecordTB *rec = weakSelf.xt_model ;
            YPDownloadListVC *vc = (YPDownloadListVC *)weakSelf.xt_viewController ;
            if (weakSelf.xt_indexPath.section == 0 ) {
                // not yet
                [[YPDownloadManager sharedInstance] cancelOneOperationWitnFileGuid:rec.aFile.guid] ;
                
                NSMutableArray *tmplist = [vc.downloadingList mutableCopy] ;
                [tmplist removeObjectAtIndex:weakSelf.xt_indexPath.row] ;
                vc.downloadingList = tmplist ;
            }
            else {
                // done
                NSMutableArray *tmplist = [vc.downloadedList mutableCopy] ;
                [tmplist removeObjectAtIndex:weakSelf.xt_indexPath.row] ;
                vc.downloadedList = tmplist ;
            }
            [vc.table deleteRowsAtIndexPaths:@[weakSelf.xt_indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [vc.table reloadData] ; // refresh your indexpath .
            [rec xt_deleteModel] ;
        }
        
        return YES ;
    }] ;
    swipeBt.width = 70 ;
    self.rightButtons = @[swipeBt] ;
    
    _lbStatus.text = kStringStatusWaiting ;
    
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kNotificationUPloadProgressChanged object:nil] deliverOnMainThread] subscribeNext:^(NSNotification * _Nullable x) {
        
        @strongify(self)
        if (![self.xt_model isKindOfClass:[UploadRecordTB class]]) return ;
        UploadRecordTB *myRec = self.xt_model ;
        
        NSDictionary *dic = x.object ;
        double progress = [dic[@"progressVal"] doubleValue] ;
        NSString *keySend = dic[@"key"] ;
        if (![myRec.uniqueLocalKey isEqualToString:keySend]) return ;
        
        if      (progress == 0) self.lbStatus.text = @"上传中" ;
        else if (progress >= 1) self.lbStatus.text = @"已上传" ;
        else                    self.lbStatus.text = @"上传中" ;
        
        self.progresContainer.hidden = myRec.isUploaded != 0 ;
        [self.progressView setProgress:progress animated:NO] ;
        
        self.progressView.progressLabel.text = STR_FORMAT(@"%.0f",progress * 100) ;
        [self.progressView setNeedsLayout] ;
        [self.progressView layoutIfNeeded] ;
    }] ;
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kNotificationOneFileDownloadProgress object:nil] deliverOnMainThread] subscribeNext:^(NSNotification * _Nullable x) {
        
        @strongify(self)
        if (![self.xt_model isKindOfClass:[DownloadRecordTB class]]) return ;
        DownloadRecordTB *rec = self.xt_model ;
        
        NSDictionary *dic = x.object ;
        float progress = [dic[@"progress"] floatValue] ;
        NSString *guid = dic[@"guid"] ;
        if (![rec.guid isEqualToString:guid]) return ;
        
        if      (progress == 0) self.lbStatus.text = @"下载中" ;
        else if (progress >= 1) self.lbStatus.text = @"已下载" ;
        else                    self.lbStatus.text = @"下载中" ;
        
        self.progresContainer.hidden = rec.isDownloaded != 2 ;
        [self.progressView setProgress:progress animated:NO] ;
        
        self.progressView.progressLabel.text = STR_FORMAT(@"%.0f",progress * 100) ;
        [self.progressView setNeedsLayout] ;
        [self.progressView layoutIfNeeded] ;
    }] ;

}

- (void)xt_configure:(id)model indexPath:(NSIndexPath *)indexPath {
    [super xt_configure:model indexPath:indexPath] ;
    
    if ([model isKindOfClass:[UploadRecordTB class]]) { // 上传
        
        UploadRecordTB *rec = model ;
        _lbName.text = rec.fileName ;
        WEAK_SELF
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init] ;
        [[PHImageManager defaultManager] requestImageForAsset:rec.asset targetSize:GET_IMAGE_SIZE_SCALE2x(_imgHead.frame.size) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            if (result) {
                weakSelf.imgHead.image = result ;
            }
            
        }] ;
        
        _progresContainer.hidden = rec.isUploaded != 0 ;
        
        NSString *str = @"" ;
        switch (rec.isUploaded) {
            case -1 : str = @"上传失败" ; break;
            case 0 : str = kStringStatusWaiting ; break;
            default: break;
        }
        
        _lbStatus.text = str ;
        _imgStatus.image = [UIImage shmyp_imageNamed:@"transfer_downloadAlert" fromBundleClass:self.class] ;
        _imgStatus.hidden = rec.isUploaded != -1 ;
        
        if (rec.isUploaded == 1) _lbStatus.text = STR_FORMAT(@"%@  %@",[NSDate xt_getStrWithTick:rec.xt_createTime format:kTIME_STR_FORMAT_YYYY_MM_dd_HH_mm], [[YPFolderMananger sharedInstance] transformFileSize:@(rec.fileSize)]) ;
    }
    else { // 下载
        
        DownloadRecordTB *rec = model ;
        _lbName.text = rec.aFile.name ;
        _progresContainer.hidden = rec.isDownloaded != 2 ;

        NSString *str = @"" ;
        switch (rec.isDownloaded) {
            case -1 : str = @"下载失败" ; break;
            case 0 : str = kStringStatusWaiting ; break;
            default: break;
        }
        _lbStatus.text = str ;
        _imgStatus.image = [UIImage shmyp_imageNamed:@"transfer_downloadAlert" fromBundleClass:self.class] ;
        _imgStatus.hidden = rec.isDownloaded != -1 ;
        [_imgHead yy_setImageWithURL:[NSURL URLWithString:rec.aFile.displayThumbNailStr] placeholder:nil] ;
        
        if (rec.isDownloaded == 1) _lbStatus.text = STR_FORMAT(@"%@  %@",[NSDate xt_getStrWithTick:rec.xt_createTime format:kTIME_STR_FORMAT_YYYY_MM_dd_HH_mm],[[YPFolderMananger sharedInstance] transformFileSize:@(rec.aFile.size)]) ;
    }
}

+ (CGFloat)xt_cellHeight {
    return 70. ;
}

@end
