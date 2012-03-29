//
//  UserDetailViewControllerViewController.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-17.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserDetailViewController : UIViewController
{
    UIView *tempView;
    UIView *loadingView;
    UIActivityIndicatorView *loadingIndicator;
    NSNumber *userId;
}

- (id)initWithUser:(User *)aUser;
- (id)initwithuserId:(NSInteger)anId;

@property (nonatomic,retain) User *user;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UILabel *locationLabel;
@property (nonatomic,retain) IBOutlet UITextView *introductionText;
@property (nonatomic,retain) IBOutlet UILabel *followingCountLabel;
@property (nonatomic,retain) IBOutlet UILabel *followerCountLabel;
@property (nonatomic,retain) IBOutlet UILabel *picCountLabel;
@property (nonatomic,retain) IBOutlet UIImageView *avatarImageView;
@property (nonatomic,retain) IBOutlet UIButton *followingButton;
@property (nonatomic,retain) IBOutlet UIButton *followersButton;
@property (nonatomic,retain) IBOutlet UIButton *picturesButton;
@property (nonatomic,retain) IBOutlet UIButton *followButton;
@property (nonatomic,retain) IBOutlet UIButton *editProfileButton;

@end
