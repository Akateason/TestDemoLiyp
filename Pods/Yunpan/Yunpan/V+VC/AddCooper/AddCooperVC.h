//
//  AddCooperVC.h
//  Yunpan
//
//  Created by teason23 on 2018/10/10.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "RootCtrl.h"
@class YPFiles ;
NS_ASSUME_NONNULL_BEGIN

@interface AddCooperVC : RootCtrl
@property (strong, nonatomic) YPFiles *currentFile ;
@property (copy, nonatomic) NSArray *roleIds ;
@end

NS_ASSUME_NONNULL_END
