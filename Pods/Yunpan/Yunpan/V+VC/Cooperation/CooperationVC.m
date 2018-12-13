//
//  CooperationVC.m
//  Yunpan
//
//  Created by teason23 on 2018/10/10.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "CooperationVC.h"
#import <XTlib/XTlib.h>
#import "YPCoopMemberCell.h"
#import "YPFiles.h"
#import "YPFiles+Request.h"
#import "YPMemberInfo.h"
#import "AddCooperVC.h"

@interface CooperationVC () <UITableViewDelegate,UITableViewDataSource,UITableViewXTReloaderDelegate,YPCoopMemberCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) YPFiles *currentFile ;
@property (copy, nonatomic) NSArray *dataList ;
@end

@implementation CooperationVC

+ (void)showFromCtrller:(UIViewController *)fromCtrller onFile:(YPFiles *)aFile {
    CooperationVC *vc = [CooperationVC getCtrllerFromStory:@"Cooperation" bundle:[NSBundle bundleForClass:self.class] controllerIdentifier:@"CooperationVC"] ;
    vc.currentFile = aFile ;
    [fromCtrller.navigationController pushViewController:vc animated:YES] ;
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    self.dataList = @[] ;
    
    [_table xt_setup] ;
    _table.mj_footer = nil ;
    _table.xt_Delegate = self ;
    [YPCoopMemberCell xt_registerNibFromTable:_table bundleOrNil:[NSBundle bundleForClass:YPCoopMemberCell.class]] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    
    [_table xt_loadNewInfoInBackGround:YES] ;
}

#pragma mark - table

- (void)tableView:(RootTableView *)table loadNew:(void(^)(void))endRefresh {
    WEAK_SELF
    [YPFiles getFilesMembersWithGuid:self.currentFile.guid
                         fileOwnerId:self.currentFile.ownerId
                            complete:^(NSArray<CooperMemberRelate *> * _Nonnull memberlist) {
        
        weakSelf.dataList = memberlist ;
        endRefresh() ;
    }] ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YPCoopMemberCell *cell = [YPCoopMemberCell fetchFromTable:tableView] ;
    cell.aFile = self.currentFile ;
    [cell configure:self.dataList[indexPath.row]] ;
    cell.delegate = self ;
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YPCoopMemberCell cellHeight] ;
}

#pragma mark - YPCoopMemberCellDelegate <NSObject>

- (void)deleteThisMember:(YPMemberInfo *)member {
    WEAK_SELF
    [YPFiles updateMembersWithGuid:self.currentFile.guid
                      addMemberIds:@[]
                   removeMemberIds:@[@(member.member_id)]
                          complete:^(BOOL success) {
        
                              if (success) [weakSelf.table xt_loadNewInfoInBackGround:YES] ;
        
    }] ;
}




#pragma mark - story

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"cooplist2addcoop"]) {
        AddCooperVC *aVC = [segue destinationViewController] ;
        aVC.currentFile = self.currentFile ;
        aVC.roleIds = self.dataList ;
    }
}

@end
