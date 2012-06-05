//
//  UIImageView+Resize.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-15.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Resize)

/**
 等比例缩放到固定大小，多余部分裁去
 */
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
/**
 等比例缩放到固定宽度，高度自适应
 */
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithTargetWidth:(CGFloat)targetWidth;
/**
 等比例缩放到固定高度，宽度自适应
 */
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithTargetHeight:(CGFloat)targetHeight;
/**
 计算将图片缩放到固定宽度时，高度应是多少
 */
+ (CGFloat)heightWithSpecificWidth:(CGFloat)targetWidth ofAnImage:(UIImage *)sourceImage;
@end
