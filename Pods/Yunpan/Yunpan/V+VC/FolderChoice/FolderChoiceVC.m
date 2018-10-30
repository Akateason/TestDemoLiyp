//
//  FolderChoiceVC.m
//  Yunpan
//
//  Created by teason23 on 2018/9/21.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "FolderChoiceVC.h"
#import "YPFiles+Request.h"
#import <XTlib.h>
#import "YPFolderCell.h"
#import "YPListNullView.h"
#import <CYLTableViewPlaceHolder.h>

@interface FolderChoiceVC () <CYLTableViewPlaceHolderDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *btConfirm;
@property (strong, nonatomic) YPListNullView *nullView ;

@property (strong, nonatomic) YPFiles *currentFolder ;
@property (strong, nonatomic) NSArray *datalist ;
@end

@implementation FolderChoiceVC

#pragma mark - util

+ (void)modalFromHomeCtrller:(UIViewController *)fromCtrller vType:(FolderChoiceVC_Type)type {
    FolderChoiceVC *fcVC = [FolderChoiceVC getCtrllerFromStory:@"YPHome" bundle:[NSBundle bundleForClass:self.class] controllerIdentifier:@"FolderChoiceVC"] ;
    fcVC.vType = type ;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:fcVC] ;
    [fromCtrller presentViewController:navVC animated:YES completion:nil] ;
}

#pragma mark - action

- (IBAction)newFolderOnClick:(id)sender {
    WEAK_SELF
    [UIAlertController xt_showTextFieldAlertWithTitle:@"新建文件夹" subtitle:nil cancel:@"取消" commit:@"确定" placeHolder:@"请输入 ..." callback:^(NSString *atext) {
        
        [YPFiles createFolderWithName:atext
                           parentGuid:weakSelf.currentFolder.guid
                             complete:^(YPFiles *aFile) {
                                 [weakSelf refresh] ;
                             }] ;
        
    }] ;
}

- (IBAction)movingOnClick:(id)sender { // 确认
    NSDictionary *dic = @{
                          @"guid" : self.currentFolder.guid ?: [NSNull null] ,
                          @"type" : @(self.vType) ,
                          @"name" : self.currentFolder.name
                          } ;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificate_FolderChoosen object:dic] ;
    
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

- (IBAction)cancelOnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

#pragma mark - Life

+ (void)shownWithFolder:(YPFiles *)folder
            fromCtrller:(UIViewController *)fromVC
                   type:(FolderChoiceVC_Type)type {
    
    FolderChoiceVC *fcVC = [FolderChoiceVC getCtrllerFromStory:@"YPHome" bundle:[NSBundle bundleForClass:self.class] controllerIdentifier:@"FolderChoiceVC"] ;
    fcVC.currentFolder = folder ;
    fcVC.vType = type ;
    [fromVC.navigationController pushViewController:fcVC animated:YES] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.currentFolder.name ?: @"我的云盘" ;
    
    NSString *btTitleAppend = STR_FORMAT(@"至“%@”",self.title) ;
    switch (self.vType) {
        case FolderChoiceVC_Type_copy: [self.btConfirm setTitle:[@"复制" stringByAppendingString:btTitleAppend] forState:0] ; break ;
        case FolderChoiceVC_Type_move: [self.btConfirm setTitle:[@"移动" stringByAppendingString:btTitleAppend] forState:0] ; break ;
        case FolderChoiceVC_Type_PostImage: [self.btConfirm setTitle:[@"上传" stringByAppendingString:btTitleAppend] forState:0] ; break ;
        default: break ;
    }
    
    _table.estimatedRowHeight = 0 ;
    _table.estimatedSectionHeaderHeight = 0 ;
    _table.estimatedSectionFooterHeight = 0 ;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    [YPFolderCell registerNibFromTable:_table] ;
    
    [self refresh] ;
}

- (void)refresh {
    NSString *guid = self.currentFolder.guid ?: @"" ;
    WEAK_SELF
    [YPFiles getFilesListWithParentGuid:guid complete:^(NSArray *list) {
        NSMutableArray *tmplist = [@[] mutableCopy] ;
        [list enumerateObjectsUsingBlock:^(YPFiles *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isFolder) {
                [tmplist addObject:obj] ;
            }
        }] ;
        weakSelf.datalist = tmplist ;
        [weakSelf.table cyl_reloadData] ;
    }] ;
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datalist.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YPFolderCell *cell = [YPFolderCell fetchFromTable:tableView indexPath:indexPath] ;
    [cell configure:self.datalist[indexPath.row] indexPath:indexPath] ;
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YPFolderCell cellHeight] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YPFiles *aFile = self.datalist[indexPath.row] ;
    [FolderChoiceVC shownWithFolder:aFile fromCtrller:self type:self.vType] ;
}

- (UIView *)makePlaceHolderView {
    return self.nullView ;
}

- (BOOL)enableScrollWhenPlaceHolderViewShowing {
    return YES ;
}

- (YPListNullView *)nullView{
    if(!_nullView){
        _nullView = ({
            YPListNullView *view = [[YPListNullView alloc] initWithTip:@"没有子文件夹"] ;
            view;
        });
    }
    return _nullView;
}

@end
