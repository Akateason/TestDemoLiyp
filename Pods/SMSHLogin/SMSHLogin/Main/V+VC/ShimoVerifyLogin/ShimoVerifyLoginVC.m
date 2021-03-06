//
//  ShimoVerifyLoginVC.m
//  SMSHLogin
//
//  Created by teason23 on 2018/12/4.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "ShimoVerifyLoginVC.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <XTBase/XTBase.h>
#import "SMSHLoginAPIs.h"
#import "InputVerifyCodeVC.h"
#import "SMSHLoginManager.h"
#import "SMLoginAnimation.h"


@interface ShimoVerifyLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfAccount;
@property (weak, nonatomic) IBOutlet UILabel *lbAlert;
@property (weak, nonatomic) IBOutlet UIButton *btSendCode;
@property (weak, nonatomic) IBOutlet BarUnderLoginTextInputLine *line1;

@end

@implementation ShimoVerifyLoginVC

- (IBAction)checkoutToAccountLogin:(id)sender {
    [self.delegate checkoutButtonClick:2] ;
}

- (IBAction)btSendCode:(id)sender {
    [_tfAccount resignFirstResponder] ;

    _lbAlert.hidden = YES ;
    BOOL valided = NO ;
    valided = [self isValidUsername:_tfAccount.text] ;
    if (!valided) _lbAlert.hidden = NO ;

    if (!valided) return ;
    
    
    [SMLoginAnimation zoomAndFade:sender complete:^{
        
        @weakify(self)
        [InputVerifyCodeVC showFromCtrller:self.delegate.outsideCtrller
                                    mobile:self.tfAccount.text
                                     email:nil
                                scenceType:InputVerifyCodeVCType_login
                                completion:^(BOOL success, NSString *code, InputVerifyCodeVC *ivcCtrller) {
                                    
                                    if (!success) return ;
                                    
                                    @strongify(self)
                                    [SMSHLoginAPIs getOauthTokenWithMobile:self.tfAccount.text mail:nil password:nil code:nil mobileVerifyCode:code geetestDic:nil complete:^(BOOL bSuccess, id json) {
                                        
                                        if (bSuccess) {
                                            NSLog(@"登录成功") ;
                                            [SVProgressHUD showSuccessWithStatus:@"登录成功"] ;
                                            [ivcCtrller dismissViewControllerAnimated:YES completion:^{}] ;
                                        }
                                        else {
                                            NSLog(@"登录失败") ;
                                        }
                                        
                                        if ([[SMSHLoginManager sharedInstance].configure respondsToSelector:@selector(userLoginComplete:)]) {
                                            [[SMSHLoginManager sharedInstance].configure userLoginComplete:success] ;
                                        }

                                    }] ;
                                    
                                }] ;
     
    }] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    RACSignal *validUsernameSignal = [self.tfAccount.rac_textSignal map:^id(NSString *text) {
        return @([self isValidUsername:text]);
    }];
    
    [validUsernameSignal subscribeNext:^(NSNumber *x) {
        bool valid = [x boolValue] ;
        self.btSendCode.backgroundColor = valid ? UIColorRGB(65, 70, 75) : UIColorRGBA(65, 70, 75,.35) ;
        self.lbAlert.hidden = YES;
    }];
    
    
    //
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter]
       rac_addObserverForName:UIKeyboardWillShowNotification object:nil]
      takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(NSNotification *notification) {
         
         @strongify(self)
         if ([self.tfAccount isFirstResponder]) {
             [self.line1 startMove] ;
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
     }];
    
    [[self.tfAccount rac_signalForControlEvents:UIControlEventEditingDidEndOnExit] subscribeNext:^(id x) {
        @strongify(self)
        [self btSendCode:nil] ;
    }];

//    self.tfAccount.text = @"15000710541" ;
}

- (BOOL)isValidUsername:(NSString *)username {
    return [XTVerification validateMobile:username] ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tfAccount resignFirstResponder];
    
    self.lbAlert.hidden = [self isValidUsername:self.tfAccount.text] ;
}

@end
