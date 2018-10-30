//
//  YPImageEditorCell.m
//  Yunpan
//
//  Created by teason23 on 2018/10/13.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPImageEditorCell.h"
#import <XTlib.h>
#import <XTAnimation.h>
#import <XTZoomPicture.h>
#import <UIImageView+WebCache.h>
//#import <DACircularProgressView.h>
#import "YPFiles.h"


@interface YPImageEditorCell ()
@property (strong, nonatomic) XTZoomPicture *zoomPic ;
//@property (strong, nonatomic) DACircularProgressView *progressV ;
@property (strong, nonatomic) UIImageView *pgsView ;
@end

@implementation YPImageEditorCell

- (void)prepareUI {
    [super prepareUI] ;
    self.backgroundColor = [XTColorFetcher sharedInstance].randomColor ;
    self.zoomPic = ({
        XTZoomPicture *zp = [[XTZoomPicture alloc] initWithFrame:self.bounds backImage:nil max:2 min:1 flex:0 tapped:^{
            
        }] ;
        [self addSubview:zp] ;
        zp ;
    }) ;
    
//    self.progressV = ({
//        DACircularProgressView *progress = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 30.0f, 30.0f)] ;
//        progress.trackTintColor = [UIColor colorWithWhite:.93 alpha:.8] ;
//        progress.progressTintColor = [UIColor colorWithWhite:.9 alpha:.4] ;
//        [self addSubview:progress] ;
//        [progress mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self) ;
//            make.size.mas_equalTo(CGSizeMake(30, 30)) ;
//        }] ;
//        progress ;
//    }) ;

}

- (void)configure:(YPFiles *)file {
    [super configure:file] ;
    
    [self.zoomPic resetToOrigin] ;
    self.pgsView.hidden = NO ;
    
    WEAK_SELF
    [self.zoomPic.imageView sd_setImageWithURL:[NSURL URLWithString:file.downloadUrl] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        if (expectedSize > 0) {
//            [weakSelf.progressV setProgress:receivedSize / expectedSize animated:YES] ;
//        }
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        weakSelf.zoomPic.backImage = image ;
        weakSelf.pgsView.hidden = YES ;

//        weakSelf.progressV.hidden = YES ;
    }] ;
    
//    [self.zoomPic.imageView sd_setImageWithURL:[NSURL URLWithString:file.downloadUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        weakSelf.zoomPic.backImage = image ;
//        weakSelf.pgsView.hidden = YES ;
//    }] ;
}

- (UIImageView *)pgsView{
    if(!_pgsView){
        _pgsView = ({
            UIImageView *object = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pgs_icon"]] ;
            if (!object.superview) {
                [self addSubview:object] ;
                [object mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self) ;
                    make.size.mas_equalTo(CGSizeMake(30, 30)) ;
                }] ;
            }
            [XTAnimation rotateForever:object once:.6] ;
            object;
       });
    }
    return _pgsView;
}

@end
