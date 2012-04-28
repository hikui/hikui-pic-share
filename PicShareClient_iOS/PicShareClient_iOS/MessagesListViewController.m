//
//  MessagesListViewController.m
//  PicShareClient_iOS
//
//  Created by zoom on 12-4-23.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "MessagesListViewController.h"
#import "PicShareEngine.h"
#import "PSMessage.h"
#import "UIImageView+WebCache.h"
#import "Common.h"
#import "MBProgressHUD.h"
#import "PicDetailViewController.h"
#import "UserDetailViewController.h"
#import "CommentsListViewController.h"

@interface MessagesListViewController()

-(void)pageData;

@end

@implementation MessagesListViewController
@synthesize commentCell,messages,hasNext,currentPage;

- (void)dealloc {
    [messages release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startLoading];

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.messages = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.messages) {
        return 0;
    }
    return self.messages.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == self.messages.count) {
        UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease];
        cell.textLabel.text = @"更多";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        if (!hasNext) {
            [cell.textLabel setHidden:YES];
        }
        return cell;
    }
    
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
        cell = self.commentCell;
        self.commentCell = nil;
    }
    PSMessage *message = [self.messages objectAtIndex:indexPath.row];
    UIButton *nameButton = (UIButton *)[cell viewWithTag:1];
    UILabel *commentText = (UILabel *)[cell viewWithTag:2];
    UIImageView *avatar = (UIImageView *)[cell viewWithTag:3];
    NSString *avatarStr;
    if (IS_RETINA) {
        avatarStr = [message.by.avatarUrl stringByAppendingString:@"?size=120"];
    }else {
        avatarStr = [message.by.avatarUrl stringByAppendingString:@"?size=60"];
    }
    [avatar setImageWithURL:[NSURL URLWithString:avatarStr] placeholderImage:[UIImage imageNamed:@"anonymous.png"]];
    [nameButton setTitle:message.by.username forState:UIControlStateNormal];
    CGSize textSize = [message.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(236, 9999) lineBreakMode:UILineBreakModeWordWrap];
    CGRect textFrame = commentText.frame;
    textFrame.size = textSize;
    commentText.frame = textFrame;
    commentText.text = message.text;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.messages.count) {
        return 40;
    }
    PSMessage *message = [self.messages objectAtIndex:indexPath.row];
    CGSize textSize = [message.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(236, 9999) lineBreakMode:UILineBreakModeWordWrap];
    
    return MAX(72.0f, textSize.height+40);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.messages.count && self.hasNext) {
        [self pageData];
        return;
    }
    PSMessage *theMessage = [self.messages objectAtIndex:indexPath.row];
    if (theMessage.type == FollowingMessage) {
        // do nothing, just tap the name button
    }else if(theMessage.type == CommentMessage){
        NSInteger psId = [theMessage.extra integerValue];
        PicDetailViewController *pdvc = [[PicDetailViewController alloc]initWithPicId:psId];
        [self.navigationController pushViewController:pdvc animated:YES];
        [pdvc release];
    }else if(theMessage.type == MentionMessage){
        NSInteger psId = [theMessage.extra integerValue];
        CommentsListViewController *clvc = [[CommentsListViewController alloc]initWithPsId:psId];
        [self.navigationController pushViewController:clvc animated:YES];
        [clvc release];
    }
}


#pragma mark - pull refresh methods
- (void)refresh
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        PicShareEngine *engine = [PicShareEngine sharedEngine];
        NSArray *resultArray = [engine getMessagesToMe];
        NSArray *resultMessages = [resultArray subarrayWithRange:NSMakeRange(1, resultArray.count-1)];
        BOOL _hasNext = [[resultArray objectAtIndex:0]boolValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.messages = [[[NSMutableArray alloc]initWithArray:resultMessages]autorelease];
            [self.tableView reloadData];
            self.hasNext = _hasNext;
            self.currentPage = 1;
            [self stopLoading];
        });
    });
}

-(void)pageData
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        PicShareEngine *engine = [PicShareEngine sharedEngine];
        int flagId = ((PSMessage *)[self.messages objectAtIndex:0]).psmsgId;
        NSArray *resultArray = [engine getMessagesToMeWithPage:currentPage+1 countPerPage:5 since:-1 max:flagId];
        NSArray *resultMessages = [resultArray subarrayWithRange:NSMakeRange(1, resultArray.count-1)];//第0个为hasnext
        BOOL _hasNext = [[resultArray objectAtIndex:0]boolValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
            NSInteger originMessagesCount = self.messages.count;
            for (PSMessage *m in resultMessages) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:originMessagesCount inSection:0];
                [indexPaths addObject:path];
                [self.messages insertObject:m atIndex:originMessagesCount];
                originMessagesCount++;
            }
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
            self.hasNext = _hasNext;
            self.currentPage = self.currentPage+1;
            [indexPaths release];
            [MBProgressHUD hideHUDForView:window animated:YES];
        });
    });
}

@end
