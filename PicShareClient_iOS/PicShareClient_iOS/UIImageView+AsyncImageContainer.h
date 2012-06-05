//
//  UIImageView+AsyncImageContainer.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-6.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageDownloader.h"

@interface UIImageView (AsyncImageContainer) <AsyncImageContainer>

/**
 设定UIImageView的图像，通过URL异步载入（同SDWebImage）
 */
- (void)setImageWithUrl:(NSURL *)url;
/**
 设定UIImageView的图像，载入之前使用占位图像，通过URL异步载入（同SDWebImage）
 */
- (void)setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
