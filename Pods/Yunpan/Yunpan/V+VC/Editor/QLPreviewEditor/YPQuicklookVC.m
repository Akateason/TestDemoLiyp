//
//  YPQuicklookVC.m
//  Yunpan
//
//  Created by teason23 on 2018/11/2.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPQuicklookVC.h"
#import "DownloadRecordTB.h"
#import "YPFiles.h"

@implementation YPQuicklookVC

- (instancetype)initWithRec:(DownloadRecordTB *)rec {
    self = [super init];
    if (self) {
        _rec = rec ;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    self.dataSource = self ;
    self.delegate = self ;
}

#pragma mark - qldelegate

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController*)previewController {
    return 1 ;
}

- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx {
//    if ([self.rec.aFile.name hasSuffix:@"txt"] || [self.rec.aFile.name hasSuffix:@"TXT"]) {
//        // 处理txt格式内容显示有乱码的情况
//        NSData *fileData = [NSData dataWithContentsOfFile:self.rec.localPath];
//        // 判断是UNICODE编码
//        NSString *isUNICODE = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
//        // 还是ANSI编码（-2147483623，-2147482591，-2147482062，-2147481296）encoding 任选一个就可以了
//        NSString *isANSI = [[NSString alloc] initWithData:fileData encoding:-2147483623];
//        if (isUNICODE) {
//        } else {
//            NSData *data = [isANSI dataUsingEncoding:NSUTF8StringEncoding];
//            [data writeToFile:self.rec.localPath atomically:YES];
//        }
//        return [NSURL fileURLWithPath:self.rec.localPath];
//    }
//    else {
        NSURL *fileURL = nil;
        fileURL = [NSURL fileURLWithPath:self.rec.localPath];
        return fileURL;
//    }
}


@end
