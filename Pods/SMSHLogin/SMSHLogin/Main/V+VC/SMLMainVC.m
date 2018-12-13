//
//  SMLMainVC.m
//  SMSHLogin
//
//  Created by teason23 on 2018/11/30.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "SMLMainVC.h"
#import "SMSHLoginAPIs.h"
#import "ShimoLogin/ShimoLoginVC.h"
#import "../SMSHLoginManager.h"
#import "ShimoLoginNavVC.h"
#import <XTBase/XTBase.h>
#import "ShiLoginContainerVC.h"
#import "OpenShare+Weixin.h"

@interface SMLMainVC ()
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIButton *btWechat;


@end

@implementation SMLMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.btWechat xt_setImagePosition:XTBtImagePositionLeft spacing:6] ;
    
    if ( ([SMSHLoginManager sharedInstance].configure != nil) && [[SMSHLoginManager sharedInstance].configure respondsToSelector:@selector(containCustomView)] ){
        UIView *placehold = [SMSHLoginManager sharedInstance].configure.containCustomView ;
        [self.customView addSubview:placehold] ;
        [placehold mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.customView) ;
        }] ;
    }
    else { // default container view
        UILabel *lb = [UILabel new];
        lb.text = @"石墨";
        lb.textAlignment = NSTextAlignmentCenter;
        lb.textColor = UIColorRGB(65, 70, 75);
        lb.backgroundColor = [UIColor whiteColor];
        lb.font = [UIFont fontWithName:@"Songti SC" size:APP_WIDTH / 4];
        [self.customView addSubview:lb] ;
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.customView) ;
        }] ;
    }
    
    
    if ( ![[SMSHLoginManager sharedInstance].configure respondsToSelector:@selector(weixinAppID)] || ![SMSHLoginManager sharedInstance].configure.weixinAppID.length ) {
        self.btWechat.hidden = YES ;
    }
}

- (IBAction)wechatlogin:(id)sender {
    [OpenShare WeixinAuth:@"snsapi_userinfo" Success:^(NSDictionary *message) {
        NSLog(@"微信登录成功:\n%@",message);
    } Fail:^(NSDictionary *message, NSError *error) {
        NSLog(@"微信分享到朋友圈失败：\n%@\n%@",error,message);
    }] ;
}

- (IBAction)shimologin:(id)sender {
    ShiLoginContainerVC *vc = [[ShiLoginContainerVC alloc] init] ;
    [self.navigationController pushViewController:vc animated:YES] ;
}

@end
