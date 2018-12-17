//
//  GeetestUtil.h
//  SMSHLogin
//
//  Created by teason23 on 2018/12/10.
//  Copyright © 2018 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XTBase/XTBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface GeetestUtil : NSObject
XT_SINGLETON_H(GeetestUtil)
- (void)startGTViewBlkComplete:(void(^)(NSDictionary *resultDic))completion ;
@end

NS_ASSUME_NONNULL_END
