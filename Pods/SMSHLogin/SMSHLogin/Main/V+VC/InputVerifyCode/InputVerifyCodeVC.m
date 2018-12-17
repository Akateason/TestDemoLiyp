//
//  InputVerifyCodeVC.m
//  SMSHLogin
//
//  Created by teason23 on 2018/12/4.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "InputVerifyCodeVC.h"
#import <XTBase/XTBase.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "IVCTextfield.h"
#import "SMSHLoginAPIs.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ChangePwdVC.h"


@interface InputVerifyCodeVC () <IVCTextFieldDelegate>
@property (copy, nonatomic)     NSString *mobile ;
@property (copy, nonatomic)     NSString *email ;
/**
 login/change_password/change_mobile/bind/register/authentication
 用途：登录/修改密码/修改手机号/绑定/注册/安全验证
 */
@property (nonatomic)           InputVerifyCodeVCType scenceType ;
@property (copy, nonatomic)     VerifyCodeCompletion blkVerifyCodeCompletion ;

@property (strong, nonatomic)   IVCTextfield *tfFake ;
@property (nonatomic)           BOOL isfirsttime ;

@end

@implementation InputVerifyCodeVC



#pragma mark - action

- (IBAction)btReSendOnClick:(id)sender {
    // send verify code
    WEAK_SELF
    if (self.mobile.length) {
        [SMSHLoginAPIs sendVerificationCodeWithType:@"sms" mobile:self.mobile scenes:[self stringOfScence] geetestDic:nil complete:^(BOOL bSuccess) {
            if (bSuccess) [weakSelf countdownTheBUtton] ;
        }] ;
    }
    else if (self.email.length) {
        [SMSHLoginAPIs sendEmailCodeWithEmail:self.email scences:[self stringOfScence] geetestDic:nil complete:^(BOOL bSuccess) {
            if (bSuccess) [weakSelf countdownTheBUtton] ;
        }];
    }
}

+ (void)showFromCtrller:(UIViewController *)ctrller
                 mobile:(NSString *)mobile
                  email:(NSString *)email
             scenceType:(InputVerifyCodeVCType)scenctType
             completion:(VerifyCodeCompletion)completion {
    
    InputVerifyCodeVC *vc = [InputVerifyCodeVC getCtrllerFromStory:@"SMSHLogin" bundle:[NSBundle bundleForClass:self.class] controllerIdentifier:@"InputVerifyCodeVC"];
    vc.mobile = mobile;
    vc.email = email;
    vc.scenceType = scenctType;
    vc.blkVerifyCodeCompletion = completion;
    [ctrller.navigationController pushViewController:vc animated:YES];
    
    if (mobile.length) {
        [SMSHLoginAPIs sendVerificationCodeWithType:@"sms" mobile:mobile scenes:[vc stringOfScence] geetestDic:nil complete:^(BOOL bSuccess) {}] ;
    }
    else if (email.length) {
        [SMSHLoginAPIs sendEmailCodeWithEmail:email scences:[vc stringOfScence] geetestDic:nil complete:^(BOOL bSuccess) {}];
    }
}

#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self)
    if (self.mobile.length) {
        //
        self.lbTipSend.text = @"验证码已发送至手机：" ;
        
        NSString *tenDigitNumber = self.mobile;
        tenDigitNumber = [tenDigitNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{4})(\\d{4})"
                                                                   withString:@"$1 $2 $3"
                                                                      options:NSRegularExpressionSearch
                                                                        range:NSMakeRange(0, [tenDigitNumber length])];
        tenDigitNumber = [@"+86 " stringByAppendingString:tenDigitNumber];
        self.lbMobile.text = tenDigitNumber;
        
        //
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:@"收不到短信验证码？获取语音验证"];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:UIColorRGB(115, 162, 227)
                              range:NSMakeRange(@"收不到短信验证码？获取".length, 4)];
        self.lbVoice.attributedText = AttributedStr;
        self.lbVoice.userInteractionEnabled = YES ;
        [self.lbVoice bk_whenTapped:^{
            @strongify(self)
            if (!self.btSendAgain.enabled) {
                [SVProgressHUD showWithStatus:@"请在倒计时结束后重试"];
                return ;
            }
            
            [SMSHLoginAPIs sendVerificationCodeWithType:@"voice" mobile:self.mobile scenes:[self stringOfScence] geetestDic:nil complete:^(BOOL bSuccess) {
                if (bSuccess) [SVProgressHUD showSuccessWithStatus:@"语音验证已发送"];
            }];
        }];
    }
    else if (self.email.length) {
        //
        self.lbTipSend.text = @"验证码已发送至邮箱：" ;
        self.lbMobile.text = self.email;
        
        self.lbVoice.hidden = YES ;
    }
    
    //
    self.lb1.text = self.lb2.text = self.lb3.text = self.lb4.text = @"";
    //
    
    [self.stackView bk_whenTapped:^{
        @strongify(self)
        self.tfFake.text = @"" ;
        self.lb1.text = self.lb2.text = self.lb3.text = self.lb4.text = @"";
        [self.tfFake becomeFirstResponder] ;
    }];
    
    //
    [[[self.tfFake.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length <= 4 ;
    }] throttle:0]
     subscribeNext:^(NSString * _Nullable x) {
         @strongify(self)
         [self writeDownYourLetters:x] ;
         
         if (x.length == 4) {
             [self.tfFake resignFirstResponder] ;
             
             [self checkVerifyCode] ;
         }
     }] ;
    
    //
    RAC(self.btSendAgain, backgroundColor) =
    [RACObserve(self.btSendAgain, enabled) map:^id _Nullable(id  _Nullable value) {
        return [value boolValue] ? UIColorRGB(65, 70, 75) : UIColorRGBA(65, 70, 75, .35) ;
    }] ;
    
    //
    [self countdownTheBUtton] ;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated] ;
    
    if (!_isfirsttime) {
        [self.tfFake becomeFirstResponder] ;
        _isfirsttime = YES ;
    }
}

- (void)countdownTheBUtton {
    self.btSendAgain.enabled = NO ;
    __block int oneMinute = 60 ;
    
    @weakify(self)
    [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] take:60] subscribeNext:^(NSDate * _Nullable x) {
        @strongify(self)
        oneMinute-- ;
        [self.btSendAgain setTitle:STR_FORMAT(@"%ds 后重新发送",oneMinute) forState:0] ;
        if (oneMinute <= 0) {
            [self.btSendAgain setTitle:@"重新发送" forState:0] ;
            self.btSendAgain.enabled = YES ;
        }
    }];
}

- (void)checkVerifyCode {
    if (self.scenceType == InputVerifyCodeVCType_register) {
        self.blkVerifyCodeCompletion(YES, self.tfFake.text, self) ;
        return;
    }
    
    @weakify(self)
    [SMSHLoginAPIs verifyVerificationCodeWithMobile:self.mobile orEmail:self.email scenes:[self stringOfScence] code:self.tfFake.text complete:^(BOOL bSuccess) {
        @strongify(self)
        self.blkVerifyCodeCompletion(bSuccess, self.tfFake.text, self) ;
    }];
}

- (void)writeDownYourLetters:(NSString *)string {
    int len = (int)string.length ;
    
    for (int i = 0; i < len; i++) {
        NSString *substr = [string substringWithRange:NSMakeRange(i, 1)] ;
        UILabel *lb = self.numsLbList[i];
        lb.text = substr ;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tfFake resignFirstResponder];
}

#pragma mark - IVCTextFieldDelegate

- (void)xt_textFieldDeleteBackward:(IVCTextfield *)textField {
    textField.text = @"";
    self.lb1.text = self.lb2.text = self.lb3.text = self.lb4.text = @"";
}

#pragma mark - props

- (IVCTextfield *)tfFake{
    if(!_tfFake){
        _tfFake = ({
            IVCTextfield * object = [[IVCTextfield alloc]init];
            object.xt_delegate = self ;
            [self.view addSubview:object] ;
            object.keyboardType = UIKeyboardTypeNumberPad ;
            [object mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(1, 1)) ;
                make.top.equalTo(self.view) ;
                make.left.equalTo(self.view.mas_right) ;
            }];
            object;
        });
    }
    return _tfFake;
}

- (NSString *)stringOfScence {
    return kARRAY_InputVerifyCodeVCType[self.scenceType] ;
}


@end
