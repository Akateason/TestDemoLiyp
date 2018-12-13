//
//  FolderChoiceVC.h
//  Yunpan
//
//  Created by teason23 on 2018/9/21.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "RootCtrl.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kNotificate_FolderChoosen = @"kNotificate_FolderChoosen" ;

typedef NS_ENUM(NSUInteger, FolderChoiceVC_Type) {
    FolderChoiceVC_Type_copy = 1,
    FolderChoiceVC_Type_move,
    FolderChoiceVC_Type_PostImage,
};


@interface FolderChoiceVC : UIViewController

@property (nonatomic) FolderChoiceVC_Type vType ;

+ (void)modalFromHomeCtrller:(UIViewController *)fromCtrller vType:(FolderChoiceVC_Type)type ;

@end

NS_ASSUME_NONNULL_END
