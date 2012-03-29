//
//  AsyncImageDownloader.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-6.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "AsyncImageDownloader.h"
#import "ASIDownloadCache.h"
#import "UIImageView+Resize.h"


@implementation AsyncImageDownloader

@synthesize asyncImageContainer = _asyncImageContainer;

static AsyncImageDownloader *instance = NULL;

- (id)init
{
    self = [super init];
    if (self) {
        _downloadQ = [[NSOperationQueue alloc]init];
        [_downloadQ setMaxConcurrentOperationCount:3];
        _downloadInfo = [[NSMutableDictionary alloc]init];
        _thumbnailCache = [[NSMutableDictionary alloc]init];
    }
    return self;
}

+ (id)sharedAsyncImageDownloader
{
    @synchronized (self)
    {
        if (instance == NULL) {
            instance = [[AsyncImageDownloader alloc]init];
        }
        return instance;
    }
}

- (void)loadImageWithUrl:(NSURL *)url AndDelegate:(id)delegate
{
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:url];
    [request setDelegate:self];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    [_downloadQ addOperation:request];
    NSDictionary *info = [[NSDictionary alloc]initWithObjectsAndKeys:delegate,@"delegate",[NSNumber numberWithBool:NO],@"needScale",[NSNull null],@"scaleSize", nil];
    [_downloadInfo setObject:info forKey:url];
    [info release];
}

- (void)loadImageWithUrl:(NSURL *)url Delegate:(id)delegate scaleSize:(CGSize)size
{
    NSDictionary *cachedScaledImageInfo = [_thumbnailCache objectForKey:url];
    if (cachedScaledImageInfo != nil) {
        CGSize cachedScaleSize = [[cachedScaledImageInfo objectForKey:@"scaleSize"]CGSizeValue];
        if (size.width == cachedScaleSize.width && size.height == cachedScaleSize.height) {
            [delegate imageDidFinishLoad:[cachedScaledImageInfo objectForKey:@"image"]];
            return;
        }
    }
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:url];
    [request setDelegate:self];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    [_downloadQ addOperation:request];
    NSDictionary *info = [[NSDictionary alloc]initWithObjectsAndKeys:delegate,@"delegate",[NSNumber numberWithBool:YES],@"needScale",[NSValue valueWithCGSize:size],@"scaleSize", nil];
    [_downloadInfo setObject:info forKey:url];
    [info release];
}

- (void)dealloc
{
    [_downloadInfo release];
    [_downloadQ release];
    [_thumbnailCache release];
    [super dealloc];
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    UIImage *image = [UIImage imageWithData:[request responseData]];
    NSDictionary *info = [_downloadInfo objectForKey:request.url];
    if (info!=nil && (NSNull *)info!=[NSNull null]) {
        id delegate = [info objectForKey:@"delegate"];
        if ([[info objectForKey:@"needScale"]boolValue]) {
            NSValue *nsScaleSize = [info objectForKey:@"scaleSize"];
            CGSize scaleSize = [nsScaleSize CGSizeValue];
            //scale image
            UIImage *scaledImage = [UIImageView imageWithImage:image scaledToSizeWithSameAspectRatio:scaleSize];
            //add to thumbnailCache
            NSDictionary *thumbnailInfo = [[NSDictionary alloc]initWithObjectsAndKeys:scaledImage,@"image",[NSValue valueWithCGSize:scaleSize],@"scaleSize", nil];
            [_thumbnailCache setObject:thumbnailInfo forKey:request.url];
            [thumbnailInfo release];
            [delegate imageDidFinishLoad:scaledImage];
        }
        else {
            [delegate imageDidFinishLoad:image];
        }
    }
    [_downloadInfo removeObjectForKey:request.url];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [_downloadInfo removeObjectForKey:request.url];
}

- (void)cancelLoadImageWithUrl:(NSURL *)url andDelegate:(id)delegate
{
    
}

- (void)cleanThumbnailCache
{
    [_thumbnailCache removeAllObjects];
}

@end
