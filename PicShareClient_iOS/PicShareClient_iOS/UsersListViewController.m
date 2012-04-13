//
//  UsersListViewController.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-18.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "UsersListViewController.h"
#import "PicShareEngine.h"
#import "UIImageView+WebCache.h"

@interface UsersListViewController ()

- (void)loadData;
- (void)loadDataDidFinish:(NSArray *)returnedArray;
- (void)followButtonOnTouch:(id)sender;

@end

@implementation UsersListViewController
@synthesize userId,usersListType,usersArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUserId:(NSInteger)aUserId usersListType:(UsersListType)aType tableViewStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        userId = aUserId;
        usersListType = aType;
        hasnext = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tempView = [self.view retain];
    loadingView = [[UIView alloc]init];
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat x = screenBounds.size.width/2 - 10;
    CGFloat y = screenBounds.size.height/2 - 10-50;
    loadingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingIndicator.frame = CGRectMake(x, y, 20, 20);
    loadingIndicator.hidesWhenStopped = YES;
    [loadingView addSubview:loadingIndicator];
    self.view = loadingView;
    [self performSelectorInBackground:@selector(loadData) withObject:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.usersArray = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [tempView release];
    tempView = nil;
    [loadingView release];
    loadingView = nil;
    self.usersArray = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.usersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
    }
    User *u = [usersArray objectAtIndex:indexPath.row];
    cell.textLabel.text = u.username;
    cell.detailTextLabel.text = [[[NSString alloc]initWithFormat:@"来自 %@",u.location]autorelease];
    [cell.imageView setImageWithURL:[NSURL URLWithString:u.avatarUrl] placeholderImage:[UIImage imageNamed:@"anonymous.png"]];
    
    UIButton *followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    followButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    followButton.titleLabel.shadowColor = [UIColor blackColor];
    followButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    
    if (!u.isFollowing) {
        UIImage *followButtonImage = [[UIImage imageNamed:@"followButton"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:13.0];
        UIImage *followButtonImagePressed = [[UIImage imageNamed:@"followButton-press"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:13.0];
        [followButton setBackgroundImage:followButtonImage forState:UIControlStateNormal];
        [followButton setBackgroundImage:followButtonImagePressed forState:UIControlStateHighlighted];
        followButton.frame = CGRectMake(0, 0, 70, 30);
        [followButton setTitle:@"关注" forState:UIControlStateNormal];
        [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        UIImage *unfoButtonImage = [[UIImage imageNamed:@"unfoButton"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:13.0];
        UIImage *unfoButtonImagePressed = [[UIImage imageNamed:@"unfoButton-press"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:13.0];
        [followButton setBackgroundImage:unfoButtonImage forState:UIControlStateNormal];
        [followButton setBackgroundImage:unfoButtonImagePressed forState:UIControlStateHighlighted];
        followButton.frame = CGRectMake(0, 0, 70, 30);
        [followButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [followButton addTarget:self action:@selector(followButtonOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    PicShareEngine *engine = [PicShareEngine sharedEngine];
    int currUserId = engine.userId;
    if (!(u.userId==currUserId)) {
        cell.accessoryView = followButton;
    }
    cell.tag = indexPath.row;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - async loading methods

- (void)loadData
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    PicShareEngine *engine = [PicShareEngine sharedEngine];
    NSArray *returnedArray = nil;
    if (usersListType == followersList) {
        returnedArray = [engine getFollowers:userId];
    }else if (usersListType == followingList) {
        returnedArray = [engine getFollowing:userId];
    }
    [self performSelectorOnMainThread:@selector(loadDataDidFinish:) withObject:returnedArray waitUntilDone:NO];
    [pool drain];
}

- (void)loadDataDidFinish:(NSArray *)returnedArray
{
    if ([[returnedArray objectAtIndex:0]intValue] == 1) {
        hasnext = YES;
    }
    else {
        hasnext = NO;
    }
    self.usersArray = [[[NSMutableArray alloc]initWithArray:[returnedArray subarrayWithRange:NSMakeRange(1, returnedArray.count-1)]]autorelease];
    self.view = tempView;
    [tempView release];
    [self.tableView reloadData];
}
#warning not implement pagination

- (void)followButtonOnTouch:(id)sender
{
    NSLog(@"touch");
    UIButton *followButton = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)followButton.superview;
    int index = cell.tag;
    User *u = [self.usersArray objectAtIndex:index];
    if (u.isFollowing) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            PicShareEngine *engine = [PicShareEngine sharedEngine];
            ErrorMessage *eMsg = [engine unFollowUser:u.userId];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (eMsg.ret==0 && eMsg.errorcode==0) {
                    UIImage *followButtonImage = [[UIImage imageNamed:@"followButton"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:13.0];
                    UIImage *followButtonImagePressed = [[UIImage imageNamed:@"followButton-press"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:13.0];
                    [followButton setBackgroundImage:followButtonImage forState:UIControlStateNormal];
                    [followButton setBackgroundImage:followButtonImagePressed forState:UIControlStateHighlighted];
                    [followButton setTitle:@"关注" forState:UIControlStateNormal];
                    [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    cell.accessoryView = followButton;
                    u.isFollowing = NO;
                }else {
                    NSString *eMsgStr = eMsg.errorMsg;
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误" message:eMsgStr delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [alertView show];
                    [alertView release];
                }
            });
        });
    }else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            PicShareEngine *engine = [PicShareEngine sharedEngine];
            ErrorMessage *eMsg = [engine followUser:u.userId];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (eMsg.ret==0 && eMsg.errorcode==0) {
                    UIImage *unfoButtonImage = [[UIImage imageNamed:@"unfoButton"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:13.0];
                    UIImage *unfoButtonImagePressed = [[UIImage imageNamed:@"unfoButton-press"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:13.0];
                    [followButton setBackgroundImage:unfoButtonImage forState:UIControlStateNormal];
                    [followButton setBackgroundImage:unfoButtonImagePressed forState:UIControlStateHighlighted];
                    [followButton setTitle:@"取消关注" forState:UIControlStateNormal];
                    [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    cell.accessoryView = followButton;
                    u.isFollowing = YES;
                    
                }else {
                    NSString *eMsgStr = eMsg.errorMsg;
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误" message:eMsgStr delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [alertView show];
                    [alertView release];
                }
            });
        });
    }
    
    
}

@end
