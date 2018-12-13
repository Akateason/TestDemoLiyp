//
//  YPFiles+Sort.m
//  Yunpan
//
//  Created by teason23 on 2018/10/11.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPFiles+Sort.h"
#import <XTlib/XTlib.h>

@implementation YPFiles (Sort)


+ (NSArray <YPFiles *> *)arraySortedByUpdatedAt:(NSArray <YPFiles *> *)array order:(BOOL)ascOrDesc {
    return [array sortedArrayUsingComparator:^NSComparisonResult(YPFiles *obj1, YPFiles *obj2) {
        
        NSDate *date1 = [NSDate xt_getDateWithStr:obj1.updatedAt format:kTIME_STR_FORMAT_ISO8601] ;
        NSDate *date2 = [NSDate xt_getDateWithStr:obj2.updatedAt format:kTIME_STR_FORMAT_ISO8601] ;
        if (ascOrDesc) {
            return [date1 compare:date2] ;
        }
        else {
            return [date1 compare:date2] * -1 ;
        }
        
    }] ;
}

+ (NSArray <YPFiles *> *)arraySortedByCreatedAt:(NSArray <YPFiles *> *)array order:(BOOL)ascOrDesc {
    return [array sortedArrayUsingComparator:^NSComparisonResult(YPFiles *obj1, YPFiles *obj2) {
        
        NSDate *date1 = [NSDate xt_getDateWithStr:obj1.createdAt format:kTIME_STR_FORMAT_ISO8601] ;
        NSDate *date2 = [NSDate xt_getDateWithStr:obj2.createdAt format:kTIME_STR_FORMAT_ISO8601] ;
        if (ascOrDesc) {
            return [date1 compare:date2] ;
        }
        else {
            return [date1 compare:date2] * -1 ;
        }
        
    }] ;
}

+ (NSArray <YPFiles *> *)arraySortedBySizeAt:(NSArray <YPFiles *> *)array order:(BOOL)ascOrDesc {
    return [array sortedArrayUsingComparator:^NSComparisonResult(YPFiles *obj1, YPFiles *obj2) {
        
        if (obj1.size > obj2.size) {
            return ascOrDesc ? NSOrderedDescending : NSOrderedAscending ;
        }
        else {
            return !ascOrDesc ? NSOrderedDescending : NSOrderedAscending ;
        }
        
    }] ;
}

+ (NSArray <YPFiles *> *)arraySortedByFileNameAt:(NSArray <YPFiles *> *)array order:(BOOL)ascOrDesc {
    return [array sortedArrayUsingComparator:^NSComparisonResult(YPFiles *obj1, YPFiles *obj2) {
        
        if ([[obj1.py capitalizedString] compare:[obj2.py capitalizedString]] == NSOrderedDescending) {
            return ascOrDesc ? NSOrderedDescending : NSOrderedAscending ;
        }
        else {
            return !ascOrDesc ? NSOrderedDescending : NSOrderedAscending ;
        }
        
    }] ;
}

+ (NSArray <YPFiles *> *)arraySortedByAuthor:(NSArray <YPFiles *> *)array {
    NSMutableDictionary *map = [NSMutableDictionary dictionary] ;
    [array enumerateObjectsUsingBlock:^(YPFiles * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *tmpList = [map[@(obj.ownerId).stringValue] mutableCopy] ;
        tmpList = tmpList ?: [@[] mutableCopy] ;
        [tmpList addObject:obj] ;
        [map setObject:tmpList forKey:@(obj.ownerId).stringValue] ;
    }] ;
    
    NSMutableArray *result = [@[] mutableCopy] ;
    for (NSString *key in map.allKeys) {
        [result addObjectsFromArray:map[key]] ;
    }
    return result ;
}


@end
