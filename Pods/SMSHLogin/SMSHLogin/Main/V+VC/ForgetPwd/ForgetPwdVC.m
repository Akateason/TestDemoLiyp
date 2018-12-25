//
//  ForgetPwdVC.m
//  SMSHLogin
//
//  Created by teason23 on 2018/12/4.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "ForgetPwdVC.h"
#import <XTBase/XTBase.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "InputVerifyCodeVC.h"
#import "ChangePwdVC.h"
#import "SMLoginAnimation.h"


@interface ForgetPwdVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfAccount;
@property (weak, nonatomic) IBOutlet UIButton *btResetpwd;
@property (weak, nonatomic) IBOutlet UILabel *lbAlert;
@property (weak, nonatomic) IBOutlet BarUnderLoginTextInputLine *line1;

@end

@implementation ForgetPwdVC

+ (void)getCtrllerFrom:(UIViewController *)ctrller account:(NSString *)account {
    ForgetPwdVC *vc = [ForgetPwdVC getCtrllerFromStory:@"SMSHLogin" bundle:[NSBundle bundleForClass:self.class] controllerIdentifier:@"ForgetPwdVC"] ;
    vc.account = account ;
    [ctrller.navigationController pushViewController:vc animated:YES] ;
}

- (IBAction)btResetpwdOnClick:(id)sender {
    [SMLoginAnimation zoomAndFade:sender complete:^{
        [self actionBbtResetpwdOnClick] ;
    }] ;
}

- (void)actionBbtResetpwdOnClick {
    [_tfAccount resignFirstResponder] ;
    
    _lbAlert.hidden = YES ;
    BOOL valided = NO ;
    valided = [self isValidUsername:_tfAccount.text] ;
    if (!valided) {
        _lbAlert.hidden = NO ;
        return;
    }
    
    if ([self.tfAccount.text containsString:@"@"]) {
        // email
        @weakify(self)
        [InputVerifyCodeVC showFromCtrller:self mobile:nil email:self.tfAccount.text scenceType:InputVerifyCodeVCType_changePassword completion:^(BOOL success, NSString *code, InputVerifyCodeVC *ivcCtrller) {
            if (!success) return ;
            
            @strongify(self)
            [ChangePwdVC showFromCtrller:self
                                 account:self.tfAccount.text
                                  verify:code] ;
        }] ;
    }
    else {
        // mobile
        @weakify(self)
        [InputVerifyCodeVC showFromCtrller:self mobile:self.tfAccount.text email:nil scenceType:InputVerifyCodeVCType_changePassword completion:^(BOOL success, NSString *code, InputVerifyCodeVC *ivcCtrller) {
            if (!success) return ;
            
            @strongify(self)
            [ChangePwdVC showFromCtrller:self
                                 account:self.tfAccount.text
                                  verify:code] ;
        }] ;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.lbAlert.hidden = YES ;
    self.tfAccount.text = self.account ;
    
    RACSignal *validUsernameSignal = [self.tfAccount.rac_textSignal map:^id(NSString *text) {
        return @([self isValidUsername:text]) ;
    }];

    [validUsernameSignal subscribeNext:^(NSNumber  *x) {
        BOOL valid = [x boolValue] ;
        self.btResetpwd.backgroundColor = valid ? UIColorRGB(65, 70, 75) : UIColorRGBA(65, 70, 75,.35) ;
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
        [self btResetpwdOnClick:nil] ;
    }];

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
    return result ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tfAccount resignFirstResponder];
    
    self.lbAlert.hidden = [self isValidUsername:self.tfAccount.text] ;
}




@end
