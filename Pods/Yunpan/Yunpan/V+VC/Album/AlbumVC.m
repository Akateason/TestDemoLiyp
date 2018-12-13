//
//  AlbumVC.m
//  Yunpan
//
//  Created by teason23 on 2018/9/14.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "AlbumVC.h"
#import <Photos/Photos.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "CameraGoupCtrller.h"
#import <XTlib/XTlib.h>
#import "AlbumnCell.h"
#import "PreviewCtrller.h"
#import <LXMButtonImagePosition/UIButton+LXMImagePosition.h>
#import "FolderChoiceVC.h"
#import "UploadManager.h"
#import "UploadRecordTB.h"


static float kMAX_SELECT_COUNT = 10000. ;

@interface AlbumVC () <CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CameraGroupCtrllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomArea;
@property (weak, nonatomic) IBOutlet UIButton *btTitle;
@property (weak, nonatomic) IBOutlet UIButton *btPreview;
@property (weak, nonatomic) IBOutlet UIButton *btUpload;
@property (weak, nonatomic) IBOutlet UIButton *btChoosePath;

@property  (nonatomic, strong) NSMutableArray           *imageList ;                // data source .
@property  (nonatomic, strong) NSMutableArray           *multySelectedImageList ;
@property  (nonatomic, strong) NSMutableArray           *resultAssetList ;          // result .
@property  (strong, nonatomic) PHFetchResult            *allPhotos ;
@property  (strong, nonatomic) PHImageManager           *manager ;

@property  (strong, nonatomic) UICollectionView         *collectionView ;
@property  (nonatomic, strong) CameraGoupCtrller        *groupCtrller ;
@property  (copy, nonatomic) NSString *parentGuid ;
@property  (copy, nonatomic) NSString *parentName ;
@end


@implementation AlbumVC

+ (void)showAlbumFrom:(UIViewController *)fromCtrller parentGuid:(NSString *)parentGuid parentName:(NSString *)parentName {
    AlbumVC *albumVC = [AlbumVC getCtrllerFromStory:@"Album" bundle:[NSBundle bundleForClass:self.class] controllerIdentifier:@"AlbumVC"] ;
    albumVC.hidesBottomBarWhenPushed = YES ;
    albumVC.parentGuid = parentGuid ;
    albumVC.parentName = parentName ;
    [fromCtrller.navigationController pushViewController:albumVC animated:YES] ;
}

- (IBAction)btTitleOnClick:(id)sender {
    [self.groupCtrller cameraGroupAnimation:!self.groupCtrller.view.superview onView:self.view] ;
}

- (IBAction)btPreviewOnClick:(id)sender {
    if (!self.resultAssetList.count) {
        [SVProgressHUD showErrorWithStatus:@"请选择图片"] ;
        return ;
    }
    [self performSegueWithIdentifier:@"camra2preview" sender:self.resultAssetList] ;
}

- (IBAction)btChoosePathOnClick:(id)sender {
    [FolderChoiceVC modalFromHomeCtrller:self vType:FolderChoiceVC_Type_PostImage] ;
}

- (IBAction)btUploadOnClick:(id)sender {
    if (!self.resultAssetList.count) {
        [SVProgressHUD showErrorWithStatus:@"请选择图片"] ;
        return ;
    }
    
    [[UploadManager sharedInstance] addAssetList:self.resultAssetList parentID:self.parentGuid] ;
    
    [self.navigationController popToRootViewControllerAnimated:YES] ;
//    [SVProgressHUD showSuccessWithStatus:@"已加入上传列表"] ;
}

#pragma mark - Properties

- (PHImageManager *)manager {
    if (!_manager) {
        _manager = [PHImageManager defaultManager] ;
    }
    return _manager ;
}

- (CameraGoupCtrller *)groupCtrller {
    if (!_groupCtrller) {
        _groupCtrller = [[CameraGoupCtrller alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT - APP_NAVIGATIONBAR_HEIGHT - APP_STATUSBAR_HEIGHT)] ;
        _groupCtrller.delegate = self ;
    }
    return _groupCtrller ;
}

- (NSMutableArray *)imageList {
    if (!_imageList) {
        _imageList = [@[] mutableCopy] ;
    }
    return _imageList ;
}

- (NSMutableArray *)multySelectedImageList {
    if (!_multySelectedImageList) {
        _multySelectedImageList = [@[] mutableCopy] ;
    }
    return _multySelectedImageList ;
}

- (NSMutableArray *)resultAssetList {
    _resultAssetList = [@[] mutableCopy] ;
    
    for (NSNumber *number in self.multySelectedImageList) {
        PHAsset *photoAsset = self.allPhotos[[number intValue]] ;
        [_resultAssetList addObject:photoAsset] ;
    }
    return _resultAssetList ;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        // Config layout
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init] ;
        layout.columnCount = kCOLUMN_NUMBER ;
        layout.sectionInset = UIEdgeInsetsMake(kCOLUMN_FLEX, kCOLUMN_FLEX, kCOLUMN_FLEX, kCOLUMN_FLEX) ;
        layout.minimumColumnSpacing = kCOLUMN_FLEX ;
        layout.minimumInteritemSpacing = kCOLUMN_FLEX ;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout] ;
        
        UINib *nib = [UINib nibWithNibName:identifierAlbumnCell bundle:[NSBundle bundleForClass:AlbumnCell.class]] ;
        [_collectionView registerNib:nib
          forCellWithReuseIdentifier:identifierAlbumnCell] ;
        
        _collectionView.delegate = self ;
        _collectionView.dataSource = self ;
        _collectionView.backgroundColor = [UIColor whiteColor] ;
        if (![_collectionView superview]) {
            [self.view addSubview:_collectionView] ;
            [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self.view) ;
                make.bottom.equalTo(self.bottomArea.mas_top) ;
            }] ;
        }
    }
    
    return _collectionView ;
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self collectionView] ;
    [self multySelectedImageList] ;
    [self imageList] ;
    
    [self.btTitle setTitle:@"相机胶卷" forState:0] ;
    [self.btTitle setImagePosition:LXMImagePositionRight spacing:6] ;
    
    [self.btChoosePath setImagePosition:LXMImagePositionLeft spacing:5] ;
    [self.btChoosePath setTitle:STR_FORMAT(@"位置:%@>",self.parentName) forState:0] ;

    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            // 用户同意授权
            [self firstLoadAllPhotos] ;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData] ;
            }) ;
        }
        else {
            // 用户拒绝授权
        }
    }] ;
    
    [self firstLoadAllPhotos] ;
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kNotificate_FolderChoosen object:nil] deliverOnMainThread] subscribeNext:^(NSNotification * _Nullable x) {
        NSDictionary *dic = x.object ;
        NSString *guid = dic[@"guid"] ;
        FolderChoiceVC_Type type = [dic[@"type"] integerValue] ;
        NSString *name = dic[@"name"] ;
        if (type == FolderChoiceVC_Type_PostImage) {
            self.parentGuid = guid ;
            [self.btChoosePath setTitle:STR_FORMAT(@"位置:%@>",name) forState:0] ;
        }
        
    }] ;
}

- (void)firstLoadAllPhotos {
    if (self.allPhotos.count) return ;
    
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init] ;
    // 只取图片
    allPhotosOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d",PHAssetMediaTypeImage] ;
    // 按时间排序
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]] ;
    // 获取图片
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions] ;
    self.allPhotos = allPhotos ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark - Function .

- (void)showImgAssetsInGroup:(PHAssetCollection *)group {
    PHFetchOptions *options = [[PHFetchOptions alloc] init] ;
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]] ;

    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:group options:options];
    self.allPhotos = fetchResult ;
}

#pragma mark - Multy Picture selected

- (BOOL)thisPhotoIsSelectedWithRow:(NSInteger)row {
    __block BOOL bHas = NO ;
    [self.multySelectedImageList enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL * _Nonnull stop) {
        int selectedRow = [self.multySelectedImageList[idx] intValue] ;
        if (selectedRow == row) {
            bHas = YES ;
            *stop = YES  ;
        }
    }] ;
    return bHas ;
}

#pragma mark --
#pragma mark - collection dataSourse

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allPhotos.count ; //[self.imageList count] ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row ;
    AlbumnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierAlbumnCell forIndexPath:indexPath] ;
    cell.picSelected = [self thisPhotoIsSelectedWithRow:row] ;
    return cell ;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(AlbumnCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row ;
    PHAsset *photo = [self.allPhotos objectAtIndex:row] ;
    [self.manager requestImageForAsset:photo
                            targetSize:[AlbumnCell getSize]
                           contentMode:PHImageContentModeAspectFill
                               options:nil
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             if (result) {
                                 cell.img.image = result ;
                             }
                    }] ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL hasUploaded = [UploadRecordTB xt_hasModelWhere:STR_FORMAT(@"uniqueLocalKey == '%@'",photo.localIdentifier)] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.lbAlreadyUploaded.hidden = !hasUploaded ;
        }) ;
    }) ;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [AlbumnCell getSize] ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumnCell *cell = (AlbumnCell *)[collectionView cellForItemAtIndexPath:indexPath] ;
    if (!cell.lbAlreadyUploaded.hidden) return ;
    
    NSInteger row = indexPath.row ;
    NSNumber *numRow = [NSNumber numberWithInteger:row] ;
    NSLog(@"ROW : %@",numRow) ;
    if ([self thisPhotoIsSelectedWithRow:row]) {
        [self.multySelectedImageList removeObject:numRow] ;
    }
    else {
        int maxCount = kMAX_SELECT_COUNT ;
        if (self.multySelectedImageList.count >= maxCount) {
            [SVProgressHUD showErrorWithStatus:@"超过最大图片数"] ;
            NSLog(@"%d 超过最大图片数",maxCount) ;
            return ;
        }
        [self.multySelectedImageList addObject:numRow] ;
    }
    
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]] ;
    
    NSString *strDisplay = !self.multySelectedImageList.count ? @"上传" : [NSString stringWithFormat:@"上传(%lu)",(unsigned long)self.multySelectedImageList.count] ;
    [self.btUpload setTitle:strDisplay forState:0] ;
}

//#pragma mark - UIScrollViewDelegate


#pragma mark --
#pragma mark - CameraGroupCtrllerDelegate

- (void)selectAlbumnGroup:(PHAssetCollection *)collection {
    [self.imageList removeAllObjects] ;
    [self.multySelectedImageList removeAllObjects] ;
    
    [self showImgAssetsInGroup:collection] ;
    
    if (self.groupCtrller.view.superview) {
        [self.groupCtrller cameraGroupAnimation:!self.groupCtrller.view.superview onView:self.view] ;
        [self.collectionView reloadData] ;
        [self.btTitle setTitle:collection.localizedTitle forState:0] ;
        [self.btTitle setImagePosition:LXMImagePositionRight spacing:6] ;
    }
}

#pragma mark - story

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"camra2preview"]) {
        PreviewCtrller *previewVC = [segue destinationViewController] ;
        previewVC.assetList = sender ;
    }
}

@end
