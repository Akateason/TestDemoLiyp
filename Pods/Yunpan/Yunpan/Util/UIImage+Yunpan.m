//
//  UIImage+Yunpan.m
//  Yunpan
//
//  Created by teason23 on 2018/11/2.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "UIImage+Yunpan.h"

@implementation UIImage (Yunpan)

+ (UIImage *)shmyp_imageNamed:(NSString *)name
        fromBundleClass:(Class)cls {
//    return [UIImage imageNamed:name] ;
    return [UIImage imageNamed:name inBundle:[NSBundle bundleForClass:cls] compatibleWithTraitCollection:nil] ;
}


@end
