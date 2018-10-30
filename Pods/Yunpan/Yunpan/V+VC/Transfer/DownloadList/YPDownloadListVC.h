//
//  YPDownloadListVC.h
//  Yunpan
//
//  Created by teason23 on 2018/9/28.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "RootCtrl.h"
@class YPFiles ;
NS_ASSUME_NONNULL_BEGIN

@protocol YPDownloadListVCDelegate <NSObject>
- (void)clickFile:(YPFiles *)aFile fileList:(NSArray *)list ;
@end

@interface YPDownloadListVC : RootCtrl
@property (weak, nonatomic) id <YPDownloadListVCDelegate> delegate ;

@property (strong, nonatomic) UITableView *table ;
- (void)refresh ;
@end

NS_ASSUME_NONNULL_END
