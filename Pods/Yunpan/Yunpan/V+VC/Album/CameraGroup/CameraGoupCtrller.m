//
//  CameraGoupCtrller.m
//  GroupBuying
//
//  Created by TuTu on 16/8/24.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "CameraGoupCtrller.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CameraGroupCell.h"
#import <Photos/Photos.h>

@interface CameraGoupCtrller () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *groupList ;
@property (nonatomic,strong) UITableView *table ;

@end

@implementation CameraGoupCtrller

#pragma mark - public

- (void)cameraGroupAnimation:(BOOL)inOrOut onView:(UIView *)view {
    if (inOrOut) {
        [view addSubview:self.view] ;
        float transformY = - self.view.frame.size.height ;
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY) ;
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.view.transform = CGAffineTransformIdentity ;
                         }] ;
    }
    else {
        [UIView animateWithDuration:0.5
                         animations:^{
                             float transformY = - self.view.frame.size.height ;
                             self.view.transform = CGAffineTransformMakeTranslation(0, transformY) ;
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 [self.view removeFromSuperview] ;
                             }
                         }] ;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init] ;
    if (self) {
        self.view.frame = frame ;
        [self table] ;
        
//        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        // 按时间排序
//        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO]] ;

        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil] ;
        for (NSInteger i = 0; i < smartAlbums.count; i++) {
            PHCollection *collection = smartAlbums[i];
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
                if (fetchResult.count) {
                    [self.groupList addObject:assetCollection] ;
                }
                [_table reloadData] ;
            }
        }
    }
    return self;
}

#pragma mark - life
#pragma mark -

- (NSMutableArray *)groupList {
    if (!_groupList) {
        _groupList = [@[] mutableCopy] ;
    }
    return _groupList ;
}

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:self.view.bounds] ;
        _table.delegate = self ;
        _table.dataSource = self ;
        _table.separatorStyle = 0 ;
        [_table registerNib:[UINib nibWithNibName:identifierCameraGroupCell bundle:nil] forCellReuseIdentifier:identifierCameraGroupCell] ;
        if (!_table.superview) {
            [self.view addSubview:_table] ;
        }
    }
    return _table ;
}


#pragma mark --
#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupList.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CameraGroupCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierCameraGroupCell] ;
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifierCameraGroupCell] ;
    }
    cell.group = self.groupList[indexPath.row] ;
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.0f ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController popViewControllerAnimated:YES] ;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAlbumnGroup:)]) {
        [self.delegate selectAlbumnGroup:self.groupList[indexPath.row]] ;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
