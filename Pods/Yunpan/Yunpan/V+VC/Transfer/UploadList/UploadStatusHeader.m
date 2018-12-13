//
//  UploadStatusHeader.m
//  Yunpan
//
//  Created by teason23 on 2018/9/19.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "UploadStatusHeader.h"
#import <Masonry/Masonry.h>
#import <XTlib/XTlib.h>

@interface UploadStatusHeader ()
@property (strong, nonatomic) UILabel *lbTitle;
@end

@implementation UploadStatusHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.lbTitle = ({
            UILabel *lb = [UILabel new] ;
            lb.font = [UIFont systemFontOfSize:13] ;
            lb.textColor = UIColorRGBA(65, 70, 75, .3) ;
            [self addSubview:lb] ;
            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@20) ;
                make.centerY.equalTo(self) ;
            }] ;
            lb ;
        }) ;
    }
    return self;
}

- (void)setSectionTitle:(NSString *)sectionTitle {
    _sectionTitle = sectionTitle ;
    
    self.lbTitle.text = sectionTitle ;
}

@end
