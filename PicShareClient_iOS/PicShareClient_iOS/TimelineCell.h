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

@interface TimelineCell : UITableViewCell
{
    BOOL loadImgComplete;
}

@property (nonatomic,assign) PictureStatus *pictureStatus;
@property (nonatomic,retain) UIImageView *avatarImageView;
@property (nonatomic,retain) UIButton *usernameButton;
@property (nonatomic,retain) UIButton *boardNameButton;
@property (nonatomic,retain) UIButton *viaButton;
@property (nonatomic,retain) UILabel *picDescriptionLabel;
@property (nonatomic,retain) UIImageView *mainImageView;
@property (nonatomic,retain) UIButton *repinButton;
@property (nonatomic,retain) UITextField *commentTextField;
@property (nonatomic,retain) UIProgressView *progressView;
@property (nonatomic,retain) ASIHTTPRequest *request;

- (void)refreshWithPictureStatus:(PictureStatus *)aPictureStatus;

//需要手动call这个方法，在cellForRowAtIndexPath的最后。
- (void)layout;
- (void)setPictureStatusThenRefresh:(PictureStatus *)aPictureStatus;
+ (CGFloat)calculateCellHeightWithPictureStatus:(PictureStatus *)aPictureStatus;

@end
