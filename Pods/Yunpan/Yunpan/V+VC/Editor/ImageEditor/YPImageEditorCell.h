//
//  YPImageEditorCell.h
//  Yunpan
//
//  Created by teason23 on 2018/10/13.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "RootCollectionCell.h"
@class XTZoomPicture ;

NS_ASSUME_NONNULL_BEGIN

@interface YPImageEditorCell : RootCollectionCell
@property (strong, nonatomic, readonly) XTZoomPicture *zoomPic ;
@end

NS_ASSUME_NONNULL_END
