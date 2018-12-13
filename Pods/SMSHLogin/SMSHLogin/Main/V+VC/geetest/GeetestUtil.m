//
//  GeetestUtil.m
//  SMSHLogin
//
//  Created by teason23 on 2018/12/10.
//  Copyright © 2018 teason23. All rights reserved.
//

#import "GeetestUtil.h"
#import <GT3Captcha/GT3Captcha.h>
#import "../../SMSHLoginAPIs.h"
#import <YYModel/YYModel.h>

typedef void(^GeetestComplete)(NSDictionary *resultDic);

@interface GeetestUtil () <GT3CaptchaManagerDelegate>
@property (strong, nonatomic) GT3CaptchaManager *manager ;
@property (copy, nonatomic) GeetestComplete blkGtComplete ;
@end

@implementation GeetestUtil
XT_SINGLETON_M(GeetestUtil)

- (void)startGTViewBlkComplete:(void(^)(NSDictionary *resultDic))completion {
    [self.manager startGTCaptchaWithAnimated:YES];
    self.blkGtComplete = completion;
}

#pragma mark - geetest

- (GT3CaptchaManager *)manager {
    if (!_manager) {
        _manager = [[GT3CaptchaManager alloc] initWithAPI1:[SMSHLoginAPIs UrlAppend:@"/captchas"] API2:nil timeout:5.0];
        _manager.delegate = self;
        [_manager registerCaptcha:nil];
    }
    return _manager;
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error {
    NSLog(@"error: %@", error);
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendRequestAPI1:(NSURLRequest *)originalRequest withReplacedHandler:(void (^)(NSURLRequest *))replacedHandler {
    NSMutableURLRequest *mRequest = [originalRequest mutableCopy];
    mRequest.HTTPMethod = @"POST";
    mRequest.allHTTPHeaderFields = [SMSHLoginAPIs defaultHeader];
    
    NSString *dataString = [@{@"type":@"mobile",@"version":@"3.0"} yy_modelToJSONString];
    NSData *dataBody = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    mRequest.HTTPBody = dataBody;
    
    replacedHandler(mRequest);
}

- (BOOL)shouldUseDefaultSecondaryValidate:(GT3CaptchaManager *)manager {
    return NO;
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveCaptchaCode:(NSString *)code result:(NSDictionary *)result message:(NSString *)message {
//    "geetest_challenge" = b4fdafac2140efe3818ae9a6d06606bc;
//    "geetest_seccode" = "0d1a70bb4e3e52f77c1dc33facfc39d2|jordan";
//    "geetest_validate" = 0d1a70bb4e3e52f77c1dc33facfc39d2;

    if (code.intValue == 1) {
        NSDictionary *header = @{@"X-Geetest-Version":@"3.0",
                                 @"X-Geetest-Type":@"mobile",
                                 @"X-Geetest-Challenge":result[@"geetest_challenge"],
                                 @"X-Geetest-Validate":result[@"geetest_validate"],
                                 @"X-Geetest-Seccode":result[@"geetest_seccode"]};
        self.blkGtComplete(header);
    }
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy))decisionHandler {
    
}



@end
