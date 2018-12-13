//
//  UploadCell.h
//  Yunpan
//
//  Created by teason23 on 2018/9/17.
//  Copyright © 2018年 teason23. All rights reserved.
//



#import <MGSwipeTableCell/MGSwipeTableCell.h>
#import "RootTableCell.h"
#import <DACircularProgress/DALabeledCircularProgressView.h>


@interface UploadCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UIView *progresContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;

@property (strong, nonatomic) DALabeledCircularProgressView *progressView ;

@end
