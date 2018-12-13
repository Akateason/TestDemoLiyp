//
//  CooperationVC.h
//  Yunpan
//
//  Created by teason23 on 2018/10/10.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "RootCtrl.h"
@class YPFiles ;

NS_ASSUME_NONNULL_BEGIN

@interface CooperationVC : UIViewController
+ (void)showFromCtrller:(UIViewController *)fromCtrller onFile:(YPFiles *)aFile ;
@end

NS_ASSUME_NONNULL_END
