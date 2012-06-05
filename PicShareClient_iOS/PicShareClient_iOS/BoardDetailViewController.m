//
//  BoardDetailViewController.m
//  PicShareClient_iOS
//
//  Created by 缪和光 on 12-3-31.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "BoardDetailViewController.h"
#import "MBProgressHUD.h"
#import "PicShareEngine.h"
#import "PSThumbnailImageView.h"
#import "PicDetailViewController.h"
#import "UserDetailViewController.h"
#import "BoardInfoEditorViewController.h"

@interface BoardDetailViewController ()

- (void)loadData;
/**
 检测被点图是哪个PictureStatus
 */
- (void)picOnTouch:(id)sender;

@end

@implementation BoardDetailViewController
@synthesize avatarButton,followButton,tableView,boardId,board,boardNameLabel,editButton;

- (void)dealloc
{
    [avatarButton release];
    [followButton release];
    [tableView release];
    [board release];
    [editButton release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.avatarButton = nil;
    self.followButton = nil;
    self.tableView = nil;
    self.editButton = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)]autorelease];
    self.boardNameLabel.text = nil;
    self.followButton.hidden = YES;
    self.boardNameLabel.hidden = YES;
    self.editButton.hidden = YES;
    [self.view setUserInteractionEnabled:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = self.board.pictureStatuses.count;
    int result = (count%4==0)?count/4:(count/4+1);
    return result;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

#define FIRST_IMGVIEW_TAG 100
#define SECOND_IMGVIEW_TAG 101
#define THIRD_IMGVIEW_TAG 102
#define FORTH_IMGVIEW_TAG 103

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PSThumbnailImageView *imgView1,*imgView2,*imgView3,*imgView4;
    if (cell==nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
        imgView1 = [[[PSThumbnailImageView alloc]initWithFrame:CGRectMake(5, 0, 76, 76)]autorelease];
        imgView2 = [[[PSThumbnailImageView alloc]initWithFrame:CGRectMake(83, 0, 76, 76)]autorelease];
        imgView3 = [[[PSThumbnailImageView alloc]initWithFrame:CGRectMake(161, 0, 76, 76)]autorelease];
        imgView4 = [[[PSThumbnailImageView alloc]initWithFrame:CGRectMake(239, 0, 76, 76)]autorelease];
        imgView1.tag = FIRST_IMGVIEW_TAG;
        imgView2.tag = SECOND_IMGVIEW_TAG;
        imgView3.tag = THIRD_IMGVIEW_TAG;
        imgView4.tag = FORTH_IMGVIEW_TAG;
        [cell.contentView addSubview:imgView1];
        [cell.contentView addSubview:imgView2];
        [cell.contentView addSubview:imgView3];
        [cell.contentView addSubview:imgView4];
        [imgView1 addTarget:self action:@selector(picOnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [imgView2 addTarget:self action:@selector(picOnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [imgView3 addTarget:self action:@selector(picOnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [imgView4 addTarget:self action:@selector(picOnTouch:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    }else {
        
        imgView1 = (PSThumbnailImageView *)[cell.contentView viewWithTag:FIRST_IMGVIEW_TAG];
        imgView2 = (PSThumbnailImageView *)[cell.contentView viewWithTag:SECOND_IMGVIEW_TAG];
        imgView3 = (PSThumbnailImageView *)[cell.contentView viewWithTag:THIRD_IMGVIEW_TAG];
        imgView4 = (PSThumbnailImageView *)[cell.contentView viewWithTag:FORTH_IMGVIEW_TAG];
    }
    if (indexPath.row*4<self.board.pictureStatuses.count) {
        PictureStatus *ps = [self.board.pictureStatuses objectAtIndex:(indexPath.row*4)];
        NSURL *url = [NSURL URLWithString:[ps.pictureUrl stringByAppendingString:@"?size=120"]];
        [imgView1 setImageWithUrl:url placeholderImage:[UIImage imageNamed:@"PicturePlaceHolder.png"]];
    }
    if (indexPath.row*4+1<self.board.pictureStatuses.count) {
        PictureStatus *ps = [self.board.pictureStatuses objectAtIndex:(indexPath.row*4+1)];
        NSURL *url = [NSURL URLWithString:[ps.pictureUrl stringByAppendingString:@"?size=120"]];
        [imgView2 setImageWithUrl:url placeholderImage:[UIImage imageNamed:@"PicturePlaceHolder.png"]];
    }
    if (indexPath.row*4+2<self.board.pictureStatuses.count) {
        PictureStatus *ps = [self.board.pictureStatuses objectAtIndex:(indexPath.row*4+2)];
        NSURL *url = [NSURL URLWithString:[ps.pictureUrl stringByAppendingString:@"?size=120"]];
        [imgView3 setImageWithUrl:url placeholderImage:[UIImage imageNamed:@"PicturePlaceHolder.png"]];
    }
    if (indexPath.row*4+3<self.board.pictureStatuses.count) {
        PictureStatus *ps = [self.board.pictureStatuses objectAtIndex:(indexPath.row*4+3)];
        NSURL *url = [NSURL URLWithString:[ps.pictureUrl stringByAppendingString:@"?size=120"]];
        [imgView4 setImageWithUrl:url placeholderImage:[UIImage imageNamed:@"PicturePlaceHolder.png"]];
    }
    cell.tag = indexPath.row;
    
    return cell;
}

- (void)loadData
{
    NSInteger _boardId = self.boardId;
    //try GCD here
    dispatch_queue_t downloadQ = dispatch_queue_create("BoardDetail Download", NULL);
    dispatch_async(downloadQ, ^{
        PicShareEngine *engine = [PicShareEngine sharedEngine];
        Board *b = [engine getBoard:_boardId];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.board = b;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!board.isFollowing) {
                //button = 取消关注
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
            if (board.owner.userId != engine.userId) {
                self.followButton.hidden = NO;
            }else {
                self.editButton.hidden = NO;
            }
            self.boardNameLabel.text = self.board.name;
            self.boardNameLabel.hidden = NO;
            [self.view setUserInteractionEnabled:YES];
            [self.tableView reloadData];
        });
        
    });
    dispatch_release(downloadQ);
}

- (void)picOnTouch:(id)sender
{
    PSThumbnailImageView *iv = (PSThumbnailImageView *)sender;
    UITableViewCell *cell = (UITableViewCell *)iv.superview.superview;
    int row = cell.tag;
    int col = iv.tag-100;
    int index = row*4+col;
    if (index<self.board.pictureStatuses.count) {
        PictureStatus *ps = [board.pictureStatuses objectAtIndex:index];
        PicDetailViewController *pdvc = [[PicDetailViewController alloc]init];
        pdvc.pictureStatus = ps;
        [self.navigationController pushViewController:pdvc animated:YES];
        [pdvc release];
    }
}
- (IBAction)avatarButtonOnTouch:(id)sender
{
    UserDetailViewController *udvc = [[UserDetailViewController alloc]initWithUser:self.board.owner];
    [self.navigationController pushViewController:udvc animated:YES];
    [udvc release];
}
- (IBAction)followButtonOnTouch:(id)sender
{
    
    NSInteger _boardId = self.boardId;
    if (self.board.isFollowing) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            PicShareEngine *engine = [PicShareEngine sharedEngine];
            ErrorMessage *errorMsg = [engine unFollowBoard:_boardId];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (errorMsg.ret==0 && errorMsg.errorcode==0) {
                    UIImage *followButtonImage = [[UIImage imageNamed:@"followButton"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:13.0];
                    UIImage *followButtonImagePressed = [[UIImage imageNamed:@"followButton-press"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:13.0];
                    [followButton setBackgroundImage:followButtonImage forState:UIControlStateNormal];
                    [followButton setBackgroundImage:followButtonImagePressed forState:UIControlStateHighlighted];
                    [followButton setTitle:@"关注" forState:UIControlStateNormal];
                    [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    self.board.isFollowing = NO;
                }else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorMsg.errorMsg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
            });
        });
    }else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            PicShareEngine *engine = [PicShareEngine sharedEngine];
            ErrorMessage *errorMsg = [engine followBoard:_boardId];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (errorMsg.ret==0 && errorMsg.errorcode==0) {
                    UIImage *unfoButtonImage = [[UIImage imageNamed:@"unfoButton"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:13.0];
                    UIImage *unfoButtonImagePressed = [[UIImage imageNamed:@"unfoButton-press"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:13.0];
                    [followButton setBackgroundImage:unfoButtonImage forState:UIControlStateNormal];
                    [followButton setBackgroundImage:unfoButtonImagePressed forState:UIControlStateHighlighted];
                    [followButton setTitle:@"取消关注" forState:UIControlStateNormal];
                    [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    self.board.isFollowing = YES;
                }else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorMsg.errorMsg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
            });
        });
    }
}

- (IBAction)editButtonOnTouch:(id)sender
{
    BoardInfoEditorViewController *bievc = [[BoardInfoEditorViewController alloc]initWithNibName:@"BoardInfoEditorViewController" bundle:nil];
    bievc.board = self.board;
    bievc.type = UPDATE;
    [self.navigationController pushViewController:bievc animated:YES];
    [bievc release];
}
@end
