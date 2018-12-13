//
//  YPNavVC.m
//  Yunpan
//
//  Created by teason23 on 2018/11/2.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPNavVC.h"

@interface YPNavVC ()

@end

@implementation YPNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBarTintColor:[UIColor whiteColor]] ;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}] ;
    [self.navigationBar setTintColor:[UIColor blackColor]] ;
    [self.navigationBar setBackgroundColor:[UIColor whiteColor]] ;
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
