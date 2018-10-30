//
//  SVGImageLoader.m
//  Yunpan
//
//  Created by teason23 on 2018/10/12.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "SVGImageLoader.h"

@interface SVGImageLoader () <UIWebViewDelegate>

@end

@implementation SVGImageLoader

+ (SVGImageLoader *)setupWithFrame:(CGRect)frame {
    
    SVGImageLoader *webView = [[SVGImageLoader alloc] initWithFrame:frame] ;
    webView.scalesPageToFit = NO ;
    webView.scrollView.scrollEnabled = NO ;
    webView.userInteractionEnabled = NO ;
    webView.delegate = (id)webView ;
    return webView ;
}

- (void)startLoadWithUrlStr:(NSString *)urlStr
                     header:(NSDictionary *)header {
    
    NSURL *url = [NSURL URLWithString:urlStr] ;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10] ;
    if (header) {
        for (NSString *key in header) {
            [request setValue:header[key] forHTTPHeaderField:key] ;
        }
    }
    
    //获取记录的response headers
    NSDictionary *cachedHeaders = [[NSUserDefaults standardUserDefaults] objectForKey:url.absoluteString] ;
    //设置request headers
    if (cachedHeaders) {
        // http://imweb.io/topic/5795dcb6fb312541492eda8c
        NSString *cacheControl = [cachedHeaders objectForKey:@"Cache-Control"] ; // 云盘后台通过这个字段判断
        if (cacheControl) {
            [request setValue:cacheControl forHTTPHeaderField:@"If-Modified-Since"] ;
        }
    }
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"======= %f",[[NSDate date] timeIntervalSince1970] * 1000);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"statusCode == %@", @(httpResponse.statusCode));
        // 判断响应的状态码
        if (httpResponse.statusCode == 304 || httpResponse.statusCode == 0) {
            //如果状态码为304或者0(网络不通?)，则设置request的缓存策略为读取本地缓存
            [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
        }
        else {
            //如果状态码为200，则保存本次的response headers，并设置request的缓存策略为忽略本地缓存，重新请求数据
            [[NSUserDefaults standardUserDefaults] setObject:httpResponse.allHeaderFields forKey:request.URL.absoluteString];
            //如果状态码为200，则设置request的缓存策略为忽略本地缓存
            [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        }
        
        //未更新的情况下读取缓存
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadRequest:request] ;
        });
    }] resume] ;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGSize contentSize = webView.scrollView.contentSize;
    CGSize webViewSize = webView.bounds.size;
    CGFloat scaleFactor = webViewSize.width / contentSize.width;
    
    webView.scrollView.minimumZoomScale = scaleFactor;
    webView.scrollView.maximumZoomScale = scaleFactor;
    webView.scrollView.zoomScale = scaleFactor;
    
    webView.delegate = nil ;
}

@end
