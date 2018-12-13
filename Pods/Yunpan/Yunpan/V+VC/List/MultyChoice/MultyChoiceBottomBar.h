//
//  MultyChoiceBottomBar.h
//  Yunpan
//
//  Created by teason23 on 2018/9/19.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EditedToolbarMode) {
    mode_selectOneFile = 1          ,   // 选中文件
    mode_selectOneFolder            ,   // 选中文件夹
    mode_selectManyFiles            ,   // 多选(全文件)
    mode_selectManyFilesOrFolder    ,   // 多选(混合,含有文件夹)
};

@protocol  MultyChoiceBottomBarDelegate <NSObject>
- (void)addMembers ;
- (void)download ;
- (void)movingFile ;
- (void)deleteFile ;
- (void)more ;
@end

@interface MultyChoiceBottomBar : UIView
@property (weak, nonatomic) id <MultyChoiceBottomBarDelegate> delegate ;
@property (weak, nonatomic) IBOutlet UIButton *bt1;
@property (weak, nonatomic) IBOutlet UIButton *bt2;
@property (weak, nonatomic) IBOutlet UIButton *bt3;
@property (weak, nonatomic) IBOutlet UIButton *bt4;
@property (weak, nonatomic) IBOutlet UIButton *bt5;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btArray;

+ (instancetype)newFromCtrller:(UIViewController *)fromCtrller ;
- (void)makeupWithMode:(EditedToolbarMode)mode ;

@end
