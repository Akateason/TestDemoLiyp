//
//  ShiLoginContainerVC.m
//  SMSHLogin
//
//  Created by teason23 on 2018/12/4.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "ShiLoginContainerVC.h"
#import "ShimoLoginVC.h"
#import "ShimoVerifyLoginVC.h"
#import <XTBase/XTBase.h>


@interface ShiLoginContainerVC () <SMSHLoginContainerProtocol>
@property (strong, nonatomic) ShimoLoginVC *defaultLoginVC ;
@property (strong, nonatomic) ShimoVerifyLoginVC *verifyLoginVC ;
@end

@implementation ShiLoginContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    [self defaultLoginVC] ;
    [self verifyLoginVC] ;
    
    [self.view bringSubviewToFront:self.defaultLoginVC.view] ;
}

#pragma mark - SMSHLoginContainerProtocol <NSObject>

- (void)checkoutButtonClick:(int)idx {
    if (idx == 2) {
        
        [UIView transitionWithView:self.view duration:.6 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            [self.view bringSubviewToFront:self.defaultLoginVC.view] ;
        } completion:^(BOOL finished) {
        }] ;
        
    }
    else if (idx == 1) {
        
        [UIView transitionWithView:self.view duration:.6 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            [self.view bringSubviewToFront:self.verifyLoginVC.view] ;
        } completion:^(BOOL finished) {
        }] ;

    }
}

- (UIViewController *)outsideCtrller {
    return self ;
}

- (ShimoLoginVC *)defaultLoginVC{
    if(!_defaultLoginVC){
        _defaultLoginVC = ({
            ShimoLoginVC *vc = [ShimoLoginVC getCtrllerFromNIBWithBundle:[NSBundle bundleForClass:self.class]] ;
            vc.delegate = self ;
            [self.view addSubview:vc.view] ;
            [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view) ;
            }] ;
            vc;
       });
    }
    return _defaultLoginVC;
}

- (ShimoVerifyLoginVC *)verifyLoginVC{
    if(!_verifyLoginVC){
        _verifyLoginVC = ({
            ShimoVerifyLoginVC * object = [ShimoVerifyLoginVC getCtrllerFromNIBWithBundle:[NSBundle bundleForClass:self.class]] ;
            object.delegate = self ;
            [self.view addSubview:object.view] ;
            [object.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view) ;
            }] ;
            object;
       });
    }
    return _verifyLoginVC;
}

@end
