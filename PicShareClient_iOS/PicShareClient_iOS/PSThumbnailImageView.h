//
//  PSThumbnailImageView2.h
//  PicShareClient_iOS
//
//  Created by 缪和光 on 12-3-26.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

// SDWebImage的基础功能的另类实现

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
@protocol PSThumbnailImageViewEventsDelegate <NSObject>

- (void)didReceiveTouchEvent:(id)sender;

@end

@interface PSThumbnailImageView : UIControl <ASIHTTPRequestDelegate>

@property (nonatomic,retain) NSURL *theUrl;
@property (nonatomic,retain) ASIHTTPRequest *theRequest;
@property (nonatomic,retain) UIImageView *imageView;

- (void)clearImage;
- (void)setImageWithUrl:(NSURL *)url;
- (void)setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)icancelImageLoading;
- (void)iResumeImageLoading;
@end
