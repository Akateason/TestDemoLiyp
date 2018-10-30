//
//  PreviewCollectionCell.h
//  GroupBuying
//
//  Created by TuTu on 16/8/30.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *idPreviewCollectionCell = @"PreviewCollectionCell" ;

@interface PreviewCollectionCell : UICollectionViewCell

@property (nonatomic,strong) UIImage *image ;
- (void)resetStyle ;

@end
