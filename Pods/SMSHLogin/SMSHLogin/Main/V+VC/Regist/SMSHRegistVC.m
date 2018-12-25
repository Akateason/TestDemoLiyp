//
//  SMSHRegistVC.m
//  SMSHLogin
//
//  Created by teason23 on 2018/12/6.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "SMSHRegistVC.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import <XTBase/MyWebController.h>
#import "SMSHLoginAPIs.h"
#import "InputVerifyCodeVC.h"
#import "SMSHLoginManager.h"


@interface SMSHRegistVC ()

@end

@implementation SMSHRegistVC

#pragma mark - event

- (IBAction)switchRegistWayOnClick:(UIButton *)sender {
    self.vType = self.vType * -1;
}

- (IBAction)showPasswordOnClick:(UIButton *)sender {
    sender.selected = !sender.selected ;
    self.tfPassword.secureTextEntry = !sender.selected ;
    !sender.selected ?
    [self.btShowPassword setImage:[UIImage imageNamed:@"signUpCopy2"] forState:0] :
    [self.btShowPassword setImage:[UIImage imageNamed:@"signUpCopy1"] forState:0] ;
}

- (IBAction)sendVerifyCodeOnClick:(id)sender {
    [SMLoginAnimation zoomAndFade:sender complete:^{
        [self actionBtOnCLick] ;
    }] ;
}

- (void)actionBtOnCLick {
    [_tfAccount resignFirstResponder] ;
    [_tfPassword resignFirstResponder] ;
    
    _lbAlert.hidden = YES ;
    
    BOOL valided = NO ;
    if (self.vType == RegistType_Mobile) {
        valided = [self mobileIsValid:_tfAccount.text] ;
        if (!valided) _lbAlert.hidden = NO ;
        else {
            valided = [self passwordIsValid:_tfPassword.text] ;
            if (!valided)   _lbAlert.hidden = NO ;
        }
    }
    else {
        valided = [self emailIsValid:_tfAccount.text] ;
        if (!valided) _lbAlert.hidden = NO ;
        else {
            valided = [self passwordIsValid:_tfPassword.text] ;
            if (!valided)   _lbAlert.hidden = NO ;
        }
    }
    if (!valided) return ;
    
    
    if (self.vType == RegistType_Mobile) {
        // mobile   // 1. send verify code 2. register.
        // todo
        @weakify(self)
        [InputVerifyCodeVC showFromCtrller:self mobile:self.tfAccount.text email:nil scenceType:InputVerifyCodeVCType_register completion:^(BOOL success, NSString *code, InputVerifyCodeVC *ivcCtrller) {
            
            if (!success) return ;
            
            @strongify(self)
            @weakify(self)
            [SMSHLoginAPIs registUserName:self.tfAccount.text email:nil orMobile:self.tfAccount.text mobileVerifyCode:code password:self.tfPassword.text avatar:nil parentId:nil ref:nil referer:nil inviter:nil geetestDic:nil complete:^(BOOL bSuccess) {
                @strongify(self)
                if (bSuccess) { // regist success
                    [self loginAfterRegister] ; // login
                }
            }];
            
        }] ;
        
    }
    else {
        // email go regist straightly.
        NSString *name = [[self.tfAccount.text componentsSeparatedByString:@"@"] firstObject] ;
        @weakify(self)
        [SMSHLoginAPIs registUserName:name email:self.tfAccount.text orMobile:nil mobileVerifyCode:nil password:self.tfPassword.text avatar:nil parentId:nil ref:nil referer:nil inviter:nil geetestDic:nil complete:^(BOOL bSuccess) {
            if (bSuccess) { // regist success
                @strongify(self)
                [self loginAfterRegister] ; // login
            }
        }] ;
    }
}

- (void)loginAfterRegister {
    @weakify(self)
    if (self.vType == RegistType_Mobile) {
        [SMSHLoginAPIs getOauthTokenWithMobile:self.tfAccount.text mail:nil password:self.tfPassword.text code:nil mobileVerifyCode:nil geetestDic:nil complete:^(BOOL bSuccess2, id json) {
            @strongify(self)
            if (bSuccess2) {
                [SVProgressHUD showSuccessWithStatus:@"注册成功"] ;
                [self dismissViewControllerAnimated:YES completion:^{
                }] ;
            }
            
            if ([[SMSHLoginManager sharedInstance].configure respondsToSelector:@selector(userLoginComplete:)]) {
                [[SMSHLoginManager sharedInstance].configure userLoginComplete:bSuccess2] ;
            }
        }];
    }
    else {
        [SMSHLoginAPIs getOauthTokenWithMobile:nil mail:self.tfAccount.text password:self.tfPassword.text code:nil mobileVerifyCode:nil geetestDic:nil complete:^(BOOL bSuccess2, id json) {
            @strongify(self)
            if (bSuccess2) {
                [SVProgressHUD showSuccessWithStatus:@"注册成功"] ;
                [self dismissViewControllerAnimated:YES completion:^{
                }] ;
            }
            
            if ([[SMSHLoginManager sharedInstance].configure respondsToSelector:@selector(userLoginComplete:)]) {
                [[SMSHLoginManager sharedInstance].configure userLoginComplete:bSuccess2] ;
            }
        }];
    }
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vType = RegistType_Mobile ;
    
    @weakify(self)
    self.lbServeLawty.userInteractionEnabled = YES ;
    [self.lbServeLawty bk_whenTapped:^{
        @strongify(self)
        MyWebController *webVC = [[MyWebController alloc] initWithUrl:[NSURL URLWithString:@"https://shimo.im/agreement"]] ;
        @weakify(webVC)
        [[webVC rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(webVC)
            webVC.navigationController.navigationBar.topItem.title = @"";
        }] ;
        [self.navigationController pushViewController:webVC animated:YES] ;
    }] ;
    
    //
    RACSignal *validUsernameSignal = [self.tfAccount.rac_textSignal map:^id(NSString *text) {
        @strongify(self)
        if (self.vType == RegistType_Mobile) {
            return @([self mobileIsValid:text]) ;
        }
        else if (self.vType == RegistType_Email) {
            return @([self emailIsValid:text]) ;
        }
        return @(YES);
    }];
    RACSignal *validPasswordSignal = [self.tfPassword.rac_textSignal map:^id(NSString *text) {
        @strongify(self)
        return @([self passwordIsValid:text]) ;
    }];
    
    RACSignal *signupActiveSignal =
    [RACSignal combineLatest:@[validUsernameSignal,validPasswordSignal]
                      reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid) {
                          return @([usernameValid boolValue] && [passwordValid boolValue]) ;
                      }] ;
    [signupActiveSignal subscribeNext:^(NSNumber *signupActive) {
        
        @strongify(self)
        self.btSendCode.backgroundColor = [signupActive boolValue] ? UIColorRGB(65, 70, 75) : UIColorRGBA(65, 70, 75,.35) ;
        self.lbAlert.hidden = YES;
    }] ;
    
    //
    [[self.tfPassword.rac_textSignal map:^id _Nullable(NSString *value) {
        return @(value.length > 0);
    }] subscribeNext:^(NSNumber *x) {
        @strongify(self)
        BOOL hasInputed = [x boolValue];
        self.btShowPassword.hidden = !hasInputed;
        self.btSepOfShowPassword.hidden = !hasInputed;
    }];
    
    
    //
    [[[[NSNotificationCenter defaultCenter]
       rac_addObserverForName:UIKeyboardWillShowNotification object:nil]
      takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(NSNotification *notification) {
         
         @strongify(self)
         if ([self.tfAccount isFirstResponder]) {
             [self.line1 startMove] ;
             [self.line2 resetMove] ;
         }
         if ([self.tfPassword isFirstResponder]) {
             [self.line2 startMove] ;
             [self.line1 resetMove] ;
         }
         
     }];
    
    [[[[NSNotificationCenter defaultCenter]
       rac_addObserverForName:UIKeyboardWillHideNotification object:nil]
      takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(NSNotification *notification) {
         
         @strongify(self)
         if ([self.tfAccount isFirstResponder]) {
             [self.line1 resetMove] ;
         }
         if ([self.tfPassword isFirstResponder]) {
             [self.line2 resetMove] ;
         }
     }];
    
    [[self.tfPassword rac_signalForControlEvents:UIControlEventEditingDidEndOnExit] subscribeNext:^(id x) {
        @strongify(self)
        [self sendVerifyCodeOnClick:nil] ;
    }];
}

- (BOOL)mobileIsValid:(NSString *)mobile {
    BOOL result = [XTVerification validateMobile:mobile] ;
    if (!result) self.lbAlert.text = @"请输入正确的手机号格式" ;
    return result ;
}

- (BOOL)emailIsValid:(NSString *)email {
    BOOL result = [XTVerification validateEmail:email] ;
    if (!result) self.lbAlert.text = @"请输入正确的邮箱格式" ;
    return result ;
}

- (BOOL)passwordIsValid:(NSString *)pwd {
    BOOL result = [XTVerification validatePassword:pwd] ;
    if (!result) {
        self.lbAlert.text = @"密码格式不正确,请重新输入" ;
    }
    return result ;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tfAccount resignFirstResponder];
    [self.tfPassword resignFirstResponder];
    
    BOOL valid ;
    if (self.vType == RegistType_Mobile) {
        valid = [self mobileIsValid:self.tfAccount.text] && [self passwordIsValid:self.tfPassword.text] ;
    }
    else {
        valid = [self emailIsValid:self.tfAccount.text] && [self passwordIsValid:self.tfPassword.text] ;
    }
    
    self.lbAlert.hidden = valid ;
    
    if (!self.tfAccount.text.length && !self.tfPassword.text.length) self.lbAlert.hidden = YES ;
}


#pragma mark - props

- (void)setVType:(SMSHRegistType)vType {
    _vType = vType;
    
    switch (vType) {
        case RegistType_Mobile: {
            self.lbTitleOfAccount.text = @"输入手机号" ;
            self.tfAccount.placeholder = @"请输入手机号" ;
            self.tfAccount.keyboardType = UIKeyboardTypePhonePad ;
            self.lb86.hidden = NO ;
            self.lbSepOf86.hidden = NO ;
            self.leftFlexOfTfAccount.constant = 73. ;
            [self.btSwithRegistWay setTitle:@"邮箱注册" forState:0];
            [self.btSendCode setTitle:@"发送验证码" forState:0];
        }
            break;
        case RegistType_Email: {
            self.lbTitleOfAccount.text = @"输入邮箱" ;
            self.tfAccount.placeholder = @"请输入邮箱" ;
            self.tfAccount.keyboardType = UIKeyboardTypeEmailAddress ;
            self.lb86.hidden = YES ;
            self.lbSepOf86.hidden = YES ;
            self.leftFlexOfTfAccount.constant = 24. ;
            [self.btSwithRegistWay setTitle:@"手机号注册" forState:0];
            [self.btSendCode setTitle:@"完成" forState:0];
        }
            break;
        default: break;
    }
    
    self.tfAccount.text = @"";
    self.tfPassword.text = @"";
    self.lbAlert.hidden = YES;
    self.lbAlert.text = @"";
}

@end
