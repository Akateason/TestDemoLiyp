//
//  ForgetPwdVC.h
//  SMSHLogin
//
//  Created by teason23 on 2018/12/4.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "SMLoginRootVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ForgetPwdVC : SMLoginRootVC
@property (copy, nonatomic) NSString *account ;
+ (void)getCtrllerFrom:(UIViewController *)ctrller
               account:(NSString *)account ;

@end

NS_ASSUME_NONNULL_END
