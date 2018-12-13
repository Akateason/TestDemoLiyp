//
//  YPListSortView.m
//  Yunpan
//
//  Created by teason23 on 2018/10/8.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPListSortView.h"
#import "YPSortConditionCell.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "YPFiles.h"
#import "YPFiles+Sort.h"

@interface YPListSortView () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) UIView *colorBg ;
@property (strong, nonatomic) UIButton *bgButton ;
@end

@implementation YPListSortView

+ (void)showFromCtrller:(UIViewController *)fromCtrller
         underWhichView:(UIView *)underWView
        sortInfoChoosen:(ChoosenSortInfo)blk {

    UINib *nib = [UINib nibWithNibName:@"YPListSortView" bundle:[NSBundle bundleForClass:self.class]] ;
    YPListSortView *aView = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0] ;
    aView.blkChoosenSortInfo = blk ;
    
    [fromCtrller.view.window addSubview:aView.colorBg] ;
//    [fromCtrller.view addSubview:aView.colorBg] ;
    [aView.colorBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(underWView.mas_bottom) ;
        make.right.left.bottom.equalTo(fromCtrller.view) ;
    }] ;
    
    [fromCtrller.view.window addSubview:aView.bgButton] ;
//    [fromCtrller.view addSubview:aView.bgButton] ;
    [aView.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(fromCtrller.view.window) ;
    }] ;
    
//    [fromCtrller.view addSubview:aView] ;
    [fromCtrller.view.window addSubview:aView] ;
    [aView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(underWView.mas_bottom) ;
        make.left.right.equalTo(fromCtrller.view) ;
        make.height.equalTo(@260) ;
    }] ;
    @weakify(aView)
    [[aView.bgButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(aView)
        [aView dismiss] ;
    }] ;
    
    [fromCtrller.view bringSubviewToFront:underWView] ;
}

- (void)dismiss {
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.layer.transform = CATransform3DTranslate(self.layer.transform, 0, - self.frame.size.height, 0) ;
//        self.layer.transform = CATransform3DScale(self.layer.transform, 1, 0, 1) ;
//        self.frame = CGRectMake(0, self.frame.origin.y, 0, 0) ;
        self.alpha = 0 ;
        self.colorBg.alpha = 0 ;
    } completion:^(BOOL finished) {
        [self.colorBg removeFromSuperview] ;
        [self.bgButton removeFromSuperview] ;
        [self removeFromSuperview] ;
        self.colorBg = nil ;
        self.bgButton = nil ;
    }] ;
}

- (void)awakeFromNib {
    [super awakeFromNib] ;
    _table.dataSource = self ;
    _table.delegate = self ;
//    [[YPListSortManager sharedInstance] setup] ;
    [YPSortConditionCell xt_registerNibFromTable:_table bundleOrNil:[NSBundle bundleForClass:YPSortConditionCell.class]] ;
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YPSortConditionCell *cell = [YPSortConditionCell fetchFromTable:tableView] ;
    [cell configure:nil indexPath:indexPath] ;
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YPSortConditionCell cellHeight] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[YPListSortManager sharedInstance] choosenWithType:indexPath.row + 1] ;
    [tableView reloadData] ;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss] ;
        self.blkChoosenSortInfo([YPListSortManager sharedInstance]) ;
    });
}

- (UIView *)colorBg{
    if(!_colorBg){
        _colorBg = ({
            UIView *colorBg = [UIView new] ;
            colorBg.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5] ;
            colorBg ;
       });
    }
    return _colorBg;
}

- (UIButton *)bgButton{
    if(!_bgButton){
        _bgButton = ({
            UIButton *bgButton = [UIButton new] ;
            bgButton ;
       });
    }
    return _bgButton;
}

@end


@implementation YPListSortManager
XT_SINGLETON_M(YPListSortManager)
+ (NSString *)stringForType:(YPListSortType)sortType {
    NSArray *strList = @[@"更新时间",@"创建时间",@"大小",@"文件名",@"所有者"] ;
    return strList[sortType - 1] ;
}

- (YPListSortType)sortType {
    if (!_sortType) {
        _sortType = YPListSortType_updateTime ;
    }
    return _sortType ;
}

- (void)setup {
    @weakify(self)
    [[self rac_valuesAndChangesForKeyPath:@"sortType" options:NSKeyValueObservingOptionOld observer:self] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        id newObject = tuple.first;
        NSDictionary *change = tuple.second;
        id oldObject = change[NSKeyValueChangeOldKey];
        NSLog(@"old %@, new %@",oldObject,newObject) ;
        if ([newObject integerValue] == [oldObject integerValue]) {
            self.sortOrder  = !self.sortOrder ;
        }
        else {
            self.sortOrder  = NO ;
        }
    }] ;
}

- (void)choosenWithType:(YPListSortType)sortType {
    self.sortType   = sortType ;
}

- (NSArray *)startSort:(NSArray *)array {
    NSArray *tmplist = @[] ;
    switch (self.sortType) {
        case YPListSortType_updateTime: {
            tmplist = [YPFiles arraySortedByUpdatedAt:array order:self.sortOrder] ;
        }
            break;
        case YPListSortType_createTime: {
            tmplist = [YPFiles arraySortedByCreatedAt:array order:self.sortOrder] ;
        }
            break;
        case YPListSortType_size: {
            tmplist = [YPFiles arraySortedBySizeAt:array order:self.sortOrder] ;
        }
            break;
        case YPListSortType_fileName: {
            tmplist = [YPFiles arraySortedByFileNameAt:array order:self.sortOrder] ;
        }
            break;
        case YPListSortType_author: {
            tmplist = [YPFiles arraySortedByAuthor:array] ;
        }
            break;
        default:
            break;
    }
    
    return tmplist ;
}

@end
