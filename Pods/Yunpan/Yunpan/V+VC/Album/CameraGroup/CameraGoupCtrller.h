//
//  CameraGoupCtrller.h
//  GroupBuying
//
//  Created by TuTu on 16/8/24.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAssetCollection ;

@protocol CameraGroupCtrllerDelegate <NSObject>
- (void)selectAlbumnGroup:(PHAssetCollection *)collection ;
@end

@interface CameraGoupCtrller : UIViewController

@property (nonatomic, weak)  id <CameraGroupCtrllerDelegate> delegate ;


- (instancetype)initWithFrame:(CGRect)frame ;
- (void)cameraGroupAnimation:(BOOL)inOrOut onView:(UIView *)view ;

@end
