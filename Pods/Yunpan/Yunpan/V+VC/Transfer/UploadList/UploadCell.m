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
#import <XTlib.h>
#import <ReactiveObjC.h>
#import <UIImageView+WebCache.h>
#import "YPFolderMananger.h"
#import "SingleUploadOperation.h"
#import "YPDownloadManager.h"


@implementation UploadCell

- (DALabeledCircularProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[DALabeledCircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 18.0f, 18.0f)];
        _progressView.xt_completeRound = YES ;
        _progressView.roundedCorners = YES;
        _progressView.trackTintColor = UIColorRGB(216, 235, 255) ;
        _progressView.progressTintColor = UIColorRGB(109, 160, 227) ;
        _progressView.progressLabel.font = [UIFont systemFontOfSize:6] ;
        _progressView.progressLabel.text = @"0%" ;
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

- (void)prepareUI {
    [super prepareUI] ;
    
    _lbStatus.text = kStringStatusWaiting ;
    
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kNotificationUPloadProgressChanged object:nil] deliverOnMainThread] subscribeNext:^(NSNotification * _Nullable x) {
        
        @strongify(self)
        if (![self.model isKindOfClass:[UploadRecordTB class]]) return ;
        UploadRecordTB *myRec = self.model ;
        
        NSDictionary *dic = x.object ;
        double progress = [dic[@"progressVal"] doubleValue] ;
        NSString *keySend = dic[@"key"] ;
        if (![myRec.uniqueLocalKey isEqualToString:keySend]) return ;
        
        if      (progress == 0) self.lbStatus.text = @"上传中" ;
        else if (progress >= 1) self.lbStatus.text = @"已上传" ;
        else                    self.lbStatus.text = @"上传中" ;
        
        [self.progressView setProgress:progress animated:(progress > 0.1)] ;
        self.progressView.progressLabel.text = STR_FORMAT(@"%.0f%%",progress * 100) ;
        [self.progressView setNeedsLayout] ;
        [self.progressView layoutIfNeeded] ;
    }] ;
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kNotificationOneFileDownloadProgress object:nil] deliverOnMainThread] subscribeNext:^(NSNotification * _Nullable x) {
        
        @strongify(self)
        if (![self.model isKindOfClass:[DownloadRecordTB class]]) return ;
        DownloadRecordTB *rec = self.model ;
        
        NSDictionary *dic = x.object ;
        float progress = [dic[@"progress"] floatValue] ;
        NSString *guid = dic[@"guid"] ;
        if (![rec.guid isEqualToString:guid]) return ;
        
        if      (progress == 0) self.lbStatus.text = @"下载中" ;
        else if (progress >= 1) self.lbStatus.text = @"已下载" ;
        else                    self.lbStatus.text = @"下载中" ;
        
        [self.progressView setProgress:progress animated:(progress > 0.1)] ;
        self.progressView.progressLabel.text = STR_FORMAT(@"%.0f%%",progress * 100) ;
        [self.progressView setNeedsLayout] ;
        [self.progressView layoutIfNeeded] ;
    }] ;
}

- (void)configure:(id)model indexPath:(NSIndexPath *)indexPath {
    [super configure:model indexPath:indexPath] ;
    
    if ([model isKindOfClass:[UploadRecordTB class]]) { // 上传
        
        UploadRecordTB *rec = model ;
        _lbName.text = rec.fileName ;
        WEAK_SELF
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init] ;
        [[PHImageManager defaultManager] requestImageForAsset:rec.asset targetSize:GET_IMAGE_SIZE_SCALE2x(_imgHead.frame.size) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
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
        _lbStatus.textColor = rec.isUploaded == -1 ? [UIColor redColor] : [UIColor lightGrayColor] ;
        
        if (rec.isUploaded == 1) _lbStatus.text = STR_FORMAT(@"%@  %@",[NSDate xt_getStrWithTick:rec.createTime format:kTIME_STR_FORMAT_YYYY_MM_dd_HH_mm], [[YPFolderMananger sharedInstance] transformFileSize:@(rec.fileSize)]) ;
    }
    else { // 下载
        
        DownloadRecordTB *rec = model ;
        _lbName.text = rec.aFile.name ;
        NSString *str = @"" ;
        switch (rec.isDownloaded) {
            case -1 : str = @"下载失败" ; break;
            case 0 : str = kStringStatusWaiting ; break;
            default: break;
        }
        _lbStatus.text = str ;
        _lbStatus.textColor = rec.isDownloaded == -1 ? [UIColor redColor] : [UIColor lightGrayColor] ;
        
        _progresContainer.hidden = rec.isDownloaded != 0 ;
        [_imgHead sd_setImageWithURL:[NSURL URLWithString:rec.aFile.displayThumbNailStr]] ;

        if (rec.isDownloaded == 1) _lbStatus.text = STR_FORMAT(@"%@  %@",[NSDate xt_getStrWithTick:rec.createTime format:kTIME_STR_FORMAT_YYYY_MM_dd_HH_mm],[[YPFolderMananger sharedInstance] transformFileSize:@(rec.aFile.size)]) ;
    }
}

+ (CGFloat)cellHeight {
    return 70. ;
}

@end
