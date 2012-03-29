//
//  PSThumbnailImageView2.m
//  PicShareClient_iOS
//
//  Created by 缪和光 on 12-3-26.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "PSThumbnailImageView.h"
#import "Common.h"
#import "UIImageView+Resize.h"
#import "ASIDownloadCache.h"

@interface PSThumbnailImageView ()

-(void)resizeImageInBackground:(UIImage *)image;

@end

@implementation PSThumbnailImageView
@synthesize theUrl,imageView,theRequest;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.imageView];
    }
    return self;
}


- (void)dealloc
{
    [self icancelImageLoading];
    [imageView release];
    [theUrl release];
    [super dealloc];
}

//这个方法在tableview滚动的时候经常被调用。此时不应该停止载入。
- (void)clearImage
{
    if (theRequest != nil) {
        [theRequest setDelegate:nil];
    }
    self.imageView.image = nil;
    self.theUrl = nil;
}
- (void)setImageWithUrl:(NSURL *)url
{
    self.theUrl = url;
    Common *common = [Common sharedCommon];
    NSMutableDictionary *thumbnailCache = common.thumbnailCache;
    UIImage *cachedImage = [thumbnailCache objectForKey:url];
    if (cachedImage!=nil) {
        self.imageView.image = cachedImage;
        return;
    }
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:url];
    self.theRequest = request;
    [request setDelegate:self];
    [request setNumberOfTimesToRetryOnTimeout:0];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    NSOperationQueue *globalDownloadQ = common.globalDownloadImageQ;
    [globalDownloadQ addOperation:request];
    
}
- (void)setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    self.theRequest = nil;
    UIImage *image = [UIImage imageWithData:[request responseData]];
    //self.imageView.image = image;
    [self performSelectorInBackground:@selector(resizeImageInBackground:) withObject:image];
}


-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}

-(void)resizeImageInBackground:(UIImage *)image
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    [image retain];
    
    UIImage *thumbnail = [UIImageView imageWithImage:image scaledToSizeWithSameAspectRatio:self.frame.size];
    Common *common = [Common sharedCommon];
    NSMutableDictionary *thumbnailCache = common.thumbnailCache;
    [thumbnailCache setObject:thumbnail forKey:self.theUrl];
    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    [image release];
    [pool release];
}

-(void)icancelImageLoading
{
    if (theRequest != nil) {
        [theRequest clearDelegatesAndCancel];
        [theRequest release];
    }
}

- (void)iResumeImageLoading
{
    if (self.theUrl != nil && self.imageView.image != nil) {
        [self setImageWithUrl:theUrl];
    }
}
@end
