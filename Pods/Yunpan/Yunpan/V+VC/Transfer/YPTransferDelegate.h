//
//  YPTransferDelegate.h
//  Yunpan
//
//  Created by teason23 on 2018/10/31.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YPFiles ;
NS_ASSUME_NONNULL_BEGIN

@protocol YPTransferDelegate <NSObject>
- (void)clickFile:(YPFiles *)aFile fileList:(NSArray *)list ;
@end

NS_ASSUME_NONNULL_END
