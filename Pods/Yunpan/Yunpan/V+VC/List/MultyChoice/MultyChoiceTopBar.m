//
//  MultyChoiceTopBar.m
//  Yunpan
//
//  Created by teason23 on 2018/9/19.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "MultyChoiceTopBar.h"
#import <XTlib.h>

@implementation MultyChoiceTopBar

- (IBAction)btAllSelectOnClick:(UIButton *)sender {
    sender.selected = !sender.selected ;
    [self.delegate allChooseBtOnClick:sender.selected] ;
}

- (IBAction)btCancelOnClick:(id)sender {
    [self.delegate cancelBtOnClick] ;
}

- (void)setChoosenCount:(int)count {
    self.lbTitle.text = [NSString stringWithFormat:@"已选择%d个文件",count] ;
}

- (void)setIsFullSelected:(BOOL)isFullSelected {
    self.btAllSelect.selected = isFullSelected ;
}

+ (instancetype)newFromCtrller:(UIViewController *)fromCtrller {
    MultyChoiceTopBar *_eTopbar = [MultyChoiceTopBar xt_newFromNib] ;
    _eTopbar.delegate = fromCtrller ;
    if (!_eTopbar.superview) {
        [fromCtrller.view.window addSubview:_eTopbar] ;
        [_eTopbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(fromCtrller.view.window) ;
            make.top.equalTo(fromCtrller.view.window.mas_safeAreaLayoutGuideTop) ;
            make.height.equalTo(@44) ;
        }] ;
    }
    return _eTopbar ;
}

@end
