//
//  ChangePwdVC.h
//  SMSHLogin
//
//  Created by teason23 on 2018/12/5.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "SMLoginRootVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangePwdVC : SMLoginRootVC
@property (weak, nonatomic) IBOutlet UILabel *lbAccount;
@property (weak, nonatomic) IBOutlet UITextField *tfpw1;
@property (weak, nonatomic) IBOutlet UIButton *btShowpwd1;
@property (weak, nonatomic) IBOutlet UILabel *lbAlert1;
@property (weak, nonatomic) IBOutlet UITextField *tfpw2;
@property (weak, nonatomic) IBOutlet UIButton *btShowpwd2;
@property (weak, nonatomic) IBOutlet UILabel *lbAlert2;
@property (weak, nonatomic) IBOutlet UIButton *btConfirm;
@property (weak, nonatomic) IBOutlet UIView *sep1;
@property (weak, nonatomic) IBOutlet UIView *sep2;

@property (strong, nonatomic) NSString *account ;
@property (strong, nonatomic) NSString *verifyCode ;

+ (void)showFromCtrller:(UIViewController *)ctrller
                account:(NSString *)account
                 verify:(NSString *)verifyCode ;



@end

NS_ASSUME_NONNULL_END
