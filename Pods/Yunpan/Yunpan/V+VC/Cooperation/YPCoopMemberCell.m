//
//  YPCoopMemberCell.m
//  Yunpan
//
//  Created by teason23 on 2018/10/10.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPCoopMemberCell.h"
#import <LXMButtonImagePosition/UIButton+LXMImagePosition.h>
#import <XTlib/XTlib.h>
#import "YPMemberInfo.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "SHMDriveSDK.h"
#import "UIImage+Yunpan.h"
#import <YYWebImage/YYWebImage.h>

@interface YPCoopMemberCell ()

@end

@implementation YPCoopMemberCell

- (void)setAMember:(YPMemberInfo *)member {
    _aMember = member ;
    
    NSString *name = [SHMDriveSDK sharedInstance].delegate.userID == member.member_id ? [member.name stringByAppendingString:@"(我)"] : member.name ;
    self.lbName.text = name ;
    self.lbMail.text = member.email ;
//    [self.imgUserHead sd_setImageWithURL:[NSURL URLWithString:member.avatar] placeholderImage:[UIImage shmyp_imageNamed:@"userPlaceHolder" fromBundleClass:self.class]] ;    
    [self.imgUserHead yy_setImageWithURL:[NSURL URLWithString:member.avatar] placeholder:[UIImage shmyp_imageNamed:@"userPlaceHolder" fromBundleClass:self.class]] ;
    
    CooperateMemberAccessType cType = [member getCooperTypeOnFile:self.aFile] ;
    switch (cType) {
        case CooperateMemberAccessType_ReadOnly: {
            self.lbAuthor.hidden = YES ;
            self.btUserAccess.hidden = NO ;
            [self.btUserAccess setTitle:@"可以预览" forState:0] ;
        }
            break;
        case CooperateMemberAccessType_Owner: {
            self.lbAuthor.hidden = NO ;
            self.btUserAccess.hidden = YES ;
        }
            break;
        case CooperateMemberAccessType_Manager: {
            self.lbAuthor.hidden = YES ;
            self.btUserAccess.hidden = NO ;
            [self.btUserAccess setTitle:@"管理者" forState:0] ;
        }
            break;
        default:
            break;
    }
    
    if (self.isAddMode && self.aMember.roleId == 0) {
        [self.btUserAccess setTitleColor:UIColorHexA(@"41464b",.3) forState:0] ;
        [self.btUserAccess setImage:nil forState:0] ;
        [self.btUserAccess setTitle:@"添加" forState:0] ;
        [self.btUserAccess setImagePosition:LXMImagePositionRight spacing:0] ;
    }
    else {
        [self.btUserAccess setTitleColor:UIColorHex(@"73a2e3") forState:0] ;
        [self.btUserAccess setImage:[UIImage shmyp_imageNamed:@"triangle1" fromBundleClass:self.class] forState:0] ;
        [self.btUserAccess setImagePosition:LXMImagePositionRight spacing:5] ;
    }
    
    
}

- (void)prepareUI {
    [super prepareUI] ;
    
    _lbName.text = @"" ;
    _lbMail.text = @"" ;
    _lbAuthor.hidden = YES ;
    _btUserAccess.hidden = YES ;
    _btUserAccess.userInteractionEnabled = NO ;
    
    @weakify(self)
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self addGestureRecognizer:tap] ;
    [[[tap rac_gestureSignal] throttle:.2] subscribeNext:^(id x) {
        @strongify(self)
        if (!self.aMember) return ;
        
        if (self.isAddMode && self.aMember.roleId == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(addThisMember:)]) [self.delegate addThisMember:self.aMember] ;
        }
        else {
            @weakify(self)
            CooperateMemberAccessType cType = [self.aMember getCooperTypeOnFile:self.aFile] ;
            NSDictionary *dic = [self.aMember getDescInfoWithCooperType:cType] ;
            [UIAlertController xt_showAlertCntrollerWithAlertControllerStyle:UIAlertControllerStyleActionSheet
                                                                       title:dic.allKeys.firstObject
                                                                     message:dic.allValues.firstObject
                                                           cancelButtonTitle:@"取消"
                                                      destructiveButtonTitle:(cType == CooperateMemberAccessType_Owner) ? nil : @"移除"
                                                           otherButtonTitles:nil
                                                               callBackBlock:^(NSInteger btnIndex) {
                                                                   
                                                                   @strongify(self)
                                                                   if (btnIndex == 1) {
                                                                       [self.delegate deleteThisMember:self.aMember] ;
                                                                   }
                                                               }] ;
        }
        
    }] ;

    
    
    UIView *aLine = [UIView new] ;
    aLine.backgroundColor = UIColorHex(@"dcdcdc") ;
    [self addSubview:aLine] ;
    [aLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self) ;
        make.height.equalTo(@.5) ;
    }] ;
}

- (void)configure:(CooperMemberRelate *)model {
    [super configure:model] ;
    
    WEAK_SELF
    [model transformToMember:^(YPMemberInfo * _Nonnull member) {
        
        weakSelf.aMember = member ;
        
    }] ;
}

+ (CGFloat)cellHeight {
    return 70. ;
}

@end
