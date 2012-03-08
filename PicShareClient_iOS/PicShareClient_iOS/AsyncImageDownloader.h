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
    NSOperationQueue *_downloadQ;
    NSMutableDictionary *_downloadInfo;
}

@property (nonatomic,assign) id<AsyncImageContainer> asyncImageContainer;

+ (id)sharedAsyncImageDownloader;

- (void)loadImageWithUrl:(NSURL *)url AndDelegate:(id)delegate;

@end
