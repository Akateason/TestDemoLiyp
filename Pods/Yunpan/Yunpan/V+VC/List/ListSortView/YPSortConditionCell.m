//
//  YPSortConditionCell.m
//  Yunpan
//
//  Created by teason23 on 2018/10/8.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPSortConditionCell.h"
#import <XTlib.h>
#import "YPListSortView.h"



@implementation YPSortConditionCell

- (void)setIsOnSelect:(BOOL)isOnSelect {
    _isOnSelect = isOnSelect ;
    
    _imgSortOrder.hidden = !isOnSelect ;
    _imgIsSelected.hidden = !isOnSelect ;
    _lbTitle.font = isOnSelect ? [UIFont boldSystemFontOfSize:16] : [UIFont systemFontOfSize:16] ;
}

- (void)setDescOrAsc:(BOOL)descOrAsc {
    _descOrAsc = descOrAsc ;
    
    _imgSortOrder.image = !descOrAsc ? [UIImage imageNamed:@"arrow_bar_down"] : [UIImage imageNamed:@"arrow_bar_up"] ;
}

- (void)prepareUI {
    [super prepareUI] ;
    
    self.lbTitle.textColor = UIColorRGB(65, 70, 75) ;
    self.isOnSelect = NO ;
    self.descOrAsc = NO ;
}

- (void)configure:(id)model indexPath:(NSIndexPath *)indexPath {
    [super configure:model indexPath:indexPath] ;
    
    NSInteger typeRow = indexPath.row + 1 ;
    _lbTitle.text = [YPListSortManager stringForType:typeRow] ;
    
    self.isOnSelect = [YPListSortManager sharedInstance].sortType == typeRow ;
    self.descOrAsc = [YPListSortManager sharedInstance].sortOrder ;
    
    if ([YPListSortManager sharedInstance].sortType == YPListSortType_author) {
        self.imgSortOrder.hidden = YES ;
    }    
}

+ (CGFloat)cellHeight {
    return 52. ;
}

@end

