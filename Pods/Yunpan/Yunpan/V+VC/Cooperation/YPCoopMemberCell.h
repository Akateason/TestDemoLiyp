//
//  YPCoopMemberCell.h
//  Yunpan
//
//  Created by teason23 on 2018/10/10.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "RootTableCell.h"
@class YPFiles,YPMemberInfo ;
NS_ASSUME_NONNULL_BEGIN

@protocol YPCoopMemberCellDelegate <NSObject>
@required
- (void)deleteThisMember:(YPMemberInfo *)member ;
@optional
- (void)addThisMember:(YPMemberInfo *)member ;
@end

@interface YPCoopMemberCell : RootTableCell
@property (weak, nonatomic) IBOutlet UIImageView *imgUserHead;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbMail;
@property (weak, nonatomic) IBOutlet UILabel *lbAuthor;
@property (weak, nonatomic) IBOutlet UIButton *btUserAccess;

@property (strong, nonatomic) YPFiles *aFile ;
@property (strong, nonatomic) YPMemberInfo *aMember ;
@property (nonatomic)         BOOL isAddMode ;
@property (weak, nonatomic) id <YPCoopMemberCellDelegate> delegate ;
@end

NS_ASSUME_NONNULL_END
