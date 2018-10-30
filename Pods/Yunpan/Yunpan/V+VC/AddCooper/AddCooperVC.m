//
//  AddCooperVC.m
//  Yunpan
//
//  Created by teason23 on 2018/10/10.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "AddCooperVC.h"
#import <XTlib.h>
#import "YPCoopMemberCell.h"
#import "YPFiles.h"
#import "YPFiles+Request.h"
#import "YPMemberInfo.h"
#import <ReactiveObjC.h>

@interface AddCooperVC () <UITableViewDelegate,UITableViewDataSource,UITableViewXTReloaderDelegate,UISearchBarDelegate,YPCoopMemberCellDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (copy, nonatomic) NSArray *datalist ;
@property (copy, nonatomic) NSArray *allMember ;
@end

@implementation AddCooperVC

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *schbarLine = [UIView new] ;
    schbarLine.backgroundColor = UIColorHex(@"dcdcdc") ;
    [self.view addSubview:schbarLine] ;
    [schbarLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom) ;
        make.left.right.equalTo(self.view) ;
        make.height.equalTo(@1) ;
    }] ;
    
    self.datalist = @[] ;
    
    [_table xt_setup] ;
    _table.mj_footer = nil ;
    _table.xt_Delegate = self ;
    [YPCoopMemberCell registerNibFromTable:_table] ;
    [_table xt_loadNewInfoInBackGround:YES] ;
    
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone ;
    self.searchBar.delegate = self ;
    [[[[self rac_signalForSelector:@selector(searchBar:textDidChange:) fromProtocol:@protocol(UISearchBarDelegate)] throttle:.3] distinctUntilChanged] subscribeNext:^(RACTuple * x) {
        
        NSString *text = x.last ;
        if (text.length) {
            NSMutableArray *tmplist = [@[] mutableCopy] ;
            [self.allMember enumerateObjectsUsingBlock:^(YPMemberInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ( [obj.name containsString:text] |
                     [obj.email containsString:text] |
                     [obj.mobileAccount containsString:text] ) {
                    [tmplist addObject:obj] ;
                }
            }] ;
            
            self.datalist = tmplist ;
            [self.table reloadData] ;
        }
        else {
            [self.table xt_loadNewInfoInBackGround:YES] ;
        }
        
    }];

}

#pragma mark - table

- (void)tableView:(RootTableView *)table loadNew:(void(^)(void))endRefresh {
    [YPFiles getAllMembersComplete:^(NSArray<YPMemberInfo *> * _Nonnull memberList) {
        
        NSMutableArray *tmplist = [@[] mutableCopy] ;
        [memberList enumerateObjectsUsingBlock:^(YPMemberInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BOOL isContain = NO ;
            for (CooperMemberRelate *item in self.roleIds) {
                if (item.userId == obj.member_id) {
                    obj.roleId = item.roleId ;
                    isContain = YES ;
                    break ;
                }
            }
            
            if (!isContain) [tmplist addObject:obj] ;
        }] ;
        
        self.allMember = memberList ;
        self.datalist = tmplist ;
        endRefresh() ;
    }] ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datalist.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YPCoopMemberCell *cell = [YPCoopMemberCell fetchFromTable:tableView] ;
    cell.isAddMode = YES ;
    cell.aFile = self.currentFile ;
    cell.aMember = self.datalist[indexPath.row] ;
    cell.delegate = self ;
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YPCoopMemberCell cellHeight] ;
}

#pragma mark - YPCoopMemberCellDelegate

- (void)deleteThisMember:(YPMemberInfo *)member {
    WEAK_SELF
    [YPFiles updateMembersWithGuid:self.currentFile.guid
                      addMemberIds:@[]
                   removeMemberIds:@[@(member.member_id)]
                          complete:^(BOOL success) {
                              
                              if (success) {
                                  [weakSelf.datalist enumerateObjectsUsingBlock:^(YPMemberInfo *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                      
                                      if (obj.member_id == member.member_id) {
                                          obj.roleId = 0 ;
                                          
                                          *stop = YES ;
                                          return ;
                                      }
                                  }] ;
                                  [weakSelf.table reloadData] ;
                              }
                              
                          }] ;

}

- (void)addThisMember:(YPMemberInfo *)member {
    WEAK_SELF
    [YPFiles updateMembersWithGuid:self.currentFile.guid
                      addMemberIds:@[@(member.member_id)]
                   removeMemberIds:@[]
                          complete:^(BOOL success) {
                              
                              if (success) {
                                  [weakSelf.allMember enumerateObjectsUsingBlock:^(YPMemberInfo *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                      
                                      if (obj.member_id == member.member_id) {
                                          obj.roleId = -1 ;
                                          
                                          *stop = YES ;
                                          return ;
                                      }
                                  }] ;
                                  [weakSelf.table reloadData] ;
                              }
                              
                          }] ;

}

@end
