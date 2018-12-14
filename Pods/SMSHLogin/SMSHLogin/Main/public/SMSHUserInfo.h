//
//  SMSHUserInfo.h
//  SMSHLogin
//
//  Created by teason23 on 2018/12/3.
//  Copyright © 2018 teason23. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMSHUserInfo : NSObject

@property (copy, nonatomic) NSString    *avatar ;
@property (copy, nonatomic) NSString    *createdAt ;
@property (copy, nonatomic) NSString    *deletedAt ;
@property (copy, nonatomic) NSString    *email ;
@property (nonatomic)       NSInteger   gender ;
@property (nonatomic)       NSInteger   userID ; // id
@property (nonatomic)       NSInteger   isSeat ;
@property (nonatomic)       BOOL        isVerified ;
@property (copy, nonatomic) NSString    *lastVisit ;
@property (nonatomic)       NSInteger   mergedInto ;
@property (copy, nonatomic) NSString    *name ;
@property (copy, nonatomic) NSString    *namePinyin ;
@property (nonatomic)       NSInteger   parentId ;
@property (copy, nonatomic) NSString    *ref ;
@property (copy, nonatomic) NSString    *role ;
@property (nonatomic)       NSInteger   sharedBy ;
@property (nonatomic)       NSInteger   status ;
@property (nonatomic)       NSInteger   teamId ;
@property (copy, nonatomic) NSString    *teamRole ;
@property (copy, nonatomic) NSString    *teamTime ;
@property (copy, nonatomic) NSString    *updatedAt ;

@end

NS_ASSUME_NONNULL_END
