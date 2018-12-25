//
//  ShimoLoginVC.m
//  SMSHLogin
//
//  Created by teason23 on 2018/11/30.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "ShimoLoginVC.h"
#import <XTBase/XTBase.h>
#import "SMSHLoginAPIs.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "ForgetPwdVC.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <GT3Captcha/GT3Captcha.h>
#import "SMSHLoginManager.h"
#import "SMLoginAnimation.h"

@interface ShimoLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfAccount;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btShowPwd;
@property (weak, nonatomic) IBOutlet UIButton *btCheckVerifyModeOrAccountMode;
@property (weak, nonatomic) IBOutlet UIButton *btLogin;
@property (weak, nonatomic) IBOutlet UILabel *lbAlert;
@property (weak, nonatomic) IBOutlet UIButton *btForgetpwd;
@property (weak, nonatomic) IBOutlet UIView *sep;
@property (weak, nonatomic) IBOutlet BarUnderLoginTextInputLine *line1;
@property (weak, nonatomic) IBOutlet BarUnderLoginTextInputLine *line2;

// vm
@property (copy, nonatomic) NSString *vmEmail ;
@property (copy, nonatomic) NSString *vmMobile ;
@property (nonatomic)       BOOL     isEmailOrMobile ; // 1email, 0mobile

@end

@implementation ShimoLoginVC

#pragma mark - action

- (IBAction)showPwd:(UIButton *)sender {
    sender.selected = !sender.selected ;
    self.tfPassword.secureTextEntry = !sender.selected ;
    !sender.selected ?
    [self.btShowPwd setImage:[UIImage imageNamed:@"signUpCopy2"] forState:0] :
    [self.btShowPwd setImage:[UIImage imageNamed:@"signUpCopy1"] forState:0] ;
}

- (IBAction)checkoutVerrfyModeOrAccountMode:(id)sender {
    [self.delegate checkoutButtonClick:1] ;
}

- (IBAction)loginOnClick:(id)sender {
    [_tfAccount resignFirstResponder] ;
    [_tfPassword resignFirstResponder] ;
    
    _lbAlert.hidden = YES ;
    BOOL valided = NO ;
    valided = [self isValidUsername:_tfAccount.text] ;
    if (!valided) _lbAlert.hidden = NO ;
    else {
        valided = [self isValidPassword:_tfPassword.text] ;
        if (!valided)   _lbAlert.hidden = NO ;
    }
    
    if (!valided) return ;
    
    
    [SMLoginAnimation zoomAndFade:sender complete:^{
        
        @weakify(self)
        [SMSHLoginAPIs getOauthTokenWithMobile:self.vmMobile mail:self.vmEmail password:self.tfPassword.text code:nil mobileVerifyCode:nil geetestDic:nil complete:^(BOOL bSuccess, id  _Nonnull json) {
            
            @strongify(self)
            if (bSuccess) {
                NSLog(@"登录成功") ;
                [SVProgressHUD showSuccessWithStatus:@"登录成功"] ;
                [self.delegate.outsideCtrller dismissViewControllerAnimated:YES completion:^{
                }] ;
            }
            else {
                NSLog(@"登录失败") ;
            }
            
            if ([[SMSHLoginManager sharedInstance].configure respondsToSelector:@selector(userLoginComplete:)]) {
                [[SMSHLoginManager sharedInstance].configure userLoginComplete:bSuccess] ;
            }
            
        }] ;
        
    }] ;
}

- (IBAction)forgetPwd:(id)sender {
    [ForgetPwdVC getCtrllerFrom:self.delegate.outsideCtrller account:self.tfAccount.text] ;
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    @weakify(self)
    [self.tfPassword.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        BOOL isfirstres = [@(x.length) boolValue] ;
        self.sep.hidden = !isfirstres;
        self.btShowPwd.hidden = !isfirstres;
    }] ;

    
    RACSignal *validUsernameSignal = [self.tfAccount.rac_textSignal map:^id(NSString *text) {
        @strongify(self)
        return @([self isValidUsername:text]) ;
    }];
    
    RACSignal *validPasswordSignal = [self.tfPassword.rac_textSignal map:^id(NSString *text) {
        @strongify(self)
        return @([self isValidPassword:text]) ;
    }];
    
    RACSignal *signupActiveSignal =
    [RACSignal combineLatest:@[validUsernameSignal,validPasswordSignal]
                      reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid) {
                          return @([usernameValid boolValue] && [passwordValid boolValue]) ;
                      }] ;
    [signupActiveSignal subscribeNext:^(NSNumber *signupActive) {
        
        @strongify(self)
        self.btLogin.backgroundColor = [signupActive boolValue] ? UIColorRGB(65, 70, 75) : UIColorRGBA(65, 70, 75,.35) ;
        self.lbAlert.hidden = YES;
    }] ;
    
    
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
        [self loginOnClick:nil] ;
    }];
    
//    _tfAccount.text = @"chenxia002@shimo.im" ;
//    _tfPassword.text = @"123123" ;
    
//    _tfAccount.text = @"xietianchen@shimo.im" ;
//    _tfPassword.text = @"123456" ;
    
//    _tfAccount.text = @"15000710541" ;
//    _tfPassword.text = @"123456" ;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated] ;
    
    [self.tfAccount becomeFirstResponder] ;
}

- (BOOL)isValidUsername:(NSString *)username {
    BOOL result = NO ;
    if ([username containsString:@"@"]) {
        // mail
        result = [XTVerification validateEmail:username] ;
    }
    else {
        // phone
        username = [username stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([username hasPrefix:@"+86"]) {//如果号码中带有+86，去除+86
            username = [username substringFromIndex:3];
        }
        result = [XTVerification validateMobile:username] ;
    }
    if (!result) {
        self.lbAlert.text = @"账号格式不正确,请重新输入" ;
    }
    return result ;
}

- (BOOL)isValidPassword:(NSString *)pwd {
    BOOL result = [XTVerification validatePassword:pwd] ;
    if (!result) {
        self.lbAlert.text = @"密码格式不正确,请重新输入" ;
    }
    return result ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tfAccount resignFirstResponder];
    [self.tfPassword resignFirstResponder];
    
    bool valid = [self isValidUsername:self.tfAccount.text] && [self isValidPassword:self.tfPassword.text] ;
    self.lbAlert.hidden = valid ;
    
    if (!self.tfAccount.text.length && !self.tfPassword.text.length) self.lbAlert.hidden = YES ;
    
}

#pragma mark - props

- (NSString *)vmEmail{
    if ([_tfAccount.text containsString:@"@"]) {
        return _tfAccount.text ;
    }
    return nil;
}

- (NSString *)vmMobile{
    if (![_tfAccount.text containsString:@"@"]) {
        return _tfAccount.text ;
    }
    return nil;
}

- (BOOL)isEmailOrMobile {
    return [_tfAccount.text containsString:@"@"] ;
}

@end
