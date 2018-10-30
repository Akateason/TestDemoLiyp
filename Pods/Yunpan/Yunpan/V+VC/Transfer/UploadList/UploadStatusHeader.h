//
//  UploadStatusHeader.h
//  Yunpan
//
//  Created by teason23 on 2018/9/19.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadStatusHeader : UITableViewHeaderFooterView
@property (copy, nonatomic) NSString *sectionTitle ;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier ;
@end
