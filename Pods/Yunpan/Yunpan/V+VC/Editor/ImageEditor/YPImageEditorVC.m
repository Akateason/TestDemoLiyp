//
//  YPImageEditorVC.m
//  Yunpan
//
//  Created by teason23 on 2018/10/13.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPImageEditorVC.h"
#import "YPImageEditorCell.h"
#import "YPIETopBar.h"
#import <XTlib.h>
#import <XTZoomPicture.h>
#import "YPDownloadManager.h"



@interface YPImageEditorVC () <UICollectionViewDelegate,UICollectionViewDataSource,YPIETopBarDelegate>
@property (strong, nonatomic) UICollectionView *collectionView ;
@property (strong, nonatomic) YPIETopBar *topbar ;
@property (strong, nonatomic) UIButton *btDownload ;

@property (copy, nonatomic) NSArray *ypfileList ;
@property (nonatomic) NSInteger currentIdx ;
@property (nonatomic) YPFileClickFrom_Type type ;
@end

@implementation YPImageEditorVC

+ (instancetype)showFromCtrller:(UIViewController *)fromCtrller {
    YPImageEditorVC *vc = [[YPImageEditorVC alloc] init] ;
    [fromCtrller.navigationController pushViewController:vc animated:YES] ;
    return vc ;
}

#pragma mark - YPIETopBarDelegate <NSObject>

- (void)closeOnClick {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (void)deleteOnClick {
    if (self.type == YPFileClickFrom_List) {
        
        NSMutableArray *guids = [@[] mutableCopy] ;
        [self.ypfileList enumerateObjectsUsingBlock:^(YPFiles * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [guids addObject:obj.guid] ;
        }] ;
        
        [[YPFolderMananger sharedInstance] deleteFileOnServerWithGuids:guids complete:^(bool success) {
            
        }] ;
    }
    else if (self.type == YPFileClickFrom_Download) {
        
        [[YPFolderMananger sharedInstance] deleteFileFromLocal:@[self.ypfileList[self.currentIdx]] complete:^(bool success) {
            
        }] ;
    }
}


#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    self.hidesBottomBarWhenPushed = YES ;
    
    self.collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init] ;
        layout.itemSize = self.view.bounds.size ;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal ;
        layout.minimumLineSpacing = 0 ;
        UICollectionView *cview = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout] ;
        cview.pagingEnabled = YES ;
        cview.backgroundColor = [UIColor blackColor] ;
        cview.dataSource = self ;
        cview.delegate = self ;
        [YPImageEditorCell registerClsFromCollection:cview] ;
        [self.view addSubview:cview] ;
        cview ;
    }) ;
    
    
    self.topbar = ({
        YPIETopBar *tbar = [YPIETopBar newFromCtrller:self] ;
        tbar.delegate = self ;
        tbar ;
    }) ;
    
    [self btDownload] ;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIdx inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO] ;
    
    @weakify(self)
    RAC(self.btDownload, hidden) = [[RACObserve(self, currentIdx) distinctUntilChanged] map:^NSNumber *_Nullable(NSNumber * _Nullable value) {
        @strongify(self)
        return @( [[YPDownloadManager sharedInstance] fileHasDownloaded:self.ypfileList[[value intValue]]] ) ;
    }] ;
}

- (void)setupWithImgFileList:(NSArray <YPFiles *>*)list
             currentImageIdx:(NSInteger)idx
                    fromType:(YPFileClickFrom_Type)type {
    
    self.type = type ;
    self.ypfileList = list ;
    self.currentIdx = idx ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated] ;
    [self.navigationController setNavigationBarHidden:NO animated:NO] ;
}

#pragma mark - collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.ypfileList.count ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YPImageEditorCell *cell = [YPImageEditorCell fetchFromCollection:collectionView indexPath:indexPath] ;
    [cell configure:self.ypfileList[indexPath.row]] ;
    return cell ;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    NSInteger currentPage = ((scrollView.contentOffset.x - width / 2) / width) + 2;
    self.topbar.title = [NSString stringWithFormat:@"%@/%@",@(currentPage) , @(self.ypfileList.count)] ;
    self.currentIdx = currentPage - 1 ;
 
    YPImageEditorCell *cell = (YPImageEditorCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIdx inSection:0]] ;
    [cell.zoomPic resetToOrigin] ;
    
}

- (UIButton *)btDownload{
    if(!_btDownload){
        _btDownload = ({
            UIButton * object = [[UIButton alloc]init];
            [object setImage:[UIImage imageNamed:@"ie_btdownload"] forState:0] ;
            [object addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside] ;
            if (!object.superview) {
                [self.view addSubview:object] ;
                [object mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(30, 30)) ;
                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-18) ;
                    make.right.equalTo(@-17) ;
                }] ;
            }
            object;
       });
    }
    return _btDownload;
}

- (void)downloadAction {
    [[YPDownloadManager sharedInstance] addOneFile:self.ypfileList[self.currentIdx] complete:^(BOOL success, DownloadRecordTB * _Nonnull rec) {
        
    }] ;    
}

@end
