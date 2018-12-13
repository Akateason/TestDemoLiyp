//
//  ViewController.m
//  TestYunpanSDK
//
//  Created by teason23 on 2018/10/18.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "ViewController.h"
#import <Yunpan/SHMDriveSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)action:(id)sender {
    UIViewController *vc = [[SHMDriveSDK sharedInstance] getStartCtrller] ;
    YPNavVC *nav = [[YPNavVC alloc] initWithRootViewController:vc] ;    
    [self presentViewController:nav animated:YES completion:nil] ;
}


@end
