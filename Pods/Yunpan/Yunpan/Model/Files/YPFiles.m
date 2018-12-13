//
//  YPFiles.m
//  Yunpan
//
//  Created by teason23 on 2018/9/20.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "YPFiles.h"
#import <XTlib/XTlib.h>
#import "UrlConfig.h"

@implementation YPFiles

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"idFiles" : @"id",
             } ;
}

#pragma mark - VM props

- (NSString *)downloadUrl {
    return [[UrlConfig sharedInstance] UrlAppend:STR_FORMAT(@"/files/%@/download",self.guid)] ;
}

- (BOOL)isImageType {
    return [self.type isEqualToString:@"image"] && !self.isFolder && self.thumbnailUrl.length > 0 ;
}

- (BOOL)isOfficeType {
    return self.displayType == YPFiles_DisplayType_Doc || self.displayType == YPFiles_DisplayType_Ppt || self.displayType == YPFiles_DisplayType_Sheet || self.displayType == YPFiles_DisplayType_Wps ;
}

- (NSString *)displayThumbNailStr {
    if (!self.isImageType) {
        NSString *tmpStr = @"" ;
        switch (self.displayType) {
            case YPFiles_DisplayType_Undefined:     tmpStr = @"ios_filetype_cannt_preview" ; break ;
            case YPFiles_DisplayType_Preview_Fail:  tmpStr = @"ios_filetype_failed_preview" ; break ;
            case YPFiles_DisplayType_Folder:        tmpStr = @"ios_filetype_folder" ; break ;
            case YPFiles_DisplayType_Doc:           tmpStr = @"ios_filetype_doc" ; break ;
            case YPFiles_DisplayType_Sheet:         tmpStr = @"ios_filetype_sheet" ; break ;
            case YPFiles_DisplayType_Image:         tmpStr = @"ios_filetype_image" ; break ;
            case YPFiles_DisplayType_Ppt:           tmpStr = @"ios_filetype_ppt" ; break ;
            case YPFiles_DisplayType_Pdf:           tmpStr = @"ios_filetype_pdf" ; break ;
            case YPFiles_DisplayType_Music:         tmpStr = @"ios_filetype_music" ; break ;
            case YPFiles_DisplayType_Wps:           tmpStr = @"ios_filetype_wps" ; break ;
            case YPFiles_DisplayType_Zip:           tmpStr = @"ios_filetype_zip" ; break ;
            case YPFiles_DisplayType_Video:         tmpStr = @"ios_filetype_video" ; break ;
            case YPFiles_DisplayType_PS:            tmpStr = @"ios_filetype_ps" ; break ;
            case YPFiles_DisplayType_Sketch:        tmpStr = @"ios_filetype_sketch" ; break ;
            case YPFiles_DisplayType_Ai:            tmpStr = @"ios_filetype_ai" ; break ;
            case YPFiles_DisplayType_Ae:            tmpStr = @"ios_filetype_ae" ; break ;
                
            default: break ;
        }
        return [NSString stringWithFormat:@"https://assets-cdn.shimo.im/filetype_icons/%@.png",tmpStr] ;
    }
    return self.thumbnailUrl ;
}

- (YPFiles_DisplayType)displayType {
    if (!_displayType) {
//        NSLog(@"subtype : %@",self.subtype) ;
        
        _displayType = YPFiles_DisplayType_Undefined ; // default
        
        if (self.isFolder) {
            _displayType = YPFiles_DisplayType_Folder ;
        }
        else if ([[self.class typesOfDoc] containsObject:[@"." stringByAppendingString:self.subtype]]) {
            _displayType = YPFiles_DisplayType_Doc ;
        }
        else if ([[self.class typesOfSheet] containsObject:[@"." stringByAppendingString:self.subtype]]) {
            _displayType = YPFiles_DisplayType_Sheet ;
        }
        else if ([[self.class typesOfImage] containsObject:[@"." stringByAppendingString:self.subtype]]) {
            _displayType = YPFiles_DisplayType_Image ;
        }
        else if ([[self.class typesOfPpt] containsObject:[@"." stringByAppendingString:self.subtype]]) {
            _displayType = YPFiles_DisplayType_Ppt ;
        }
        else if ([self.subtype isEqualToString:@"pdf"]) {
            _displayType = YPFiles_DisplayType_Pdf ;
        }
        else if ([[self.class typesOfMusic] containsObject:[@"." stringByAppendingString:self.subtype]]) {
            _displayType = YPFiles_DisplayType_Music ;
        }
        else if ([self.subtype isEqualToString:@"wps"]) {
            _displayType = YPFiles_DisplayType_Wps ;
        }
        else if ([[self.class typesOfZip] containsObject:[@"." stringByAppendingString:self.subtype]]) {
            _displayType = YPFiles_DisplayType_Zip ;
        }
        else if ([[self.class typesOfVideo] containsObject:[@"." stringByAppendingString:self.subtype]]) {
            _displayType = YPFiles_DisplayType_Video ;
        }
        else if ([self.subtype isEqualToString:@"psd"]) {
            _displayType = YPFiles_DisplayType_PS ;
        }
        else if ([self.subtype isEqualToString:@"sketch"]) {
            _displayType = YPFiles_DisplayType_Sketch ;
        }
        else if ([self.subtype isEqualToString:@"ai"]) {
            _displayType = YPFiles_DisplayType_Ai ;
        }
        else if ([self.subtype isEqualToString:@"ae"]) {
            _displayType = YPFiles_DisplayType_Ae ;
        }
        
    }
    return _displayType ;
}


#pragma mark - config

+ (NSArray *)typesOfImage {
    return @[
             @".jpg",
             @".jpeg",
             @".png",
             @".svg",
             @".raw",
             @".gif",
             @".bmp",
             @".webp",
//             @"sketch",
//             @"psd",
//             @"ai",
             @".ico"
             ] ;
}

+ (NSArray *)typesOfSheet {
    return @[
             @".numbers",
             @".xlsx",
             @".xlsm",
             @".xlsb",
             @".xltx",
             @".xltm",
             @".xls",
             @".xlt",
             @".xlam",
             @".xla",
             @".xlw",
             @".xlr"
             ] ;
}

+ (NSArray *)typesOfDoc {
    return @[
             @".pages",
             @".doc",
             @".docx",
             @".dotx",
             @".dotm",
             @".txt",
             @".md",
             @".xml",
             @".xps",
             ] ;
}

+ (NSArray *)typesOfPpt {
    return @[
             @".keynote",
             @".ppt",
             @".pptx",
             @".pot",
             @".potm",
             @".potx",
             @".pptm",
             @".pps",
             @".ppsm",
             @".ppsx",
             @".rtf",
             ] ;
}

+ (NSArray *)typesOfMusic {
    return @[
             @".aac",
             @".mp3",
             @".flac",
             @".rec",
             @".m4a",
             @".wav",
             @".aac",
             @".ogg",
             @".mogg",
             @".wma",
             @".ape",
             @".alac",
             @".wv",
             ] ;
}

+ (NSArray *)typesOfZip {
    return @[
             @".zip",
             @".rar",
             @".pkg",
             @".7z",
             @".tar",
             @".gz",
             ] ;
}

+ (NSArray *)typesOfVideo {
    return @[
             @".mp4",
             @".avi",
             @".mkv",
             @".swf",
             @".wmv",
             @".m2p",
             @".m4v",
             @".h264",
             @".h265",
             @".flv",
             ] ;
}


// get mimeType
+ (NSString *)mimeTypeForFileAtPath:(NSString *)path {
    // 这里使用文件管理者的相关方法判断文件路径是否有后缀名
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    // [path pathExtension] 获得文件的后缀名 MIME类型字符串转化为UTI字符串
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    // UTI字符串转化为后缀扩展名
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    // application/octet-stream，此参数表示通用的二进制类型。
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType);
    
//    NSURL* fileUrl = [NSURL fileURLWithPath:path];
//    NSURLRequest* fileUrlRequest = [[NSURLRequest alloc] initWithURL:fileUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:.1];
//
//    NSError* error = nil;
//    NSURLResponse* response = nil;
//    [NSURLConnection sendSynchronousRequest:fileUrlRequest returningResponse:&response error:&error];
//    return [response MIMEType];

}

@end
