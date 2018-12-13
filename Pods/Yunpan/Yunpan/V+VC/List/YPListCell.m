//
//  YPListCell.m
//  Yunpan
//
//  Created by teason23 on 2018/9/11.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPListCell.h"
#import "YPFiles.h"
#import <YYWebImage/YYWebImage.h>
#import <XTlib/XTlib.h>
#import "YPFolderMananger.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "YPListSortView.h"
#import "SHMDriveSDK.h"
#import "YPFiles+Request.h"
#import "SVGImageLoader.h"

@interface YPListCell () <UIWebViewDelegate>
@property (strong, nonatomic) SVGImageLoader *svgImageView ;
@end

@implementation YPListCell

- (IBAction)btChooseOnClick:(UIButton *)btSender {
    btSender.selected = !btSender.selected ;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(btChooseOnclick:indexPath:)]) {
        [self.delegate btChooseOnclick:btSender.selected indexPath:self.indexPath] ;
    }
}

- (void)prepareUI {
    [super prepareUI] ;
    
    _btChoose.selected = NO ;
}

- (void)configure:(id)model indexPath:(NSIndexPath *)indexPath {
    [super configure:model indexPath:indexPath] ;
    
    YPFiles *aFile = model ;
    
    _btChoose.selected = aFile.isOnSelect ;
    
    _lbTitle.text = aFile.name ;
    NSString *dateStr = [YPListSortManager sharedInstance].sortType == YPListSortType_createTime ? aFile.createdAt : aFile.updatedAt ;
    
    BOOL isSvg = [aFile.subtype isEqualToString:@"svg"] ;
    self.svgImageView.hidden = !isSvg ;
    if (isSvg) {
        [self.svgImageView startLoadWithUrlStr:aFile.displayThumbNailStr header:kMutableYPHeader] ;
    }
    else {
        [self.imgContent yy_setImageWithURL:[NSURL URLWithString:aFile.displayThumbNailStr] placeholder:nil] ;
    }
    
    NSString *coopStr = aFile.memberCount > 1 ? STR_FORMAT(@"%ld人协作",(long)aFile.memberCount) : nil ;
    NSString *strTime = [[NSDate xt_getDateWithStr:dateStr format:kTIME_STR_FORMAT_ISO8601] xt_timeInfo] ;
    NSString *sizeStr = aFile.size ? [[YPFolderMananger sharedInstance] transformFileSize:@(aFile.size)] : nil ;
    
    NSString *descStr = @"" ;
    if (coopStr) {
        descStr = STR_FORMAT(@"%@  ",coopStr) ;
    }
    descStr = [descStr stringByAppendingString:strTime] ;
    if (sizeStr) {
        descStr = STR_FORMAT(@"%@  %@",descStr,sizeStr) ;
    }
    
    _lbSubtitle.text = descStr ;
}

+ (CGFloat)cellHeight {
    return 70. ;
}

- (SVGImageLoader *)svgImageView {
    if (!_svgImageView) {
        _svgImageView = [SVGImageLoader setupWithFrame:_imgContent.bounds] ;
        [self addSubview:_svgImageView] ;
        [_svgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.imgContent) ;
        }] ;
    }
    return _svgImageView ;
}

@end
