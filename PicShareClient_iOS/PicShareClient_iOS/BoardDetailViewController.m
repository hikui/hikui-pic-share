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

@interface BoardDetailViewController ()

- (void)loadData;
- (void)page;

@end

@implementation BoardDetailViewController
@synthesize avatarButton,followButton,tableView,pictures,boardId,board;

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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return self.board.picturesCount;
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
        });
        
    });
    dispatch_release(downloadQ);
}

@end
