//
//  MultyChoiceTopBar.h
//  Yunpan
//
//  Created by teason23 on 2018/9/19.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MultyChoiceTopBarDelegate <NSObject>
- (void)cancelBtOnClick ;
- (void)allChooseBtOnClick:(BOOL)allSelectOrNot ;
@end


@interface MultyChoiceTopBar : UIView
+ (instancetype)newFromCtrller:(UIViewController *)fromCtrller ;
@property (weak, nonatomic) id <MultyChoiceTopBarDelegate> delegate ;
- (void)setChoosenCount:(int)count ;
- (void)setIsFullSelected:(BOOL)isFullSelected ;


@property (weak, nonatomic) IBOutlet UIButton *btAllSelect;
@property (weak, nonatomic) IBOutlet UIButton *btCancel;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@end
