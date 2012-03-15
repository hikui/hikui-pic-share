//
//  UIImageView+Resize.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-15.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Resize)

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithTargetWidth:(CGFloat)targetWidth;
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithTargetHeight:(CGFloat)targetHeight;
+ (CGFloat)heightWithSpecificWidth:(CGFloat)targetWidth ofAnImage:(UIImage *)sourceImage;
@end
