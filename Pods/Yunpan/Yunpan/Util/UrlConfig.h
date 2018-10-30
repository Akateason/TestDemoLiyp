//
//  UrlConfig.h
//  Yunpan
//
//  Created by teason23 on 2018/9/11.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XTlib.h>

@interface UrlConfig : NSObject
XT_SINGLETON_H(UrlConfig)

- (NSString *)UrlAppend:(NSString *)partUrlStr ;
- (void)setup ;

@end
