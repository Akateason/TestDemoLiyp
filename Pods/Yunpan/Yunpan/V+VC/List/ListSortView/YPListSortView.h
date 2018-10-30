//
//  YPListSortView.h
//  Yunpan
//
//  Created by teason23 on 2018/10/8.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XTlib.h>

NS_ASSUME_NONNULL_BEGIN
@class YPListSortManager ;
typedef void(^ChoosenSortInfo)(YPListSortManager *manager) ;

@interface YPListSortView : UIView
@property (copy, nonatomic) ChoosenSortInfo blkChoosenSortInfo ;
+ (void)showFromCtrller:(UIViewController *)fromCtrller
         underWhichView:(UIView *)underWView
        sortInfoChoosen:(ChoosenSortInfo)blk ;
@end


typedef enum : NSUInteger {
    YPListSortType_updateTime = 1 ,
    YPListSortType_createTime ,
    YPListSortType_size ,
    YPListSortType_fileName ,
    YPListSortType_author
} YPListSortType;


@interface YPListSortManager : NSObject
XT_SINGLETON_H(YPListSortManager)
@property (assign, nonatomic) YPListSortType sortType ;
@property (assign, nonatomic) BOOL           sortOrder ; // default is NO , NO - desc, YES - asc ;

+ (NSString *)stringForType:(YPListSortType)sortType ;
- (void)setup ;
// vm
- (void)choosenWithType:(YPListSortType)sortType ;
- (NSArray *)startSort:(NSArray *)array ;
@end

NS_ASSUME_NONNULL_END
