//
//  UserDetailViewControllerViewController.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-17.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "UserDetailViewController.h"
#import "PicShareEngine.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "BoardsListViewController.h"
#import "UsersListViewController.h"
#import "Common.h"
#import "MBProgressHUD.h"
#import "UserInfoEditorViewController.h"
#import "Common.h"


@interface UserDetailViewController ()

- (void)updateView;
- (void)loadData;
- (void)loadDataDidFinish:(User *)returnedUser;
- (IBAction)userBoardsButtonOnClick:(id)sender;
- (IBAction)userFollowersButtonOnClick:(id)sender;
- (IBAction)userFollowingButtonOnClick:(id)sender;
- (IBAction)followButtonOnClick:(id)sender;
- (IBAction)updateUserInfoButtonOnTouch:(id)sender;
- (IBAction)logoutButtonOnClick:(id)sender;
@end

@implementation UserDetailViewController
@synthesize scrollView,nameLabel,locationLabel,introductionText,followerCountLabel,followingCountLabel,picCountLabel,avatarImageView,user,followersButton,followingButton,picturesButton,followButton,editProfileButton,userId,logoutButton;


- (void)dealloc
{
    [scrollView release];
    [nameLabel release];
    [locationLabel release];
    [introductionText release];
    [followerCountLabel release];
    [followingCountLabel release];
    [picCountLabel release];
    [avatarImageView release];
    [followButton release];
    [editProfileButton release];
    //[userId release];
    [logoutButton release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scrollView = nil;
    self.nameLabel = nil;
    self.locationLabel = nil;
    self.introductionText = nil;
    self.followerCountLabel = nil;
    self.followingCountLabel = nil;
    self.picCountLabel = nil;
    self.avatarImageView = nil;
    self.followersButton = nil;
    self.followingButton = nil;
    self.picturesButton = nil;
    self.followButton = nil;
    self.editProfileButton = nil;
    self.logoutButton = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initwithuserId:(NSInteger)anId
{
    self = [super init];
    if (self) {
        userId = [[NSNumber numberWithInt:anId]retain];
    }
    return self;
}

- (id)initWithUser:(User *)aUser
{
    self = [super init];
    if (self) {
        user = [aUser retain];
        userId = [[NSNumber numberWithInt:aUser.userId]retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(userId == nil){
        PicShareEngine *engine = [PicShareEngine sharedEngine];
        userId = [[NSNumber numberWithInt:engine.userId]retain];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelectorInBackground:@selector(loadData) withObject:nil];
}

- (void)updateView
{
    self.scrollView.contentSize = CGSizeMake(320, 360);
    self.introductionText.backgroundColor = RGBA(220, 220, 220, 1);
    self.introductionText.text = [[[NSString alloc]initWithFormat:@"个人简介：\n%@",user.introduction]autorelease];
    self.followerCountLabel.text = [NSString stringWithFormat:@"%d",user.followersCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%d",user.followingCount];
    self.picCountLabel.text = [NSString stringWithFormat:@"%d",user.picturesCount];
    self.nameLabel.text = user.username;
    self.locationLabel.text = user.location;
    NSString *avatarUrl;
    if (IS_RETINA) {
        avatarUrl = [user.avatarUrl stringByAppendingString:@"?size=240"];
    }else {
        avatarUrl = [user.avatarUrl stringByAppendingString:@"?size=120"];
    }
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"anonymous.png"]];
    PicShareEngine *engine = [PicShareEngine sharedEngine];
    if ([engine.username isEqualToString:user.username]) {
        //the current user's profile
        followButton.hidden = YES;
        editProfileButton.hidden = NO;
        self.logoutButton.hidden = NO;
    }else {
        followButton.hidden = NO;
        editProfileButton.hidden = YES;
        self.logoutButton.hidden = YES;
        if (!user.isFollowing) {
            UIImage *followButtonImage = [[UIImage imageNamed:@"followButton"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:13.0];
            UIImage *followButtonImagePressed = [[UIImage imageNamed:@"followButton-press"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:13.0];
            [followButton setBackgroundImage:followButtonImage forState:UIControlStateNormal];
            [followButton setBackgroundImage:followButtonImagePressed forState:UIControlStateHighlighted];
            [followButton setTitle:@"关注" forState:UIControlStateNormal];
            [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else {
            UIImage *unfoButtonImage = [[UIImage imageNamed:@"unfoButton"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:13.0];
            UIImage *unfoButtonImagePressed = [[UIImage imageNamed:@"unfoButton-press"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:13.0];
            [followButton setBackgroundImage:unfoButtonImage forState:UIControlStateNormal];
            [followButton setBackgroundImage:unfoButtonImagePressed forState:UIControlStateHighlighted];
            [followButton setTitle:@"取消关注" forState:UIControlStateNormal];
            [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma IBActions
- (IBAction)userBoardsButtonOnClick:(id)sender
{
    BoardsListViewController *boardsListViewController = [[BoardsListViewController alloc]initWithType:userBoards AndId:user.userId];
    [self.navigationController pushViewController:boardsListViewController animated:YES];
    [boardsListViewController release];
}

- (IBAction)userFollowersButtonOnClick:(id)sender
{
    UsersListViewController *followersListViewController = [[UsersListViewController alloc]initWithUserId:user.userId usersListType:followersList tableViewStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:followersListViewController animated:YES];
    [followersListViewController release];
}

- (IBAction)userFollowingButtonOnClick:(id)sender
{
    UsersListViewController *followingListViewController = [[UsersListViewController alloc]initWithUserId:user.userId usersListType:followingList tableViewStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:followingListViewController animated:YES];
    [followingListViewController release];
}

- (IBAction)followButtonOnClick:(id)sender
{
    NSInteger _userId = self.user.userId;
    PicShareEngine *engine = [PicShareEngine sharedEngine];
    if (user.isFollowing){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            ErrorMessage *errorMsg = [engine unFollowUser:_userId];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (errorMsg.ret==0&&errorMsg.errorcode==0) {
                    self.userId = [NSNumber numberWithInt:self.user.userId];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self performSelectorInBackground:@selector(loadData) withObject:nil];
                }else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorMsg.errorMsg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
                
            });
        });
    }else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            ErrorMessage *errorMsg = [engine followUser:_userId];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (errorMsg.ret==0&&errorMsg.errorcode==0) {
                    self.userId = [NSNumber numberWithInt:self.user.userId];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self performSelectorInBackground:@selector(loadData) withObject:nil];
                }else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorMsg.errorMsg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
                
            });
        });
    }
}

- (IBAction)logoutButtonOnClick:(id)sender
{
    [[UIApplication sharedApplication].delegate performSelector:@selector(logout)];
}

#warning 修改profile、follow/unfo未做。

#pragma mark - async methods
- (void)loadData
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    PicShareEngine *engine = [PicShareEngine sharedEngine];
    User *returnedUser = [engine getUser:[userId intValue]];
    [self performSelectorOnMainThread:@selector(loadDataDidFinish:) withObject:returnedUser waitUntilDone:NO];
    [pool drain];
}
- (void)loadDataDidFinish:(User *)returnedUser
{
    self.user = returnedUser;
    [userId release];
    [self updateView];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (IBAction)updateUserInfoButtonOnTouch:(id)sender
{
    UserInfoEditorViewController *uievc = [[UserInfoEditorViewController alloc]initWithNibName:@"UserInfoEditorViewController" bundle:nil];
    uievc.user = self.user;
    [self.navigationController pushViewController:uievc animated:YES];
    [uievc release];
}
@end
