//
//  UsersListViewController.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-18.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "UsersListViewController.h"
#import "PicShareEngine.h"
#import "UIImageView+AsyncImageContainer.h"

@interface UsersListViewController ()

- (void)loadData;
- (void)loadDataDidFinish:(NSArray *)returnedArray;

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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    User *u = [usersArray objectAtIndex:indexPath.row];
    cell.textLabel.text = u.username;
    cell.detailTextLabel.text = [[NSString alloc]initWithFormat:@"来自 %@",u.location];
    [cell.imageView setImageWithUrl:[NSURL URLWithString:u.avatarUrl] placeholderImage:[UIImage imageNamed:@"anonymous.png"]];
    
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
    cell.accessoryView = followButton;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
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
    [pool release];
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
    NSLog(@"%@",self.usersArray);
    [tempView release];
    [self.tableView reloadData];
}

#warning 翻页未做

@end
