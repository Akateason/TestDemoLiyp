//
//  YPMemberInfo.h
//  Yunpan
//
//  Created by teason23 on 2018/9/26.
//  Copyright © 2018年 teason23. All rights reserved.

//"avatar": "https://dn-shimo-image-dev.qbox.me/sbz6Ir80GLkThyJA/Group.png",
//"isVerified": false,
//"isSeat": 1,
//"lastVisit": "2018-09-25T09:38:00.000Z",
//"namePinyin": "wh0|'wu'huang'001",
//"teamId": 948,
//"teamRole": "creator",
//"id": 13010,
//"name": "唔皇001",
//"name_pinyin": "wh0|'wu'huang'001",
//"status": 0,
//"email": "wuhuang001@shimo.im",
//"team_role": "creator",
//"is_seat": 1,
//"team_id": 948,
//"last_visit": "2018-09-25T09:38:00.000Z",
//"mobileAccount": "+8613212312321"

#import <Foundation/Foundation.h>
@class YPFiles ;

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CooperateMemberAccessType_ReadOnly = 1 ,
    CooperateMemberAccessType_Owner ,
    CooperateMemberAccessType_Manager ,
} CooperateMemberAccessType;

@interface YPMemberInfo : NSObject
@property (nonatomic)       NSInteger   member_id ;  // id
@property (copy, nonatomic) NSString    *avatar ;
@property (nonatomic)       BOOL        isVerified ;
@property (nonatomic)       BOOL        isSeat ;
@property (copy, nonatomic) NSString    *lastVisit ;
@property (copy, nonatomic) NSString    *namePinyin ;
@property (nonatomic)       NSInteger   teamId ;
@property (copy, nonatomic) NSString    *teamRole ;
@property (copy, nonatomic) NSString    *name ;
@property (copy, nonatomic) NSString    *name_pinyin ;
@property (nonatomic)       NSInteger   status ;
@property (copy, nonatomic) NSString    *email ;
@property (copy, nonatomic) NSString    *team_role ;
@property (nonatomic)       NSInteger   is_seat ;
@property (nonatomic)       NSInteger   team_id ;
@property (copy, nonatomic) NSString    *last_visit ;
@property (copy, nonatomic) NSString    *mobileAccount ;

#pragma mark - cooper @add
// cooper member props
@property (nonatomic)       NSInteger                 roleId ;
// 协作者权限
- (CooperateMemberAccessType)getCooperTypeOnFile:(YPFiles *)afile ;
- (NSDictionary *)getDescInfoWithCooperType:(CooperateMemberAccessType)type ;
@end


@interface CooperMemberRelate : NSObject
@property (nonatomic) NSInteger userId ;
@property (nonatomic) NSInteger roleId ;

- (void)transformToMember:(void(^)(YPMemberInfo *member))blkMember ;

@end

NS_ASSUME_NONNULL_END
