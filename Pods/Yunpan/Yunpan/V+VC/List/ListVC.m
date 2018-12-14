//
//  ListVC.m
//  Yunpan
//
//  Created by teason23 on 2018/9/11.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "ListVC.h"
#import <XTlib/XTlib.h>
#import "YPFiles.h"
#import "YPFiles+Request.h"
#import "YPFiles+Sort.h"
#import "YPListCell.h"
#import "YPFolderMananger.h"
#import "AlbumVC.h"
#import "MultyChoice/MultyChoiceTopBar.h"
#import "MultyChoice/MultyChoiceBottomBar.h"
#import "FolderChoiceVC.h"
#import "ListSortView/YPListSortView.h"
#import <Photos/Photos.h>
#import <SDWebImage/SDWebImageManager.h>
#import "UrlConfig.h"
#import "CooperationVC.h"
#import <FTPopOverMenu/FTPopOverMenu.h>
#import "TransferListVC.h"
#import <LXMButtonImagePosition/UIButton+LXMImagePosition.h>
#import "SHMDriveSDK.h"
#import "NoneEditorVC.h"
#import "YPImageEditorVC.h"
#import "YPDownloadManager.h"
#import <CYLTableViewPlaceHolder/CYLTableViewPlaceHolder.h>
#import "ListVC+Poperview.h"
#import "YPListNullView/YPListNullView.h"
#import "UIImage+Yunpan.h"


@interface ListVC () <UITableViewXTReloaderDelegate,UITableViewDelegate,UITableViewDataSource,YPListCellDelegate,MultyChoiceTopBarDelegate,MultyChoiceBottomBarDelegate,CYLTableViewPlaceHolderDelegate>
@property (strong, nonatomic) MultyChoiceTopBar *eTopbar ;
@property (strong, nonatomic) MultyChoiceBottomBar *eBottombar ;
@property (strong, nonatomic) YPListNullView *nullView ;

@property (copy, nonatomic)   NSArray  *datasouce ;
@property (strong, nonatomic, readwrite) YPFiles  *currentFiles ;
@property (nonatomic)         BOOL     isEditMode ;
@property (strong, nonatomic) RACSubject *movingGuidsSignal ;
@property (strong, nonatomic) RACSubject *copyGuidsSignal ;
@end

@implementation ListVC

#pragma mark - MultyChoiceTopBarDelegate

- (void)cancelBtOnClick {
    self.isEditMode = NO ;
    
    NSMutableArray *tmplist = [self.datasouce mutableCopy] ;
    [tmplist enumerateObjectsUsingBlock:^(YPFiles *aFile, NSUInteger idx, BOOL * _Nonnull stop) {
        aFile.isOnSelect = NO ;
    }] ;
    self.datasouce = tmplist ;
    [_table cyl_reloadData] ;
    
    if (self.navigationController.viewControllers.count > 1) {
        self.bottomOfTable.constant = 0 ;
    }
}

- (void)allChooseBtOnClick:(BOOL)allSelectOrNot {
    NSMutableArray *tmplist = [self.datasouce mutableCopy] ;
    if (allSelectOrNot) {
        [tmplist enumerateObjectsUsingBlock:^(YPFiles *aFile, NSUInteger idx, BOOL * _Nonnull stop) {
            aFile.isOnSelect = YES ;
        }] ;
    }
    else {
        [tmplist enumerateObjectsUsingBlock:^(YPFiles *aFile, NSUInteger idx, BOOL * _Nonnull stop) {
            aFile.isOnSelect = NO ;
        }] ;
    }
    self.datasouce = tmplist ;
    
    if (allSelectOrNot) self.isEditMode = allSelectOrNot ;
    [self.eTopbar setChoosenCount:(int)[self fetchGuidsOnSelected].count] ;
    
    [_table cyl_reloadData] ;
}

#pragma mark - MultyChoiceBottomBarDelegate <NSObject>

- (void)addMembers {
    YPFiles *afile = [[self fetchFilesOnSelected] firstObject] ;
    [self cancelBtOnClick] ;
    
    [CooperationVC showFromCtrller:self onFile:afile] ;
}

- (void)download {
    NSArray *selectedFiles = [self fetchFilesOnSelected] ;
    [self cancelBtOnClick] ;
    
    [[YPDownloadManager sharedInstance] addFileList:selectedFiles] ;
}

- (void)movingFile {
    NSArray *tmpGuids = [self fetchGuidsOnSelected] ;
    [self cancelBtOnClick] ;
    [FolderChoiceVC modalFromHomeCtrller:self vType:FolderChoiceVC_Type_move] ;
    [self.movingGuidsSignal sendNext:tmpGuids] ;
    [self.movingGuidsSignal sendCompleted] ;
}

- (void)deleteFile {
    NSArray *list = [self fetchGuidsOnSelected] ;
    
    WEAK_SELF
    [[YPFolderMananger sharedInstance] deleteFileOnServerWithGuids:list complete:^(bool success) {
        if (success) {
            [weakSelf.table xt_loadNewInfoInBackGround:YES] ;
            weakSelf.isEditMode = NO ;
        }
    }] ;
}

- (void)more {
    NSArray *tmpGuids = [self fetchGuidsOnSelected] ;
    NSArray *tmpFiles = [self fetchFilesOnSelected] ;
    YPFiles *afile = [tmpFiles firstObject] ;
    EditedToolbarMode mode = [self findChoosenMode] ;
    
    [self cancelBtOnClick] ;
    
    switch (mode) {
        case mode_selectOneFile: {
            
            NSArray *titles = afile.isImageType ? @[@"创建副本",@"重命名",@"保存到相册"] : @[@"创建副本",@"重命名"] ;
            [UIAlertController xt_showAlertCntrollerWithAlertControllerStyle:UIAlertControllerStyleActionSheet title:@"更多" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:titles callBackBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    [self copyWithFiles:tmpGuids] ;
                }
                else if (btnIndex == 2) {
                    [self renameWhichFolder:[tmpFiles firstObject]] ;
                }
                else if (btnIndex == 3) {
                    [SVProgressHUD show] ;
                    
                    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:afile.downloadUrl] options:SDWebImageHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                        
                        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init] ;
                        [library saveImage:image toAlbum:@"石墨" completionBlock:^(NSError *error) {
                            [SVProgressHUD dismiss] ;
                            [SVProgressHUD showSuccessWithStatus:@"已保存到相册"] ;
                        }] ;
                        
                    }] ;
                    
                }
            }] ;
        }
            break;
        case mode_selectOneFolder: {
            [UIAlertController xt_showAlertCntrollerWithAlertControllerStyle:UIAlertControllerStyleActionSheet title:@"更多" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"重命名"] callBackBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    [self renameWhichFolder:[tmpFiles firstObject]] ;
                }
            }] ;
        }
            break;
        case mode_selectManyFiles: {
            [UIAlertController xt_showAlertCntrollerWithAlertControllerStyle:UIAlertControllerStyleActionSheet title:@"更多" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"创建副本"] callBackBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    [self copyWithFiles:tmpGuids] ;
                }
            }] ;
        }
            break;
        default:
            break;
    }
}

#pragma mark - YPListCellDelegate

- (void)btChooseOnclick:(BOOL)beOnSelect indexPath:(NSIndexPath *)indexPath {
    NSMutableArray *tmplist = [self.datasouce mutableCopy] ;
    [tmplist enumerateObjectsUsingBlock:^(YPFiles *aFile, NSUInteger idx, BOOL * _Nonnull stop) {
        if (indexPath.row == idx) {
            aFile.isOnSelect = beOnSelect ;
        }
    }] ;
    self.datasouce = tmplist ;
    
    int selectCount = (int)[self fetchGuidsOnSelected].count ;
    self.isEditMode = selectCount ;
    [self.eTopbar setChoosenCount:selectCount] ;
    [self.eTopbar setIsFullSelected:selectCount == self.datasouce.count] ;
    
    if (self.navigationController.viewControllers.count > 1) {
        self.bottomOfTable.constant = selectCount ? -49 : 0 ;
    }
}

#pragma mark --
#pragma mark - util

+ (void)goIn:(YPFiles *)afile fromCtrller:(UIViewController *)fromCtrller {
    ListVC *aListVc = [ListVC getCtrllerFromStory:@"YPHome" bundle:[NSBundle bundleForClass:self.class] controllerIdentifier:@"ListVC"] ;
    aListVc.currentFiles = afile ;
    aListVc.hidesBottomBarWhenPushed = YES ;
    [fromCtrller.navigationController pushViewController:aListVc animated:YES] ;
}

- (NSArray *)fetchGuidsOnSelected {
    __block NSMutableArray *tmplist = [@[] mutableCopy] ;
    [self.datasouce enumerateObjectsUsingBlock:^(YPFiles *aFile, NSUInteger idx, BOOL * _Nonnull stop) {
        if (aFile.isOnSelect) {
            [tmplist addObject:aFile.guid] ;
        }
    }] ;

    return tmplist ;
}

- (NSArray *)fetchFilesOnSelected {
    __block NSMutableArray *tmplist = [@[] mutableCopy] ;
    [self.datasouce enumerateObjectsUsingBlock:^(YPFiles *aFile, NSUInteger idx, BOOL * _Nonnull stop) {
        if (aFile.isOnSelect) {
            [tmplist addObject:aFile] ;
        }
    }] ;
    
    return tmplist ;
}

- (EditedToolbarMode)findChoosenMode {
    NSArray *selectedFiles = [self fetchFilesOnSelected] ;
    if (selectedFiles.count == 1) {
        YPFiles *afile = [selectedFiles firstObject] ;
        return !afile.isFolder ? mode_selectOneFile : mode_selectOneFolder ;
    }
    else {
        __block BOOL hasFolder = NO ;
        [selectedFiles enumerateObjectsUsingBlock:^(YPFiles *aFile, NSUInteger idx, BOOL * _Nonnull stop) {
            if (aFile.isFolder) hasFolder = YES ;
        }] ;
        return !hasFolder ? mode_selectManyFiles : mode_selectManyFilesOrFolder ;
    }
}

- (void)renameWhichFolder:(YPFiles *)fromFolder {
    NSString *originName = fromFolder.name ;
    NSString *originNail = @"" ;
    if ([originName containsString:@"."]) {
        originNail = [@"." stringByAppendingString:[[originName componentsSeparatedByString:@"."] lastObject]] ;
    }
    
    WEAK_SELF
    [UIAlertController xt_showTextFieldAlertWithTitle:STR_FORMAT(@"确实要重命名%@吗?",fromFolder.name) subtitle:nil cancel:@"取消" commit:@"好" placeHolder:@"输入新的文件夹名字" callback:^(NSString *text) {
        if (![text containsString:@"."]) {
            text = [text stringByAppendingString:originNail] ;
        }
        
        [YPFiles renameFolderWithGuid:fromFolder.guid newName:text complete:^(BOOL sucess) {
            if (sucess) {
                [weakSelf.table xt_loadNewInfoInBackGround:YES] ;
            }
        }] ;
    }] ;
}

- (void)copyWithFiles:(NSArray *)fromFilesGUids {
    [FolderChoiceVC modalFromHomeCtrller:self vType:FolderChoiceVC_Type_copy] ;
    [self.copyGuidsSignal sendNext:fromFilesGUids] ;
    [self.copyGuidsSignal sendCompleted] ;
}

#pragma mark --
#pragma mark - prop

- (void)setCurrentFiles:(YPFiles *)currentFiles {
    _currentFiles = currentFiles ;
    
    self.title = [[YPFolderMananger sharedInstance] currentFileName:currentFiles] ;
}

- (void)setIsEditMode:(BOOL)isEditMode {
    _isEditMode = isEditMode ;
    
    self.eTopbar.hidden     = !isEditMode ;
    self.eBottombar.hidden  = !isEditMode ;
    EditedToolbarMode mode = [self findChoosenMode] ;
    [self.eBottombar makeupWithMode:mode] ;
}

- (MultyChoiceTopBar *)eTopbar {
    if (!_eTopbar) {
        _eTopbar = [MultyChoiceTopBar newFromCtrller:self] ;
    }
    return _eTopbar ;
}

- (MultyChoiceBottomBar *)eBottombar {
    if (!_eBottombar) {
        _eBottombar = [MultyChoiceBottomBar newFromCtrller:self] ;
    }
    return _eBottombar ;
}

- (RACSubject *)movingGuidsSignal {
    if (!_movingGuidsSignal) {
        _movingGuidsSignal = [RACSubject subject] ;
    }
    return _movingGuidsSignal ;
}

- (RACSubject *)copyGuidsSignal {
    if (!_copyGuidsSignal) {
        _copyGuidsSignal = [RACSubject subject] ;
    }
    return _copyGuidsSignal ;
}

#pragma mark - action

- (IBAction)btSortOnClick:(id)sender {
    if (!self.datasouce.count) return ;
    
    @weakify(self)
    [YPListSortView showFromCtrller:self underWhichView:self.topContainer sortInfoChoosen:^(YPListSortManager * _Nonnull manager) {
        
        @strongify(self)
        self.datasouce = [[YPListSortManager sharedInstance] startSort:self.datasouce] ;
        [self.table cyl_reloadData] ;
        
    }] ;
}

#pragma mark - life

- (void)prepareUI {
    [YPListCell xt_registerNibFromTable:_table bundleOrNil:[NSBundle bundleForClass:[YPListCell class]]] ;
    
    _table.dataSource = self ;
    _table.delegate = self ;
    _table.xt_Delegate = self ;
    [_table xt_setup] ;
    _table.mj_footer = nil ;
    
    @weakify(self)
    [RACObserve([YPListSortManager sharedInstance], sortOrder) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        UIImage *img = ![x boolValue] ? [UIImage shmyp_imageNamed:@"sortDown" fromBundleClass:self.class] : [UIImage shmyp_imageNamed:@"sortUp" fromBundleClass:self.class] ;
        if ([YPListSortManager sharedInstance].sortType == YPListSortType_author) {
            [self.btSort setImage:nil forState:0] ;
        }
        else {
            [self.btSort setImage:img forState:0] ;
        }
        [self.btSort setImagePosition:LXMImagePositionLeft spacing:5] ;
    }] ;
    
    [RACObserve([YPListSortManager sharedInstance], sortType) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSString *title = [YPListSortManager stringForType:[x integerValue]] ;
        [self.btSort setTitle:title forState:0] ;

    }] ;
    
    

    bool hiddenExitBt =
    [[SHMDriveSDK sharedInstance].delegate respondsToSelector:@selector(hiddenExitButton)]
    && [SHMDriveSDK sharedInstance].delegate.hiddenExitButton == YES ;
    
    if (!hiddenExitBt && self.navigationController.viewControllers.count == 1) {
        UIBarButtonItem *itemClose = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(back)] ;
        self.navigationItem.leftBarButtonItem = itemClose ;
    }
    
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [[YPFolderMananger sharedInstance] currentFileName:self.currentFiles] ;
    
    [self prepareUI] ;
    
    // moving folder .
    @weakify(self)
    [[[RACSignal combineLatest:@[self.movingGuidsSignal,
                                 [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kNotificate_FolderChoosen object:nil] filter:^BOOL(NSNotification * _Nullable value) {
        NSDictionary *dic = value.object ;
        return [dic[@"type"] integerValue] == FolderChoiceVC_Type_move ;
    }]]]
      deliverOnMainThread] subscribeNext:^(RACTuple * _Nullable x) {
        
        RACTupleUnpack(NSArray *guids,NSNotification *noti) = x ;
        NSString *choosenGuid = noti.object[@"guid"] ;
        choosenGuid = [!choosenGuid.length || !choosenGuid ? [NSNull null] : choosenGuid copy] ;
        [YPFiles moveFileOrFolderWithParentGuid:choosenGuid guids:guids complete:^(BOOL bSuccess) {
            @strongify(self)
            if (bSuccess) [self.table xt_loadNewInfoInBackGround:YES] ;
        }] ;
    }] ;
    
    // copy files .
    [[[RACSignal combineLatest:@[self.copyGuidsSignal,
                                 [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kNotificate_FolderChoosen object:nil] filter:^BOOL(NSNotification * _Nullable value) {
        NSDictionary *dic = value.object ;
        return [dic[@"type"] integerValue] == FolderChoiceVC_Type_copy ;
    }]]]
      deliverOnMainThread] subscribeNext:^(RACTuple * _Nullable x) {
        
        RACTupleUnpack(NSArray *guids,NSNotification *noti) = x ;
        NSString *choosenGuid = noti.object[@"guid"] ;
        choosenGuid = [!choosenGuid.length || !choosenGuid ? [NSNull null] : choosenGuid copy] ;
        [YPFiles copyFiles:guids parentGuid:choosenGuid complete:^(BOOL bSuccess) {
            @strongify(self)
            if (bSuccess) [self.table xt_loadNewInfoInBackGround:YES] ;
        }] ;
    }] ;
    
    
    
    if ([[SHMDriveSDK sharedInstance].delegate respondsToSelector:@selector(funcInHomeVCDidload:)]) {
        [[SHMDriveSDK sharedInstance].delegate funcInHomeVCDidload:self] ;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    
    [_table xt_loadNewInfoInBackGround:YES] ;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated] ;
    
    [self cancelBtOnClick] ;
}

- (IBAction)jumpTransOnClick:(id)sender {
    TransferListVC *transList = [TransferListVC getCtrllerFromStory:@"YPHome" bundle:[NSBundle bundleForClass:self.class] controllerIdentifier:@"TransferListVC"] ;
    [self.navigationController pushViewController:transList animated:YES] ;
}

#pragma mark - navigation bar

- (IBAction)uploadBtOnClick:(UIBarButtonItem *)sender {
    [self poperClickWithParentFile:self.currentFiles] ;
}

#pragma mark - UITableViewXTReloaderDelegate <NSObject>

- (void)tableView:(UITableView *)table loadNew:(void(^)(void))endRefresh {
    NSString *guid = self.currentFiles.guid ?: nil ;
    WEAK_SELF
    [YPFiles getFilesListWithParentGuid:guid complete:^(NSArray *list) {
        list = [[YPListSortManager sharedInstance] startSort:list] ;
        weakSelf.datasouce = list ;
        endRefresh() ;
    }] ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasouce.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YPListCell *cell = [YPListCell fetchFromTable:tableView indexPath:indexPath] ;
    [cell configure:self.datasouce[indexPath.row] indexPath:indexPath] ;
    cell.delegate = self ;
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YPListCell cellHeight] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YPFiles *aFile = self.datasouce[indexPath.row] ;
    // edit
    if (self.isEditMode) {
        YPListCell *cell = [tableView cellForRowAtIndexPath:indexPath] ;
        [self btChooseOnclick:!cell.btChoose.selected indexPath:indexPath] ;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone] ;
        return ;
    }
    
    // normal
    if (aFile.isFolder) { // folder
        [ListVC goIn:aFile fromCtrller:self] ;
    }
    else {
    // file
        [[YPFolderMananger sharedInstance] clickFile:aFile fromCtrller:self wholeList:self.datasouce clickFromType:YPFileClickFrom_List] ;
    }
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
            YPListNullView *view = [[YPListNullView alloc] initWithTip:@"暂无任何文件"] ;
            view;
       });
    }
    return _nullView;
}

@end
