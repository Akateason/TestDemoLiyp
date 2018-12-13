//
//  CameraGroupCell.h
//  SuBaoJiang
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 teason. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

static NSString *identifierCameraGroupCell = @"CameraGroupCell" ;

@interface CameraGroupCell : UITableViewCell

@property (nonatomic,strong) PHAssetCollection *group ;

@end
