//
//  CameraGroupCell.m
//  SuBaoJiang
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "CameraGroupCell.h"
#import <XTlib/XTlib.h>

@interface CameraGroupCell ()

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lb;

@end

@implementation CameraGroupCell

- (void)setGroup:(PHAssetCollection *)group {
    _group = group ;
    WEAK_SELF
    @autoreleasepool {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:group options:nil];
        if (fetchResult.count > 0) {
            PHAsset *asset = (PHAsset *)fetchResult.firstObject ;
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init] ;
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(108, 108) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
             {
                 weakSelf.img.image = result ;
             }] ;
        }
        
        NSString *strShow = [NSString stringWithFormat:@"%@（%lu）",group.localizedTitle , (unsigned long)fetchResult.count] ;
        _lb.text = strShow ;
    }
}

- (void)dealloc {
    _group = nil ;
}

@end
