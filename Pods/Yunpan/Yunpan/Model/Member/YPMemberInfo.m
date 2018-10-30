//
//  YPMemberInfo.m
//  Yunpan
//
//  Created by teason23 on 2018/9/26.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPMemberInfo.h"
#import "YPFiles+Request.h"

@implementation YPMemberInfo

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
                @"member_id" : @"id"
             } ;
}

/**
    协作者权限
 */
- (CooperateMemberAccessType)getCooperTypeOnFile:(YPFiles *)afile {
    
    CooperateMemberAccessType cType = CooperateMemberAccessType_ReadOnly ;
    
    if (afile.ownerId == self.member_id) {
        cType = CooperateMemberAccessType_Owner ;
    }
    else if ( [self.teamRole isEqualToString:@"admin"] ||
              [self.teamRole isEqualToString:@"creator"] ||
             self.roleId == -2 ) {
        cType = CooperateMemberAccessType_Manager ;
    }
    
    return cType ;
}

+ (NSArray *)titleInfos {
    return @[
             @{@"可以预览":@"可以预览、下载，不能编辑"} ,
             @{@"所有者":@"可以管理、移动、编辑文件"} ,
             @{@"管理者":@"可以管理、移动、编辑文件"} ,
              ] ;
}

- (NSDictionary *)getDescInfoWithCooperType:(CooperateMemberAccessType)type {
    return [self.class titleInfos][type - 1] ;
}

//const menuConfig = {
//title: '可以预览',
//desc: '可以预览、下载，不能编辑',
//operationDisabled:
//    (mode !== 'adding' &&
//     myRoleSeq <= targetRoleSeq &&
//     user.id !== me.id) ||
//    targetRoleSeq === 3,
//operation: '移除'
//}
//
//if (file.ownerId === user.id) {
//    menuConfig.title = '所有者'
//    menuConfig.desc = '可以管理、移动、编辑文件'
//}
//
//else if (
//           user.teamRole === 'admin' ||
//           user.teamRole === 'creator' ||
//           user.roleId === -2
//           ) {
//    menuConfig.title = '管理者'
//    menuConfig.desc = '可以管理、移动、编辑文件'
//}
//if (user.id === me.id) {
//    menuConfig.operation = '退出协作'
//}



@end



@implementation CooperMemberRelate
- (void)transformToMember:(void(^)(YPMemberInfo *member))blkMember {
    
    [YPFiles getAllMembersComplete:^(NSArray<YPMemberInfo *> * _Nonnull memberList) {
        
        [memberList enumerateObjectsUsingBlock:^(YPMemberInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.member_id == self.userId) {
                obj.roleId = self.roleId ;
                blkMember(obj) ;
                
                *stop = YES ;
                return ;
            }
        }] ;
    }] ;
}

@end
