//
//  ShimoVerifyLoginVC.h
//  SMSHLogin
//
//  Created by teason23 on 2018/12/4.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "SMLoginRootVC.h"
#import "SMSHLoginContainerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShimoVerifyLoginVC : SMLoginRootVC
@property (weak, nonatomic) id <SMSHLoginContainerProtocol> delegate ;

@end

NS_ASSUME_NONNULL_END
