//
//  YPFiles+Request.h
//  Yunpan
//
//  Created by teason23 on 2018/9/20.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPFiles.h"

NS_ASSUME_NONNULL_BEGIN

@class UploadRecordTB,YPMemberInfo,CooperMemberRelate ;

#define kMutableYPHeader                    [[YPFiles getTokenHeader] mutableCopy]

@interface YPFiles (Request)

+ (NSDictionary *)getTokenHeader ;

/**
 根据 GUID 获取文件（夹）信息  /files/{guid}
 @param guid 必须
 @param password 文件密码 x-password
 */
+ (void)getInfoWithGuid:(NSString *)guid
               password:(NSString *)password
               complete:(void(^)(YPFiles *aFile))completion ;

/**
 获取子文件，文件夹 /files
 @param parentGuid 父文件夹 GUID ，如果要获取顶层目录的子文件/文件夹，则不传
 */
+ (void)getFilesListWithParentGuid:(NSString *)parentGuid
                          complete:(void(^)(NSArray *list))completion ;


/**
 创建文件夹 POST /files
 "name": "string",
 "parentGuid": "string"
 */
+ (void)createFolderWithName:(NSString *)name
                  parentGuid:(NSString *)guid
                    complete:(void(^)(YPFiles *aFile))completion ;

/**
 批量删除文件，文件夹
 code 204 删除成功
 */
+ (void)deleteFilesWithGuids:(NSArray *)guids
                    complete:(void(^)(bool bOk))completion ;

/**
 上传
 @param rec     uploadrecord
 */
+ (void)fileUploadWithUploadRec:(UploadRecordTB *)rec
                       progress:(void(^)(double progressVal))progressValueBlock
                       complete:(void(^)(YPFiles *aFile))completion ;

/**
 流式上传，请求头中的 Content-Type 须为 application/octet-stream
 /files/upload
 @param fileName        query string            aaa.jpg
 @param parentGuid      x-file-parent-guid
 @param fileType        x-file-type             image/jpeg
 param size             x-file-size   byte
 @parem theFileData     data
 */
+ (void)fileUploadWithFileName:(NSString *)fileName
                    parentGuid:(NSString *)parentGuid
                      fileType:(NSString *)fileType
                          file:(NSData *)theFileData
                      progress:(void(^)(double progressVal))progressValueBlock
                      complete:(void(^)(YPFiles *aFile))completion ;


/**
 下载文件，用于支持浏览器缓存
 @param guid 必须
 param isReturnSignedURL 不传这个参数，返回时是 302 重定向到下载地址. 写死
 @param savePath s
 */
+ (void)downloadFileWithGuid:(NSString *)guid
                    savePath:(NSString *)savePath
                    progress:(void(^)(float progressVal))progressBlock
                    complete:(void(^)(BOOL success))completion ;

/**
 重命名文件，文件夹
 PUT
 /files/{guid}/name
 */
+ (void)renameFolderWithGuid:(NSString *)guid
                     newName:(NSString *)name
                    complete:(void(^)(BOOL sucess))completion ;

/**
 批量移动文件，文件夹位置
 @param parentGuid s
 @param guids string 数组
 {
 "parentGuid": "string",
 "guids": "string"
 } body
 */
+ (void)moveFileOrFolderWithParentGuid:(NSString *)parentGuid
                                 guids:(NSArray *)guids
                              complete:(void(^)(BOOL bSuccess))completion ;

/**
 复制文件，目前不支持文件夹 /files/copy
 @param guids       body
 @param parentGuid  body
 */
+ (void)copyFiles:(NSArray *)guids
       parentGuid:(NSString *)parentGuid
         complete:(void(^)(BOOL bSuccess))completion ;


#pragma mark - 共享

/**
 获取被共享者列表 接口不包含所有者. 需要手动添加.
 @param guid folder
 @param completion 被共享这信息列表，roleId 为 -1 则是被共享者，-2 则是管理员
 */
+ (void)getFilesMembersWithGuid:(NSString *)guid
                    fileOwnerId:(NSInteger)fileOwnerId
                       complete:(void(^)(NSArray<CooperMemberRelate *> *memberlist))completion ;

/**
 更新被共享者信息
 @param guid            file or folder
 @param addMemberIds    待添加的共享者 User ID 列表，若无则传递空数组
 @param removeMemberIds 待移除的共享者 User ID 列表，若无则传递空数组
 */
+ (void)updateMembersWithGuid:(NSString *)guid
                 addMemberIds:(NSArray *)addMemberIds
              removeMemberIds:(NSArray *)removeMemberIds
                     complete:(void(^)(BOOL success))completion ;

/**
 拿公司所有的员工 按时间缓存
 */
// https://shimodev.com/lizard-api/ 测试
// https://shimo.im/lizard-api/ 生产是这个
+ (void)getAllMembersComplete:(void(^)(NSArray<YPMemberInfo *> *memberList))completion ;

@end

NS_ASSUME_NONNULL_END
