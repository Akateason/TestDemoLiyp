//
//  UIImage+Yunpan.h
//  Yunpan
//
//  Created by teason23 on 2018/11/2.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Yunpan)
+ (UIImage *)shmyp_imageNamed:(NSString *)name
              fromBundleClass:(Class)cls ;
@end

NS_ASSUME_NONNULL_END
