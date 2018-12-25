//
//  SMLoginAnimation.h
//  SMSHLogin
//
//  Created by teason23 on 2018/12/17.
//  Copyright © 2018 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface SMLoginAnimation : NSObject
+ (void)zoomAndFade:(UIView *)item
           complete:(void(^)(void))complete ;

@end






@interface BarUnderLoginTextInputLine : UIView
- (void)startMove ;
- (void)resetMove ;
@end
NS_ASSUME_NONNULL_END
