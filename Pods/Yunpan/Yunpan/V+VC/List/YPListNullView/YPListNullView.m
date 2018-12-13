//
//  YPListNullView.m
//  Yunpan
//
//  Created by teason23 on 2018/10/18.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPListNullView.h"
#import <XTlib/XTlib.h>
#import "UIImage+Yunpan.h"


@implementation YPListNullView

- (instancetype)initWithTip:(NSString *)tip {
    
    self = [super init];
    if (self) {
        self.frame = APPFRAME ;
        self.backgroundColor = [UIColor whiteColor] ;
        
        UILabel *label = [UILabel new] ;
        label.text = tip ;
        label.textColor = UIColorRGBA(65,70,75,.2) ;
        label.font = [UIFont systemFontOfSize:15] ;
        label.textAlignment = NSTextAlignmentCenter ;
        [self addSubview:label] ;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX) ;
            make.centerY.equalTo(self).offset(50) ;
        }] ;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage shmyp_imageNamed:@"null_list_img" fromBundleClass:self.class]] ;
        imageView.contentMode = UIViewContentModeScaleAspectFit ;
        [self addSubview:imageView] ;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60)) ;
            make.centerX.equalTo(self.mas_centerX) ;
            make.bottom.equalTo(label.mas_top).offset(-20) ;
        }] ;
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
