//
//  AlbumnCell.h
//  SuBaoJiang
//
//  Created by apple on 15/6/24.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString     *identifierAlbumnCell   = @"AlbumnCell" ;
static int          kCOLUMN_NUMBER          = 4 ;
static float        kCOLUMN_FLEX            = 1.0 ;

@class ALAsset ;

@interface AlbumnCell : UICollectionViewCell

//Attrs
@property (nonatomic) BOOL                       bTakePhoto ;    // only in singleType . set a take photo icon .
//@property (nonatomic) Mode_SingleOrMultiple      fetchMode ;     // Mode_SingleOrMultiple
@property (nonatomic) BOOL                       picSelected ;   // only in multyType
//UIs
@property (weak, nonatomic) IBOutlet UIImageView *img ;
@property (weak, nonatomic) IBOutlet UILabel *lbAlreadyUploaded;
@property (weak, nonatomic) IBOutlet UIImageView *img_picSelect;

+ (CGSize)getSize ;


@end
