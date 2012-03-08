//
//  AsyncImageDownloader.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-6.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "AsyncImageDownloader.h"
#import "ASIDownloadCache.h"


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
    [_downloadInfo setObject:delegate forKey:url];
}

- (void)dealloc
{
    [_downloadInfo release];
    [_downloadQ release];
    [super dealloc];
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    UIImage *image = [UIImage imageWithData:[request responseData]];
    id delegate = [_downloadInfo objectForKey:request.url];
    if (delegate != nil && [delegate respondsToSelector:@selector(imageDidFinishLoad:)]) {
        
        [delegate imageDidFinishLoad:image];
    }
    [_downloadInfo removeObjectForKey:request.url];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    id delegate = [_downloadInfo objectForKey:request.url];
    if (delegate != nil && [delegate respondsToSelector:@selector(imageDidFaildLoad:)]) {
        [delegate imageDidFaildLoad:request.error];
    }
    [_downloadInfo removeObjectForKey:request.url];
}

@end
