//
//  AlbumnCell.m
//  SuBaoJiang
//
//  Created by apple on 15/6/24.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "AlbumnCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <XTlib/XTlib.h>
#import "UIImage+Yunpan.h"


@implementation AlbumnCell

#pragma mark --
#pragma mark - Inital
- (void)awakeFromNib {
    [super awakeFromNib] ;
    
    _img.contentMode = UIViewContentModeScaleAspectFill ;
    _img_picSelect.hidden = NO ;
}

#pragma mark --
#pragma mark - Prop
- (void)setBTakePhoto:(BOOL)bTakePhoto {
    _bTakePhoto = bTakePhoto ;
    
    _img.hidden = bTakePhoto ;
    _img_picSelect.hidden = bTakePhoto ;
    self.layer.borderColor = [UIColor blackColor].CGColor ;
    self.layer.borderWidth = bTakePhoto ? 5. : 0. ;
}

- (void)setPicSelected:(BOOL)picSelected {
    _picSelected = picSelected ;
    
    NSString *imgStr = picSelected ? @"ab_selected" : @"ab_select" ;
    _img_picSelect.image = [UIImage shmyp_imageNamed:imgStr fromBundleClass:self.class] ;
}

#pragma mark --
#pragma mark - 

+ (CGSize)getSize {
    float collectionSlider = ( APPFRAME.size.width - kCOLUMN_FLEX * ((float)kCOLUMN_NUMBER + 1) ) / (float)kCOLUMN_NUMBER ;
    return CGSizeMake(collectionSlider, collectionSlider) ;
}

@end
