//
//  PreviewCollectionCell.m
//  GroupBuying
//
//  Created by TuTu on 16/8/30.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "PreviewCollectionCell.h"


@interface PreviewCollectionCell () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *zoomImageView ;
@property (nonatomic,strong) UIImageView  *imgView ;

@end

@implementation PreviewCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect rect = CGRectZero ;
        rect.size = frame.size ;
        self.backgroundColor = [UIColor blackColor] ;
        
        self.imgView = ({
            UIImageView *iView = [[UIImageView alloc]initWithFrame:rect] ;
            iView.contentMode = UIViewContentModeScaleAspectFit ;
            iView ;
        }) ;
        
        self.zoomImageView = ({
            UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:rect] ;
            scrollview.maximumZoomScale = 2.;
            scrollview.minimumZoomScale = 1.;
            scrollview.showsHorizontalScrollIndicator = NO;
            scrollview.showsVerticalScrollIndicator   = NO;
            scrollview.delegate = self ;
            [scrollview addSubview:self.imgView] ;
            scrollview ;
        }) ;
        
        [self addSubview:self.zoomImageView] ;
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image ;
    
    self.imgView.image = image ;
}

- (void)resetStyle {
    [self.zoomImageView setZoomScale:1 animated:NO];
    
    CGRect rect = CGRectZero ;
    rect.size = self.frame.size ;
    self.imgView.frame = rect ;
}

#pragma mark - UIScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgView ;
}

@end
