//
//  YPFiles.h
//  Yunpan
//
//  Created by teason23 on 2018/9/20.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    YPFiles_DisplayType_Undefined = 1 , // 未知, 不能预览
    YPFiles_DisplayType_Preview_Fail ,  // 预览失败
    YPFiles_DisplayType_Folder ,
    YPFiles_DisplayType_Doc ,
    YPFiles_DisplayType_Sheet ,
    YPFiles_DisplayType_Image ,
    YPFiles_DisplayType_Ppt ,
    YPFiles_DisplayType_Pdf ,
    YPFiles_DisplayType_Music ,
    YPFiles_DisplayType_Wps ,
    YPFiles_DisplayType_Zip ,
    YPFiles_DisplayType_Video ,
    YPFiles_DisplayType_PS ,
    YPFiles_DisplayType_Sketch ,
    YPFiles_DisplayType_Ai ,
    YPFiles_DisplayType_Ae ,
} YPFiles_DisplayType ;


@interface YPFiles : NSObject

@property (nonatomic)       NSInteger   idFiles ; // id
@property (copy, nonatomic) NSString    *guid ;
@property (copy, nonatomic) NSString    *name ;
@property (nonatomic)       NSInteger   ownerId ;
@property (nonatomic)       NSInteger   nodeId ;
@property (nonatomic)       NSInteger   parentId ;
@property (nonatomic)       NSInteger   workspaceId ;
@property (nonatomic)       NSInteger   memberCount ;
@property (nonatomic)       NSInteger   shortcutCount ;
@property (copy, nonatomic) NSString    *thumbnailUrl ;
@property (copy, nonatomic) NSString    *previewUrl ;
@property (nonatomic)       BOOL        isDeleted ;
@property (nonatomic)       BOOL        isFolder ;
@property (nonatomic)       BOOL        hasPassword ;
@property (copy, nonatomic) NSString    *key ;
@property (copy, nonatomic) NSString    *shareType ; // 文件共享状态，可选择值有 "private"，"team"，"public"
@property (nonatomic)       NSInteger   size ;
@property (copy, nonatomic) NSString    *type ;     // e.g. image
@property (copy, nonatomic) NSString    *subtype ;  // e.g. jpeg
@property (copy, nonatomic) NSString    *py ;
@property (copy, nonatomic) NSString    *pinyin ;
@property (copy, nonatomic) NSString    *createdAt ;
@property (copy, nonatomic) NSString    *updatedAt ;


// vm
@property (nonatomic)       BOOL        isOnSelect ; // default is NO .
@property (nonatomic)       BOOL        isImageType ;
@property (nonatomic)       BOOL        isOfficeType ; // 是否三件套
@property (copy, nonatomic) NSString    *displayThumbNailStr ;
@property (nonatomic)       YPFiles_DisplayType displayType ;
@property (copy, nonatomic) NSString    *downloadUrl ;

@end

