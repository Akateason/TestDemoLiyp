//
//  ChangePwdVC.m
//  SMSHLogin
//
//  Created by teason23 on 2018/12/5.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "ChangePwdVC.h"
#import "SMSHLoginAPIs.h"

@interface ChangePwdVC ()

@end

@implementation ChangePwdVC

+ (void)showFromCtrller:(UIViewController *)ctrller
                account:(NSString *)account
                 verify:(NSString *)verifyCode {
    
    ChangePwdVC *vc = [ChangePwdVC getCtrllerFromStory:@"SMSHLogin" bundle:[NSBundle bundleForClass:self.class] controllerIdentifier:@"ChangePwdVC"] ;
    vc.account = account ;
    vc.verifyCode = verifyCode ;
    [ctrller.navigationController pushViewController:vc animated:YES] ;
}

- (IBAction)btConfirmOnClick:(id)sender {
    [_tfpw1 resignFirstResponder] ;
    [_tfpw2 resignFirstResponder] ;
    
    _lbAlert1.hidden = YES ;
    _lbAlert2.hidden = YES ;
    bool valided = [self passwordFormatIsValid:self.tfpw1.text] ;
    if (!valided) {
        _lbAlert1.hidden = NO ;
        return;
    }
    
    valided = [self passwordFormatIsValid:self.tfpw2.text] ;
    if (!valided) {
        _lbAlert2.hidden = NO ;
        return;
    }
    
    valided = [self.tfpw1.text isEqualToString:self.tfpw2.text] ;
    if (!valided) {
        _lbAlert2.text = @"两次输入的密码不一致" ;
        _lbAlert2.hidden = NO ;
        return ;
    }
    
    NSString *email ;
    NSString *mobile ;
    if ([self.account containsString:@"@"]) email = self.account ;
    else mobile = self.account ;
    
    @weakify(self)
    [SMSHLoginAPIs resetPasswordWithMobile:mobile orEmail:email verifyCode:self.verifyCode password:self.tfpw2.text complete:^(BOOL bSuccess) {
        @strongify(self)
        if (bSuccess) {
            [self.navigationController popToRootViewControllerAnimated:YES] ;
            [SVProgressHUD showInfoWithStatus:@"设置成功, 请重新登录"] ;
        }
    }] ;
}

- (IBAction)showPwd1_OnClik:(UIButton *)sender {
    sender.selected = !sender.selected ;
    self.tfpw1.secureTextEntry = !sender.selected ;
    !sender.selected ?
    [self.btShowpwd1 setImage:[UIImage imageNamed:@"signUpCopy2"] forState:0] :
    [self.btShowpwd1 setImage:[UIImage imageNamed:@"signUpCopy1"] forState:0] ;
}

- (IBAction)showpwd2_OnClick:(UIButton *)sender {
    sender.selected = !sender.selected ;
    self.tfpw2.secureTextEntry = !sender.selected ;
    !sender.selected ?
    [self.btShowpwd2 setImage:[UIImage imageNamed:@"signUpCopy2"] forState:0] :
    [self.btShowpwd2 setImage:[UIImage imageNamed:@"signUpCopy1"] forState:0] ;
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lbAccount.text = self.account ;
    
    @weakify(self)
    [[self.tfpw1.rac_textSignal map:^NSNumber *(NSString * _Nullable value) {
        return @(value.length);
    }] subscribeNext:^(NSNumber *x) {
        @strongify(self)
        BOOL isfirstres = [x boolValue] ;
        self.sep1.hidden = !isfirstres;
        self.btShowpwd1.hidden = !isfirstres;
    }] ;
    
    [self.tfpw2.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        BOOL isfirstres = [@(x.length) boolValue] ;
        self.sep2.hidden = !isfirstres;
        self.btShowpwd2.hidden = !isfirstres;
    }] ;
    
    RACSignal *validPw1Signal = [self.tfpw1.rac_textSignal map:^id(NSString *text) {
        @strongify(self)
        BOOL valid = [self passwordFormatIsValid:text] ;
        if (!valid) self.lbAlert1.text = @"请输入6-15位的密码" ;
        return @(valid) ;
    }];
    
    RACSignal *validPw2Signal = [self.tfpw2.rac_textSignal map:^id(NSString *text) {
        @strongify(self)
        BOOL valid = [self passwordFormatIsValid:text] ;
        if (!valid) self.lbAlert2.text = @"请输入6-15位的密码" ;
        return @(valid) ;
    }];
    
    [[RACSignal combineLatest:@[validPw1Signal,validPw2Signal]
                      reduce:^id(NSNumber *valid1, NSNumber *valid2) {
                          return @([valid1 boolValue] && [valid2 boolValue]) ;
                      }] subscribeNext:^(id  _Nullable x) {
                          @strongify(self)
                          self.btConfirm.backgroundColor = [x boolValue] ? UIColorRGB(65, 70, 75) : UIColorRGBA(65, 70, 75,.35) ;
                          self.lbAlert1.hidden = YES;
                          self.lbAlert2.hidden = YES ;
                      }] ;
}

- (BOOL)passwordFormatIsValid:(NSString *)text {
    return [XTVerification validatePassword:text] ; 
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tfpw1 resignFirstResponder];
    [self.tfpw2 resignFirstResponder];
}

@end
