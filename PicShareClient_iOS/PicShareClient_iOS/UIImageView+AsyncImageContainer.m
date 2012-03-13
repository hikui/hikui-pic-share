//
//  UIImageView+AsyncImageContainer.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-6.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "UIImageView+AsyncImageContainer.h"

@implementation UIImageView (AsyncImageContainer)


- (void)setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    self.image = placeholder;
    AsyncImageDownloader *downloader = [AsyncImageDownloader sharedAsyncImageDownloader];
    [downloader loadImageWithUrl:url AndDelegate:self];
}

- (void)setImageWithUrl:(NSURL *)url
{
    AsyncImageDownloader *downloader = [AsyncImageDownloader sharedAsyncImageDownloader];
    [downloader loadImageWithUrl:url Delegate:self scaleSize:self.frame.size];
}

- (void)imageDidFinishLoad:(UIImage *)image
{
    self.image = image;
}

- (void)imageDidFaildLoad:(NSError *)error
{
#warning not implement yet
}

@end
