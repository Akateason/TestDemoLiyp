//
//  YPImageEditorVC.h
//  Yunpan
//
//  Created by teason23 on 2018/10/13.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "RootCtrl.h"
#import "YPFolderMananger.h"

@class YPFiles ;

NS_ASSUME_NONNULL_BEGIN

@interface YPImageEditorVC : RootCtrl

+ (instancetype)showFromCtrller:(UIViewController *)fromCtrller ;

- (void)setupWithImgFileList:(NSArray <YPFiles *>*)list
             currentImageIdx:(NSInteger)idx
                    fromType:(YPFileClickFrom_Type)type ;

@end

NS_ASSUME_NONNULL_END
