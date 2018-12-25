//
//  SMSHRegistVC.h
//  SMSHLogin
//
//  Created by teason23 on 2018/12/6.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "SMLoginRootVC.h"
#import "SMLoginAnimation.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    RegistType_Mobile = -1,
    RegistType_Email = 1,
} SMSHRegistType ;

@interface SMSHRegistVC : SMLoginRootVC
@property (weak, nonatomic) IBOutlet UILabel *lbServeLawty;
@property (weak, nonatomic) IBOutlet UILabel *lbTitleOfAccount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftFlexOfTfAccount;
@property (weak, nonatomic) IBOutlet UITextField *tfAccount;
@property (weak, nonatomic) IBOutlet UILabel *lb86;
@property (weak, nonatomic) IBOutlet UIView *lbSepOf86;

@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btShowPassword;
@property (weak, nonatomic) IBOutlet UIView *btSepOfShowPassword;
@property (weak, nonatomic) IBOutlet UILabel *lbAlert;

@property (weak, nonatomic) IBOutlet UIButton *btSwithRegistWay;
@property (weak, nonatomic) IBOutlet UIButton *btSendCode;
@property (weak, nonatomic) IBOutlet BarUnderLoginTextInputLine *line1;
@property (weak, nonatomic) IBOutlet BarUnderLoginTextInputLine *line2;

// vm
@property (nonatomic) SMSHRegistType vType ;

@end

NS_ASSUME_NONNULL_END
