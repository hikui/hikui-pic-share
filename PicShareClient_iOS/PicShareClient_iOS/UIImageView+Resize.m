//
//  UIImageView+Resize.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-15.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "UIImageView+Resize.h"

@implementation UIImageView (Resize)

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        // Retina display
        targetSize.width *=2;
        targetSize.height *=2;
    } 
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

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithTargetHeight:(CGFloat)targetHeight
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = width;
    CGFloat scaledHeight = height;
    if (height != targetHeight) {
        scaleFactor = targetHeight/height;        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
    }
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    CGContextRef bitmap;
    bitmap = CGBitmapContextCreate(NULL, scaledWidth, scaledHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    CGContextDrawImage(bitmap, CGRectMake(0,0,scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    return newImage;
}

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithTargetWidth:(CGFloat)targetWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = width;
    CGFloat scaledHeight = height;
    if (width != targetWidth) {
        scaleFactor = targetWidth/width;        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
    }
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    CGContextRef bitmap;
    bitmap = CGBitmapContextCreate(NULL, scaledWidth, scaledHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    CGContextDrawImage(bitmap, CGRectMake(0,0,scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    return newImage;
}

+ (CGFloat)heightWithSpecificWidth:(CGFloat)targetWidth ofAnImage:(UIImage *)sourceImage
{
    CGFloat width = sourceImage.size.width;
    CGFloat height = sourceImage.size.height;
    CGFloat scaleFactor = targetWidth/width;
    return height*scaleFactor;
}

@end
