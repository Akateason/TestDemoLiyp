//
//  SMLoginAnimation.m
//  SMSHLogin
//
//  Created by teason23 on 2018/12/17.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "SMLoginAnimation.h"
#import <XTColor/XTColor.h>
#import <Masonry/Masonry.h>

@implementation SMLoginAnimation

+ (void)zoomAndFade:(UIView *)item
           complete:(void(^)(void))complete {
    
    [UIView animateWithDuration:.1 delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        item.layer.transform = CATransform3DScale(item.layer.transform, .95, .95, 1) ;
        item.alpha = .7 ;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.2 delay:0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
            item.layer.transform = CATransform3DIdentity ;
            item.alpha = 1 ;
            
        } completion:^(BOOL finished) {
            if (complete) complete() ;
        }] ;
        
    }] ;
}


@end



@interface BarUnderLoginTextInputLine ()
@property (strong, nonatomic) UIView *innerBar ;
@end

@implementation BarUnderLoginTextInputLine

- (void)awakeFromNib {
    [super awakeFromNib] ;
    
    [self innerBar] ;
}

- (void)startMove {
    [self endState] ;
    
    [UIView animateWithDuration:.6 delay:0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        [self setNeedsLayout] ;
        [self layoutIfNeeded] ;
    } completion:^(BOOL finished) {
        
    }] ;
}

- (void)resetMove {
    [self originState] ;
    
    [UIView animateWithDuration:.6 delay:0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        [self setNeedsLayout] ;
        [self layoutIfNeeded] ;
    } completion:^(BOOL finished) {
        
    }] ;
}

- (void)originState {
    [self.innerBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0) ;
    }];
}

- (void)endState {
    [self.innerBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo( CGRectGetWidth(self.frame) ) ;
    }];
}

- (UIView *)innerBar{
    if(!_innerBar){
        _innerBar = ({
            UIView * object = [[UIView alloc] init];
            object.backgroundColor = UIColorRGB(65, 70, 75);
            [self addSubview:object];
            [object mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.equalTo(@0);
            }];
            object;
       });
    }
    return _innerBar;
}

@end
