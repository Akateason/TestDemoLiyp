//
//  ListVC+Poperview.h
//  Yunpan
//
//  Created by teason23 on 2018/10/18.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "ListVC.h"
@class YPFiles ;
NS_ASSUME_NONNULL_BEGIN

@interface ListVC (Poperview)
- (void)poperClickWithParentFile:(YPFiles *)parentFile ;
@end

NS_ASSUME_NONNULL_END
