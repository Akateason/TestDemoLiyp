//
//  UploadCell.h
//  Yunpan
//
//  Created by teason23 on 2018/9/17.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "RootTableCell.h"
#import <DALabeledCircularProgressView.h>

@interface UploadCell : RootTableCell
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UIView *progresContainer;

@property (strong, nonatomic) DALabeledCircularProgressView *progressView ;

@end
