//
//  AlbumVC.h
//  Yunpan
//
//  Created by teason23 on 2018/9/14.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "RootCtrl.h"

@interface AlbumVC : RootCtrl

+ (void)showAlbumFrom:(UIViewController *)fromCtrller
           parentGuid:(NSString *)parentGuid
           parentName:(NSString *)parentName ;

@end
