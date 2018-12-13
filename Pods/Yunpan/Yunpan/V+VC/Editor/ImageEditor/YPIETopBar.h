//
//  YPIETopBar.h
//  Yunpan
//
//  Created by teason23 on 2018/10/15.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YPIETopBarDelegate <NSObject>
@required
- (void)closeOnClick ;
- (void)deleteOnClick ;

@end

@interface YPIETopBar : UIView
@property (weak,nonatomic) id <YPIETopBarDelegate> delegate ;
@property (copy,nonatomic)  NSString *title ;
@property (nonatomic)       BOOL     showDeleteButton ;
+ (instancetype)newFromCtrller:(UIViewController *)fromCtrller ;

@end

NS_ASSUME_NONNULL_END
