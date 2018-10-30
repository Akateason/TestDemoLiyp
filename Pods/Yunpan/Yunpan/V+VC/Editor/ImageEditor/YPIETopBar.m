//
//  YPIETopBar.m
//  Yunpan
//
//  Created by teason23 on 2018/10/15.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPIETopBar.h"
#import <XTlib.h>


@interface YPIETopBar ()
@property (strong, nonatomic) UIButton *btClose ;
@property (strong, nonatomic) UILabel *lbTitle ;
@property (strong, nonatomic) UIButton *btDelete ;
@end

@implementation YPIETopBar

+ (instancetype)newFromCtrller:(UIViewController *)fromCtrller {
    YPIETopBar *topbar = [YPIETopBar new] ;
    topbar.xt_gradientPt0 = CGPointMake(0.5, 0) ;
    topbar.xt_gradientPt1 = CGPointMake(0.5, 1) ;
    topbar.xt_gradientColor0 = UIColorRGBA(0, 0, 0, 0.2) ;
    topbar.xt_gradientColor1 = UIColorRGBA(0, 0, 0, 0) ;
    [topbar addSubview:topbar.btClose] ;
    [topbar.btClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44)) ;
        make.top.equalTo(@15) ;
        make.left.equalTo(@10) ;
    }] ;
    
    [topbar addSubview:topbar.lbTitle] ;
    [topbar.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topbar) ;
        make.centerY.equalTo(topbar.btClose) ;
    }] ;
    

    [topbar addSubview:topbar.btDelete] ;
    [topbar.btDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44)) ;
        make.top.equalTo(@15) ;
        make.right.equalTo(@-10) ;
    }] ;
    
    [fromCtrller.view addSubview:topbar] ;
    [topbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@80) ;
        make.left.right.equalTo(fromCtrller.view) ;
        make.top.equalTo(fromCtrller.view.mas_safeAreaLayoutGuideTop).offset(-20) ;
    }] ;
    return topbar ;
}

- (void)setTitle:(NSString *)title {
    _title = title ;
    
    self.lbTitle.text = title ;
}

- (void)setShowDeleteButton:(BOOL)showDeleteButton {
    _showDeleteButton = showDeleteButton ;
    
    self.btDelete.hidden = !showDeleteButton ;
}


- (UIButton *)btClose{
    if(!_btClose){
        _btClose = ({
            UIButton * object = [[UIButton alloc] init];
            [object setImage:[UIImage imageNamed:@"ie_topbar_btclose"] forState:0] ;
            [object addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside] ;
            object;
       });
    }
    return _btClose;
}

- (UILabel *)lbTitle{
    if(!_lbTitle){
        _lbTitle = ({
            UILabel * object = [[UILabel alloc] init] ;
            object.textColor = [UIColor whiteColor] ;
            object.font = [UIFont boldSystemFontOfSize:17] ;
            object.textAlignment = NSTextAlignmentCenter ;
            object;
       });
    }
    return _lbTitle;
}

- (UIButton *)btDelete{
    if(!_btDelete){
        _btDelete = ({
            UIButton * object = [[UIButton alloc]init];
            [object setImage:[UIImage imageNamed:@"ie_topbar_btdelete"] forState:0] ;
            [object addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside] ;
            object;
       });
    }
    return _btDelete;
}


- (void)closeAction {
    [self.delegate closeOnClick] ;
}

- (void)deleteAction {
    [self.delegate deleteOnClick] ;
}

@end
