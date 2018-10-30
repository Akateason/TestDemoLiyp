//
//  ListVC.h
//  Yunpan
//
//  Created by teason23 on 2018/9/11.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "RootCtrl.h"
@class YPFiles ;

@interface ListVC : RootCtrl
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *btSort;
@property (weak, nonatomic) IBOutlet UIView *topContainer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barItemTrans;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomOfTable;


+ (void)goIn:(YPFiles *)afile
 fromCtrller:(UIViewController *)fromCtrller ;

@end
