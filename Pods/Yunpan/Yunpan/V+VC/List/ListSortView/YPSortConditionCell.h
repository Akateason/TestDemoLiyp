//
//  YPSortConditionCell.h
//  Yunpan
//
//  Created by teason23 on 2018/10/8.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "RootTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPSortConditionCell : RootTableCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgSortOrder;
@property (weak, nonatomic) IBOutlet UIImageView *imgIsSelected;

@property (nonatomic) BOOL isOnSelect ;
@property (nonatomic) BOOL descOrAsc ;

@end

NS_ASSUME_NONNULL_END
