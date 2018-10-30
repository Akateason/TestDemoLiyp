//
//  YPFiles+Sort.h
//  Yunpan
//
//  Created by teason23 on 2018/10/11.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPFiles.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPFiles (Sort)

// desc - NO . asc - YES
+ (NSArray <YPFiles *> *)arraySortedByUpdatedAt:(NSArray <YPFiles *> *)array order:(BOOL)ascOrDesc ;
+ (NSArray <YPFiles *> *)arraySortedByCreatedAt:(NSArray <YPFiles *> *)array order:(BOOL)ascOrDesc ;
+ (NSArray <YPFiles *> *)arraySortedBySizeAt:(NSArray <YPFiles *> *)array order:(BOOL)ascOrDesc ;
+ (NSArray <YPFiles *> *)arraySortedByFileNameAt:(NSArray <YPFiles *> *)array order:(BOOL)ascOrDesc ;
+ (NSArray <YPFiles *> *)arraySortedByAuthor:(NSArray <YPFiles *> *)array ;

@end

NS_ASSUME_NONNULL_END
