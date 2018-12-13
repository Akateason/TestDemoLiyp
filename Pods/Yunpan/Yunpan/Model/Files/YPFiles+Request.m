//
//  YPFiles+Request.m
//  Yunpan
//
//  Created by teason23 on 2018/9/20.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPFiles+Request.h"
#import <XTReq/XTReq.h>
#import "UrlConfig.h"
#import <YYModel/YYModel.h>
#import "UploadRecordTB.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "YPMemberInfo.h"
#import "SHMDriveSDK.h"





@implementation YPFiles (Request)

+ (NSDictionary *)getTokenHeader {
  return @{
           @"X-Shimo-API-Token" : [[SHMDriveSDK sharedInstance].delegate tokenString] ,
           @"Origin"            : kSHMDriveSDK_isDevEnviroment ? @"https://shimodev.com" : @"https://shimo.im" ,
           @"Authorization"     : [@"Bearer " stringByAppendingString:[[SHMDriveSDK sharedInstance].delegate tokenString]] ,
           } ;
}

/**
 根据 GUID 获取文件（夹）信息  /files/{guid}
 @param guid 必须
 @param password 文件密码 x-password
 */
+ (void)getInfoWithGuid:(NSString *)guid
               password:(NSString *)password
               complete:(void(^)(YPFiles *aFile))completion {
    
    if (!guid) return ;
    
    NSString *url = [[UrlConfig sharedInstance] UrlAppend:STR_FORMAT(@"/files/%@",guid)] ;
    XT_GET_PARAM
    [param setObject:guid forKey:@"guid"] ;
    if (password) [param setObject:password forKey:@"x-password"] ;
    
    [XTRequest reqWithUrl:url mode:XTRequestMode_GET_MODE header:kMutableYPHeader parameters:param rawBody:nil hud:NO success:^(id json, NSURLResponse *response) {
        
        YPFiles *afile = [YPFiles yy_modelWithJSON:json] ;
        completion(afile) ;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil) ;
    }] ;
}

/**
 获取子文件，文件夹 /files
 @param parentGuid 父文件夹 GUID ，如果要获取顶层目录的子文件/文件夹，则不传
 */
+ (void)getFilesListWithParentGuid:(NSString *)parentGuid
                          complete:(void(^)(NSArray *list))completion {
    
    parentGuid = parentGuid ?: @"" ;
    NSString *url = [[UrlConfig sharedInstance] UrlAppend:@"/files"] ;
    
    [XTRequest reqWithUrl:url mode:XTRequestMode_GET_MODE header:kMutableYPHeader parameters:@{@"parentGuid":parentGuid} rawBody:nil hud:NO success:^(id json, NSURLResponse *response) {
        NSArray *list = [NSArray yy_modelArrayWithClass:[YPFiles class] json:json] ;
        completion(list) ;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil) ;
    }] ;
}


/**
 创建文件夹 POST /files
 "name": "string",
 "parentGuid": "string"
 */
+ (void)createFolderWithName:(NSString *)name
                  parentGuid:(NSString *)guid
                    complete:(void(^)(YPFiles *aFile))completion {
    
    NSString *url = [[UrlConfig sharedInstance] UrlAppend:@"/files"] ;
    XT_GET_PARAM
    [param setObject:name forKey:@"name"] ;
    if (guid) [param setObject:guid forKey:@"parentGuid"] ;
    
    [XTRequest reqWithUrl:url mode:XTRequestMode_POST_MODE header:kMutableYPHeader parameters:nil rawBody:[param yy_modelToJSONString] hud:NO success:^(id json, NSURLResponse *response) {
        YPFiles *afile = [YPFiles yy_modelWithJSON:json] ;
        completion(afile) ;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil) ;
    }] ;
}

/**
 批量删除文件，文件夹，所以待删除的文件（夹）必须属于同一父目录
 */
+ (void)deleteFilesWithGuids:(NSArray *)guids
                    complete:(void(^)(bool bOk))completion {
    
    if (!guids || !guids.count) return ;
    
    NSString *url = [[UrlConfig sharedInstance] UrlAppend:@"/files"] ;
    NSDictionary *dic = @{@"guids":guids} ;
    NSMutableDictionary *header = kMutableYPHeader ;
    [header setObject:@"application/json" forKey:@"Content-Type"] ;
    
    NSString *jsonString = [dic yy_modelToJSONString] ;
    [XTRequest reqWithUrl:url mode:XTRequestMode_DELETE_MODE header:header parameters:nil rawBody:jsonString hud:NO success:^(id json, NSURLResponse *response) {
        completion(YES) ;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO) ;
    }] ;
}



/**
 上传
 @param rec     uploadrecord
 */
+ (void)fileUploadWithUploadRec:(UploadRecordTB *)rec
                       progress:(void(^)(double progressVal))progressValueBlock
                       complete:(void(^)(YPFiles *aFile))completion {
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:rec.pathInLocal] ;
    [self fileUploadWithFileName:rec.fileName parentGuid:rec.parentGuid fileType:rec.mimeType file:data progress:progressValueBlock complete:^(YPFiles * _Nonnull aFile) {
        
        [XTFileManager deleteFile:rec.pathInLocal] ;
        if (completion) completion(aFile) ;
    }] ;
}

/**
 流式上传，请求头中的 Content-Type 须为 application/octet-stream
 /files/upload
 @param fileName        query string            aaa.jpg
 @param parentGuid      x-file-parent-guid
 @param fileType        x-file-type
 param size             x-file-size   byte
 @parem theFileData     data
 */
+ (void)fileUploadWithFileName:(NSString *)fileName
                    parentGuid:(NSString *)parentGuid
                      fileType:(NSString *)fileType
                          file:(NSData *)theFileData
                      progress:(void(^)(double progressVal))progressValueBlock
                      complete:(void(^)(YPFiles *aFile))completion {
    
    NSInteger fileSize = theFileData.length ;
    NSLog(@"%@", [[NSByteCountFormatter new] stringFromByteCount:fileSize]) ;
    
    NSString *url = [[UrlConfig sharedInstance] UrlAppend:STR_FORMAT(@"/files/upload?encodedFileName=%@",[fileName URLEncodedString])] ;
    NSLog(@"url : %@",url) ;
    
    NSMutableDictionary *header = kMutableYPHeader ;
    [header setObject:@"application/octet-stream" forKey:@"Content-Type"] ;
    if (parentGuid || !parentGuid.length) [header setValue:parentGuid forKey:@"x-file-parent-guid"] ;
    [header setObject:fileType forKey:@"x-file-type"] ;
    [header setObject:@(fileSize).stringValue forKey:@"x-file-size"] ;
    
    [XTRequest uploadFileWithData:theFileData urlStr:url header:header progress:^(float proVal) {
        NSLog(@"xtreq progress : %lf",proVal) ;
        if (progressValueBlock) progressValueBlock(proVal) ;
    } success:^(NSURLResponse *response, id responseObject) {
        completion([YPFiles yy_modelWithJSON:responseObject]) ;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil) ;
    }] ;
     
}


/**
 下载文件，用于支持浏览器缓存
 @param guid 必须
 param isReturnSignedURL 不传这个参数，返回时是 302 重定向到下载地址. 写死
 @param savePath s
 */
+ (void)downloadFileWithGuid:(NSString *)guid
                    savePath:(NSString *)savePath
                    progress:(void(^)(float progressVal))progressBlock
                    complete:(void(^)(BOOL success))completion {
    
    NSString *url = [[UrlConfig sharedInstance] UrlAppend:STR_FORMAT(@"/files/%@/download",guid)] ;
    
    [XTRequest downLoadFileWithSavePath:savePath fromUrlString:url header:kMutableYPHeader downLoadProgress:^(float progressVal) {
        if (progressBlock) progressBlock(progressVal) ;
    } success:^(id response, id dataFile) {
        completion(YES) ;
    } failure:^(NSURLSessionDownloadTask *task, NSError *error) {
        completion(NO) ;
    }] ;
}


/**
 重命名文件，文件夹
 PUT
 /files/{guid}/name
 @param guid s
 @param name body
 */
+ (void)renameFolderWithGuid:(NSString *)guid
                     newName:(NSString *)name
                    complete:(void(^)(BOOL sucess))completion {
    
    NSString *url = [[UrlConfig sharedInstance] UrlAppend:STR_FORMAT(@"/files/%@/name",guid)] ;
    [XTRequest reqWithUrl:url mode:XTRequestMode_PUT_MODE header:kMutableYPHeader parameters:nil rawBody:[@{@"name":name} yy_modelToJSONString] hud:NO success:^(id json, NSURLResponse *response) {
        
        if (!json)
            completion(YES) ;
        else
            completion(NO) ;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO) ;
    }] ;
}


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
                              complete:(void(^)(BOOL bSuccess))completion {
    
    NSString *url = [[UrlConfig sharedInstance] UrlAppend:@"/files/move"] ;
    
    XT_GET_PARAM
    [param setObject:parentGuid forKey:@"parentGuid"] ;
    [param setObject:guids forKey:@"guids"] ;

    [XTRequest reqWithUrl:url mode:XTRequestMode_PUT_MODE header:kMutableYPHeader parameters:nil rawBody:[param yy_modelToJSONString] hud:NO success:^(id json, NSURLResponse *response) {
        if (!json) {
            completion(YES) ;
        }
        else {
            completion(NO) ;
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO) ;
//        [SVProgressHUD showErrorWithStatus:STR_FORMAT(@"错误: %@ %@",response[@"message"],response[@"name"])] ;
    }] ;
}


/**
 复制文件，目前不支持文件夹 /files/copy
 @param guids       body
 @param parentGuid  body
 */
+ (void)copyFiles:(NSArray *)guids
       parentGuid:(NSString *)parentGuid
         complete:(void(^)(BOOL bSuccess))completion {

    NSString *url = [[UrlConfig sharedInstance] UrlAppend:@"/files/copy"] ;
    XT_GET_PARAM
    [param setObject:guids forKey:@"guids"] ;
    [param setObject:parentGuid forKey:@"parentGuid"] ;
    
    [XTRequest reqWithUrl:url mode:XTRequestMode_POST_MODE header:kMutableYPHeader parameters:nil rawBody:[param yy_modelToJSONString] hud:NO success:^(id json, NSURLResponse *response) {
        if (json) {
            completion(YES) ;
        }
        else {
            completion(NO) ;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO) ;
    }] ;
}


/**
 获取被共享者列表 接口不包含所有者. 需要手动添加上所有者.
 @param guid folder
 @param completion 被共享这信息列表，roleId 为 -1 则是被共享者，-2 则是管理员
 */
+ (void)getFilesMembersWithGuid:(NSString *)guid
                    fileOwnerId:(NSInteger)fileOwnerId
                       complete:(void(^)(NSArray<CooperMemberRelate *> *memberlist))completion {
    
    if (!guid) return ;
    
    NSString *url = [[UrlConfig sharedInstance] UrlAppend:STR_FORMAT(@"/files/%@/members",guid)] ;
    [XTRequest reqWithUrl:url mode:XTRequestMode_GET_MODE header:kMutableYPHeader parameters:nil rawBody:nil hud:NO success:^(id json, NSURLResponse *response) {
        
        NSArray *cooperRelateList = [NSArray yy_modelArrayWithClass:[CooperMemberRelate class] json:json] ;
        CooperMemberRelate *owner = [CooperMemberRelate new] ;
        owner.userId = fileOwnerId ;
        
        NSMutableArray *tmplist = [@[owner] mutableCopy] ;
        [tmplist addObjectsFromArray:cooperRelateList] ;
        completion(tmplist) ;

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil) ;
    }] ;
}



/**
 更新被共享者信息
 @param guid            file or folder
 @param addMemberIds    待添加的共享者 User ID 列表，若无则传递空数组
 @param removeMemberIds 待移除的共享者 User ID 列表，若无则传递空数组
 */
+ (void)updateMembersWithGuid:(NSString *)guid
                 addMemberIds:(NSArray *)addMemberIds
              removeMemberIds:(NSArray *)removeMemberIds
                     complete:(void(^)(BOOL success))completion {
    
    if (!guid) return ;
    
    NSString *url = [[UrlConfig sharedInstance] UrlAppend:STR_FORMAT(@"/files/%@/members",guid)] ;
    NSMutableDictionary *param = [@{} mutableCopy] ;
    if (!addMemberIds) addMemberIds = @[] ;
    [param setObject:addMemberIds forKey:@"addMemberIds"] ;
    if (!removeMemberIds) removeMemberIds = @[] ;
    [param setObject:removeMemberIds forKey:@"removeMemberIds"] ;
    
    NSMutableDictionary *header = kMutableYPHeader ;
    [header setObject:@"application/json" forKey:@"Content-Type"] ;
    
    [XTRequest reqWithUrl:url mode:XTRequestMode_PUT_MODE header:header parameters:nil rawBody:[param yy_modelToJSONString] hud:NO completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            NSDictionary *dic = responseObject ;
            if ([dic[@"name"] isEqualToString:@"containShortcutsInFolder"]) {
                [SVProgressHUD showErrorWithStatus:@"子文件夹已有协作者"] ;
            }
            
            completion(NO) ;
        }
        else {
            completion(YES) ;
        }
    }] ;
}



/**
 拿公司所有的员工 按时间缓存
 */
// https://shimodev.com/lizard-api/ 测试
// https://shimo.im/lizard-api/ 生产是这个
+ (void)getAllMembersComplete:(void(^)(NSArray<YPMemberInfo *> *memberList))completion {
    
    NSString *url = kSHMDriveSDK_isDevEnviroment
    ?
    @"https://shimodev.com/lizard-api/teams/mine/members?perPage=99999"
    :
    @"https://shimo.im/lizard-api/teams/mine/members?perPage=99999" ;
    
    NSMutableDictionary *header = kMutableYPHeader ;
    if (kSHMDriveSDK_isDevEnviroment) {
        [header setObject:@"http://local.shimodev.com:4000" forKey:@"Origin"] ;
    }
    else {
        [header setObject:@"https://shimo.im" forKey:@"Origin"] ;
    }
    
    [XTCacheRequest cachedReq:XTRequestMode_GET_MODE url:url hud:NO header:header param:nil body:nil policy:XTReqPolicy_OverTime_WaitReturn overTimeIfNeed:60 * 5 judgeResult:^XTReqSaveJudgment(BOOL isNewest, id json) {
        NSArray *list = [NSArray yy_modelArrayWithClass:[YPMemberInfo class] json:json] ;
        completion(list) ;
        return (list && list.count) ? XTReqSaveJudgment_willSave : XTReqSaveJudgment_NotSave ;
    }] ;
}

@end
