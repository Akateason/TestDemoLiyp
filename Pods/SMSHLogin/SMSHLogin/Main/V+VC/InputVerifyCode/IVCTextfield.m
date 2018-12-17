//
//  IVCTextfield.m
//  SMSHLogin
//
//  Created by teason23 on 2018/12/5.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "IVCTextfield.h"

@implementation IVCTextfield
- (void)deleteBackward {
    [super deleteBackward];
    
    if ([self.xt_delegate respondsToSelector:@selector(xt_textFieldDeleteBackward:)]) {
        [self.xt_delegate xt_textFieldDeleteBackward:self];
    }
}
@end
