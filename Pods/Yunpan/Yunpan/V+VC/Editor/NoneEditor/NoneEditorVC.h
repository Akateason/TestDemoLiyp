//
//  NoneEditorVC.h
//  Yunpan
//
//  Created by teason23 on 2018/10/15.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "RootCtrl.h"
@class YPFiles ;
NS_ASSUME_NONNULL_BEGIN

@interface NoneEditorVC : UIViewController
@property (strong, nonatomic) YPFiles *afile ;

+ (instancetype)showNoneEditorFromCtrller:(UIViewController *)fromCtrller file:(YPFiles *)file ;
@end

NS_ASSUME_NONNULL_END
