//
//  InputVerifyCodeVC.h
//  SMSHLogin
//
//  Created by teason23 on 2018/12/4.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "SMLoginRootVC.h"
@class InputVerifyCodeVC;

typedef enum : NSUInteger {
    InputVerifyCodeVCType_login = 0,
    InputVerifyCodeVCType_changePassword,
    InputVerifyCodeVCType_changeMobile,
    InputVerifyCodeVCType_bind,
    InputVerifyCodeVCType_register,
    InputVerifyCodeVCType_authentication
} InputVerifyCodeVCType;

#define kARRAY_InputVerifyCodeVCType    @[@"login",@"change_password",@"change_mobile",@"bind",@"register",@"authentication"]
typedef void(^VerifyCodeCompletion)(BOOL success, NSString *code, InputVerifyCodeVC *ivcCtrller);

@interface InputVerifyCodeVC : SMLoginRootVC
@property (weak, nonatomic) IBOutlet UILabel *lbMobile;
@property (weak, nonatomic) IBOutlet UILabel *lbVoice;
@property (weak, nonatomic) IBOutlet UIButton *btSendAgain;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UILabel *lb1;
@property (weak, nonatomic) IBOutlet UILabel *lb2;
@property (weak, nonatomic) IBOutlet UILabel *lb3;
@property (weak, nonatomic) IBOutlet UILabel *lb4;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *numsLbList;
@property (weak, nonatomic) IBOutlet UILabel *lbTipSend;

+ (void)showFromCtrller:(UIViewController *)ctrller
                 mobile:(NSString *)mobile
                  email:(NSString *)email
             scenceType:(InputVerifyCodeVCType)scenctType
             completion:(VerifyCodeCompletion)completion ;

@end

