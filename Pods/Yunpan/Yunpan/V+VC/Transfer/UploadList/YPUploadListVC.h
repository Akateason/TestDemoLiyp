//
//  YPUploadListVC.h
//  Yunpan
//
//  Created by teason23 on 2018/9/28.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "RootCtrl.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPUploadListVC : RootCtrl
@property (strong, nonatomic) UITableView *table ;
- (void)refresh ;
@end

NS_ASSUME_NONNULL_END
