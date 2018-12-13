//
//  MultyChoiceBottomBar.m
//  Yunpan
//
//  Created by teason23 on 2018/9/19.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "MultyChoiceBottomBar.h"
#import <XTlib/XTlib.h>
#import <LXMButtonImagePosition/UIButton+LXMImagePosition.h>
#import "UIImage+Yunpan.h"

@interface MultyChoiceBottomBar ()
@property (nonatomic) EditedToolbarMode mode ;
@end

@implementation MultyChoiceBottomBar

static const int kTagToolBt = 323471 ;

- (IBAction)toolBtOnClick:(UIButton *)sender {
    NSLog(@"%@",sender.currentTitle) ;
    int btIndex = (int)(sender.tag - kTagToolBt + 1) ;
    
    switch (self.mode) {
        case mode_selectOneFile: {
            switch (btIndex) {
                case 1: [self.delegate addMembers] ; break ;
                case 2: [self.delegate download] ; break ;
                case 3: [self.delegate movingFile] ; break ;
                case 4: [self.delegate deleteFile] ; break ;
                case 5: [self.delegate more] ; break ;
                default:
                    break;
            }
        }
            break;
        case mode_selectOneFolder: {
            switch (btIndex) {
                case 1: [self.delegate addMembers] ; break ;
                case 2: [self.delegate movingFile] ; break ;
                case 3: [self.delegate deleteFile] ; break ;
                case 4: [self.delegate more] ; break ;
                default:
                    break;
            }
        }
            break;
        case mode_selectManyFiles: {
            switch (btIndex) {
                case 1: [self.delegate download] ; break ;
                case 2: [self.delegate movingFile] ; break ;
                case 3: [self.delegate deleteFile] ; break ;
                case 4: [self.delegate more] ; break ;
                default:
                    break;
            }
        }
            break;
        case mode_selectManyFilesOrFolder: {
            switch (btIndex) {
                case 1: [self.delegate movingFile] ; break ;
                case 2: [self.delegate deleteFile] ; break ;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}


- (void)makeupWithMode:(EditedToolbarMode)mode {
    self.mode = mode ;
    
    [self.btArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = NO ;
    }] ;
    
    switch (mode) {
        case mode_selectOneFile: {
            [self makeButtonAddMembers:_bt1] ;
            [self makeButtonDownload:_bt2] ;
            [self makeButtonMove:_bt3] ;
            [self makeButtonDelete:_bt4] ;
            [self makeButtonMore:_bt5] ;
        }
            break;
        case mode_selectOneFolder: {
            [self makeButtonAddMembers:_bt1] ;
            [self makeButtonMove:_bt2] ;
            [self makeButtonDelete:_bt3] ;
            [self makeButtonMore:_bt4] ;
            _bt5.hidden = YES ;
        }
            break;
        case mode_selectManyFiles: {
            [self makeButtonDownload:_bt1] ;
            [self makeButtonMove:_bt2] ;
            [self makeButtonDelete:_bt3] ;
            [self makeButtonMore:_bt4] ;
            _bt5.hidden = YES ;
        }
            break;
        case mode_selectManyFilesOrFolder: {
            [self makeButtonMove:_bt1] ;
            [self makeButtonDelete:_bt2] ;
            _bt3.hidden = YES ;
            _bt4.hidden = YES ;
            _bt5.hidden = YES ;
        }
            break;
        default:
            break;
    }
    
    [self.btArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setImagePosition:LXMImagePositionTop spacing:3] ;
    }] ;
}

- (void)makeButtonAddMembers:(UIButton *)button {
    [button setImage:[UIImage shmyp_imageNamed:@"bar_coop" fromBundleClass:self.class] forState:0] ;
    [button setTitle:@"添加协作者" forState:0] ;
}

- (void)makeButtonDownload:(UIButton *)button {
    [button setImage:[UIImage shmyp_imageNamed:@"bar_download" fromBundleClass:self.class] forState:0] ;
    [button setTitle:@"下载" forState:0] ;
}

- (void)makeButtonMove:(UIButton *)button {
    [button setImage:[UIImage shmyp_imageNamed:@"bar_move" fromBundleClass:self.class] forState:0] ;
    [button setTitle:@"移动" forState:0] ;
}

- (void)makeButtonDelete:(UIButton *)button {
    [button setImage:[UIImage shmyp_imageNamed:@"bar_delete" fromBundleClass:self.class] forState:0] ;
    [button setTitle:@"删除" forState:0] ;
}

- (void)makeButtonMore:(UIButton *)button {
    [button setImage:[UIImage shmyp_imageNamed:@"bar_more" fromBundleClass:self.class] forState:0] ;
    [button setTitle:@"更多" forState:0] ;
}

+ (instancetype)newFromCtrller:(UIViewController *)fromCtrller {
    UINib *nib = [UINib nibWithNibName:@"MultyChoiceBottomBar" bundle:[NSBundle bundleForClass:self.class]] ;
    MultyChoiceBottomBar *_eBottombar = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0] ;

    
    _eBottombar.delegate = (id)fromCtrller ;
    if (!_eBottombar.superview) {
        [fromCtrller.view.window addSubview:_eBottombar] ;
        [_eBottombar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(fromCtrller.view.window) ;
            make.bottom.equalTo(fromCtrller.view.window.mas_safeAreaLayoutGuideBottom) ;
            make.height.equalTo(@49) ;
        }] ;
    }
    return _eBottombar ;
}

@end
