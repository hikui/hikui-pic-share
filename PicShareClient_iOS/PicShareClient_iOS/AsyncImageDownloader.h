//
//  AsyncImageDownloader.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-6.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"

@protocol AsyncImageContainer <NSObject>

- (void)imageDidFinishLoad:(UIImage *)image;
- (void)imageDidFaildLoad:(NSError *)error;

@end

@interface AsyncImageDownloader : NSObject <ASIHTTPRequestDelegate>
{
    NSOperationQueue *_downloadQ; //!<异步下载队列
    NSMutableDictionary *_downloadInfo; //!<图片异步下载时要保存的信息
    NSMutableDictionary *_thumbnailCache; //!<缩略图缓存
}

@property (nonatomic,assign) id<AsyncImageContainer> asyncImageContainer;

+ (id)sharedAsyncImageDownloader;

- (void)loadImageWithUrl:(NSURL *)url AndDelegate:(id)delegate;
/**
 下载图片并缩放
 */
- (void)loadImageWithUrl:(NSURL *)url Delegate:(id)delegate scaleSize:(CGSize)size;
/**
 取消某图片的下载
 */
- (void)cancelLoadImageWithUrl:(NSURL *)url andDelegate:(id)delegate;
/**
 清除缩略图缓存，在memory warning时必须调用
 */
- (void)cleanThumbnailCache;
@end
