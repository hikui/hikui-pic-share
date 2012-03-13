//
//  PSThumbnailImageView.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-12.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PSThumbnailImageViewEventsDelegate <NSObject>

- (void)didReceiveTouchEventOfSender:(id)sender;

@end

/**
 PSThumbnailImageView is not UIImageView!!!
 This kind of ImageView has round corner with shardow. Will send touch event to delegate.
 */
@interface PSThumbnailImageView : UIView

@property (nonatomic,retain) id<PSThumbnailImageViewEventsDelegate> delegate;
@property (nonatomic,retain) UIImageView *innerImageView;

- (void)clearImage;
- (void)setImageWithUrl:(NSURL *)url;
- (void)setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
