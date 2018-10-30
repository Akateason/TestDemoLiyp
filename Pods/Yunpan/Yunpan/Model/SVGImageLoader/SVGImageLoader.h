//
//  SVGImageLoader.h
//  Yunpan
//
//  Created by teason23 on 2018/10/12.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVGImageLoader : UIWebView

+ (SVGImageLoader *)setupWithFrame:(CGRect)frame ;

- (void)startLoadWithUrlStr:(NSString *)urlStr
                     header:(NSDictionary *)header ;
    
@end

NS_ASSUME_NONNULL_END
