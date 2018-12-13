//
//  YPListCell.h
//  Yunpan
//
//  Created by teason23 on 2018/9/11.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "RootTableCell.h"
@class Files ;

@protocol YPListCellDelegate<NSObject>
- (void)btChooseOnclick:(BOOL)beOnSelect indexPath:(NSIndexPath *)indexPath ;
@end

@interface YPListCell : RootTableCell

@property (weak, nonatomic) id <YPListCellDelegate> delegate ;

@property (weak, nonatomic) IBOutlet UIImageView *imgContent;
@property (weak, nonatomic) IBOutlet UIButton *btChoose;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbSubtitle;

@end
