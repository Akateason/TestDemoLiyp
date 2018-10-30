//
//  TransVCTitleView.m
//  Yunpan
//
//  Created by teason23 on 2018/10/12.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "TransVCTitleView.h"
#import <XTlib.h>

@implementation TransVCTitleView

#define kTransVCTitleView_Width  (APP_WIDTH / 3.)

+ (TransVCTitleView *)newOne {
    TransVCTitleView *_segment = [[TransVCTitleView alloc] initWithDataList:@[@"下载",@"上传"] imgBg:nil imgColor:UIColorRGB(65, 70, 75) size:CGSizeMake(kTransVCTitleView_Width, 44) normalColor:UIColorRGB(122, 125, 129) selectColor:UIColorRGB(65, 70, 75) font:[UIFont systemFontOfSize:17.]] ;
    _segment.frame = CGRectMake(0, 0, kTransVCTitleView_Width, 44) ;
    return _segment ;
}

- (CGSize)intrinsicContentSize {
    //fills empty space. View will be resized to be smaller, but if it is too small - then it stays too small
    return CGSizeMake(kTransVCTitleView_Width, 44) ;
}

@end
