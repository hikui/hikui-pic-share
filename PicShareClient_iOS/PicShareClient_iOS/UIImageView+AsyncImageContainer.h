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

- (void)setImageWithUrl:(NSURL *)url;
- (void)setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
