//
//  ShimoLoginNavVC.m
//  SMSHLogin
//
//  Created by teason23 on 2018/11/30.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "ShimoLoginNavVC.h"
#import <XTBase/XTBase.h>

@interface ShimoLoginNavVC ()

@end

@implementation ShimoLoginNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImage *backBtn = [UIImage imageNamed:@"back"];
    self.navigationBar.backIndicatorImage = backBtn;
    self.navigationBar.backIndicatorTransitionMaskImage = backBtn;
    self.navigationBar.topItem.title = @"";
    self.navigationBar.tintColor = UIColorRGB(65, 70, 75) ;
    self.navigationBar.backgroundColor = [UIColor whiteColor] ;
    self.navigationBar.barTintColor = [UIColor whiteColor] ;
    UIImage *whiteLine = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(APP_WIDTH, 2)] ;
    [self.navigationBar setBackgroundImage:whiteLine forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new] ;
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
