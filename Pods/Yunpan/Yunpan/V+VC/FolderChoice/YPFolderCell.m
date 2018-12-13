//
//  YPFolderCell.m
//  Yunpan
//
//  Created by teason23 on 2018/9/21.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPFolderCell.h"
#import "YPFiles.h"

@implementation YPFolderCell

- (void)prepareUI {
    [super prepareUI] ;
    
    
}

- (void)configure:(YPFiles *)model indexPath:(NSIndexPath *)indexPath {
    [super configure:model indexPath:indexPath] ;
    
    self.lbName.text = model.name ;    
}

+ (CGFloat)cellHeight {
    return 70. ;
}

@end
