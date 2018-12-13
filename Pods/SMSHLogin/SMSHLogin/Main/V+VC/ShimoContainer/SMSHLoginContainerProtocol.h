//
//  SMSHLoginContainerProtocol.h
//  SMSHLogin
//
//  Created by teason23 on 2018/12/4.
//  Copyright © 2018 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SMSHLoginContainerProtocol <NSObject>
- (void)checkoutButtonClick:(int)idx ;
- (UIViewController *)outsideCtrller ;
@end

NS_ASSUME_NONNULL_END
