//
//  PreviewCtrller.m
//  GroupBuying
//
//  Created by TuTu on 16/8/30.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "PreviewCtrller.h"
#import "PreviewCollectionCell.h"
#import <Photos/Photos.h>
#import <XTlib.h>

@interface PreviewCtrller () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;


@end

@implementation PreviewCtrller

- (void)setAssetList:(NSArray *)assetList {
    _assetList = assetList ;
    
    [_collectionview reloadData] ;
    self.title = [NSString stringWithFormat:@"1 / %@",@(self.assetList.count)] ;
}

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    _collectionview.backgroundColor = [UIColor blackColor] ;
    _collectionview.pagingEnabled = YES ;
    _collectionview.dataSource = self ;
    _collectionview.delegate = self ;
    [_collectionview registerClass:[PreviewCollectionCell class] forCellWithReuseIdentifier:idPreviewCollectionCell] ;
}

#pragma mark - collection dataSourse

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetList.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PreviewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idPreviewCollectionCell forIndexPath:indexPath] ;
    if (!cell) {
        cell = [[PreviewCollectionCell alloc] initWithFrame:self.view.frame] ;
    }
    [cell resetStyle] ;
    
    
    PHAsset *asset = self.assetList[indexPath.row] ;
//    NSArray *list = [PHAssetResource assetResourcesForAsset:asset] ;
//    PHAssetResource *resource = list.firstObject ;
//    NSString *name = resource.originalFilename ;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init] ;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
         cell.image = result ;
     }] ;
    
    return cell ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size ;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    NSInteger currentPage = ((scrollView.contentOffset.x - width / 2) / width) + 2;
    self.title = [NSString stringWithFormat:@"%@/%@",@(currentPage) , @(self.assetList.count)] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
