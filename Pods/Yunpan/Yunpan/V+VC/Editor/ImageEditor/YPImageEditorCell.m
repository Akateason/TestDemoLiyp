//
//  YPImageEditorCell.m
//  Yunpan
//
//  Created by teason23 on 2018/10/13.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPImageEditorCell.h"
#import <XTlib/XTlib.h>
#import <XTlib/XTAnimation.h>
#import <XTlib/XTZoomPicture.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SHMDriveSDK.h"
#import "YPFiles.h"
#import "UIImage+Yunpan.h"
#import <YYWebImage/YYWebImage.h>

@interface YPImageEditorCell ()
@property (strong, nonatomic) XTZoomPicture *zoomPic ;
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
}

- (void)configure:(YPFiles *)file {
    [super configure:file] ;
    
    [self.zoomPic resetToOrigin] ;
    self.pgsView.hidden = NO ;
    
    NSLog(@"%@",[YYWebImageManager sharedManager].headers) ;
    
    WEAK_SELF
    [self.zoomPic.imageView yy_setImageWithURL:[NSURL URLWithString:file.downloadUrl] placeholder:nil options:YYWebImageOptionAllowInvalidSSLCertificates completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {

        weakSelf.zoomPic.backImage = image ;
        weakSelf.pgsView.hidden = YES ;
    }] ;
}

- (UIImageView *)pgsView{
    if(!_pgsView){
        _pgsView = ({
            UIImageView *object = [[UIImageView alloc] initWithImage:[UIImage shmyp_imageNamed:@"pgs_icon" fromBundleClass:self.class]] ;
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
