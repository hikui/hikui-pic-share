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
            UIImage *scaledImage = [AsyncImageDownloader imageWithImage:image scaledToSizeWithSameAspectRatio:scaleSize];
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


#pragma mark - image scale
/**
 如果比例和目标不一致，则裁掉比例大的部分。
 */
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
{  
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; 
        }
        else {
            scaleFactor = heightFactor; 
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }     
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }   
    
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
//    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
//        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
//        CGFloat oldScaledWidth = scaledWidth;
//        scaledWidth = scaledHeight;
//        scaledHeight = oldScaledWidth;
//        
//        CGContextRotateCTM (bitmap, radians(90));
//        CGContextTranslateCTM (bitmap, 0, -targetHeight);
//        
//    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
//        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
//        CGFloat oldScaledWidth = scaledWidth;
//        scaledWidth = scaledHeight;
//        scaledHeight = oldScaledWidth;
//        
//        CGContextRotateCTM (bitmap, radians(-90));
//        CGContextTranslateCTM (bitmap, -targetWidth, 0);
//        
//    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
//        // NOTHING
//    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
//        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
//        CGContextRotateCTM (bitmap, radians(-180.));
//    }
    
    CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage; 
}

- (void)cleanThumbnailCache
{
    [_thumbnailCache removeAllObjects];
}

@end
