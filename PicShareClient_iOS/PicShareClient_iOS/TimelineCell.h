//
//  TimelineCell.h
//  PicShareClient_iOS
//
//  Created by 缪和光 on 12-3-28.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureStatus.h"
#import "ASIHTTPRequest.h"

#define MAIN_IMAGE_WIDTH 300.0f
#define MAIN_IMAGE_HEIGHT 255.0f

@protocol TimelineCellCommentDelegate <NSObject>

- (void)commentUsernameButtonOnTouch:(id)sender;

@end


@interface TimelineCell : UITableViewCell

@property (nonatomic,assign) PictureStatus *pictureStatus;
@property (nonatomic,retain) UIImageView *avatarImageView;
@property (nonatomic,retain) UIButton *usernameButton;
@property (nonatomic,retain) UIButton *boardNameButton;
@property (nonatomic,retain) UIButton *viaButton;
@property (nonatomic,retain) UILabel *picDescriptionLabel;
@property (nonatomic,retain) UIImageView *mainImageView;
@property (nonatomic,retain) UIButton *repinButton;
@property (nonatomic,retain) UITextField *commentTextField;
@property (nonatomic,retain) ASIHTTPRequest *request;
@property (nonatomic,retain) UILabel *viaLabel;
@property (nonatomic,assign) id<TimelineCellCommentDelegate> delegate;

- (void)refreshWithPictureStatus:(PictureStatus *)aPictureStatus;

//需要手动call这个方法，在cellForRowAtIndexPath的最后。
- (void)layout;
- (void)clearImage;
- (void)setPicture:(UIImage *)image WillAnimated:(BOOL)animated;
+ (CGFloat)calculateCellHeightWithPictureStatus:(PictureStatus *)aPictureStatus;

@end
