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

@interface BoardDetailViewController ()

- (void)loadData;
- (void)page;

@end

@implementation BoardDetailViewController
@synthesize avatarButton,followButton,tableView,boardId,board;

- (void)dealloc
{
    [avatarButton release];
    [followButton release];
    [tableView release];
    [board release];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadData];
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
    int count = self.board.picturesCount;
    int result = count/4; //23/4 = 5
    int temp = result*4; //5*4=20
    if (count-temp>0) {
        result++; //23-20>0 5->6
    }
    return result;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

#define FIRST_IMGVIEW_TAG 1
#define SECOND_IMGVIEW_TAG 2
#define THIRD_IMGVIEW_TAG 3
#define FORTH_IMGVIEW_TAG 4

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
    }else {
        imgView1 = (PSThumbnailImageView *)[cell.contentView viewWithTag:FIRST_IMGVIEW_TAG];
        imgView2 = (PSThumbnailImageView *)[cell.contentView viewWithTag:SECOND_IMGVIEW_TAG];
        imgView3 = (PSThumbnailImageView *)[cell.contentView viewWithTag:THIRD_IMGVIEW_TAG];
        imgView4 = (PSThumbnailImageView *)[cell.contentView viewWithTag:FORTH_IMGVIEW_TAG];
    }
    if (indexPath.row*4<self.board.picturesCount) {
        PictureStatus *ps = [self.board.pictureStatuses objectAtIndex:(indexPath.row*4)];
        NSURL *url = [NSURL URLWithString:ps.pictureUrl];
        [imgView1 setImageWithUrl:url placeholderImage:[UIImage imageNamed:@"PicturePlaceHolder.png"]];
    }
    if (indexPath.row*4+1<self.board.picturesCount) {
        PictureStatus *ps = [self.board.pictureStatuses objectAtIndex:(indexPath.row*4+1)];
        NSURL *url = [NSURL URLWithString:ps.pictureUrl];
        [imgView2 setImageWithUrl:url placeholderImage:[UIImage imageNamed:@"PicturePlaceHolder.png"]];
    }
    if (indexPath.row*4+2<self.board.picturesCount) {
        PictureStatus *ps = [self.board.pictureStatuses objectAtIndex:(indexPath.row*4+2)];
        NSURL *url = [NSURL URLWithString:ps.pictureUrl];
        [imgView3 setImageWithUrl:url placeholderImage:[UIImage imageNamed:@"PicturePlaceHolder.png"]];
    }
    if (indexPath.row*4+3<self.board.picturesCount) {
        PictureStatus *ps = [self.board.pictureStatuses objectAtIndex:(indexPath.row*4+3)];
        NSURL *url = [NSURL URLWithString:ps.pictureUrl];
        [imgView4 setImageWithUrl:url placeholderImage:[UIImage imageNamed:@"PicturePlaceHolder.png"]];
    }
    return cell;
}

- (void)loadData
{
    NSInteger _boardId = self.boardId;
    NSLog(@"boardid:%d",_boardId);
    //try GCD here
    dispatch_queue_t downloadQ = dispatch_queue_create("BoardDetail Download", NULL);
    dispatch_async(downloadQ, ^{
        PicShareEngine *engine = [PicShareEngine sharedEngine];
        Board *b = [engine getBoard:_boardId];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.board = b;
            NSLog(@"board:%@",b);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        });
        
    });
    dispatch_release(downloadQ);
}

@end
