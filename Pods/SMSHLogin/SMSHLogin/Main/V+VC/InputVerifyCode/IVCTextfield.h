//
//  IVCTextfield.h
//  SMSHLogin
//
//  Created by teason23 on 2018/12/5.
//  Copyright © 2018 teason23. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class IVCTextfield;
@protocol IVCTextFieldDelegate <NSObject>
- (void)xt_textFieldDeleteBackward:(IVCTextfield *)textField;
@end


@interface IVCTextfield : UITextField
@property (nonatomic, weak) id <IVCTextFieldDelegate> xt_delegate;

@end

NS_ASSUME_NONNULL_END
