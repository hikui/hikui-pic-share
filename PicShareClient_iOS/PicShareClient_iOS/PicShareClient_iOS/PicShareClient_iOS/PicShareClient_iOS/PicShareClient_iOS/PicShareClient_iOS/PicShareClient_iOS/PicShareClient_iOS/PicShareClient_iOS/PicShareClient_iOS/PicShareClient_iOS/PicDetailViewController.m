//
//  PicDetailViewController.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-12.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "PicDetailViewController.h"
#import "PicDetailView.h"
#import "PicShareEngine.h"
#import "UserDetailViewController.h"

//TODO: implement methods

@interface PicDetailViewController ()

- (void)loadData;
- (void)loadDataDidFinish:(PictureStatus *)returnedStatus;

@end

@implementation PicDetailViewController
@synthesize picId, pictureStatus;

- (void)dealloc
{
    [loadingIndicator release];
    [loadingView release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithPicId:(NSInteger)aPicId
{
    self = [super init];
    if (self) {
        picId = aPicId;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)loadView
{
    loadingView = [[UIView alloc]init];
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat x = screenBounds.size.width/2 - 10;
    CGFloat y = screenBounds.size.height/2 - 10-50;
    loadingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingIndicator.frame = CGRectMake(x, y, 20, 20);
    loadingIndicator.hidesWhenStopped = YES;
    [loadingView addSubview:loadingIndicator];
    self.view = loadingView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [loadingIndicator startAnimating];
    [self performSelectorInBackground:@selector(loadData) withObject:nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;s
    [loadingView release];
    loadingView = nil;
    [loadingIndicator release];
    loadingIndicator = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - async load data methods

- (void)loadData
{
    //调用方法时直接使用了performSelectorInBackground，所以需要手动开一个autoreleasepool
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    PicShareEngine *engine = [PicShareEngine sharedEngine];
    PictureStatus * returnedStatus = [engine getPictureStatus:picId];
    [self performSelectorOnMainThread:@selector(loadDataDidFinish:) withObject:returnedStatus waitUntilDone:YES];
    [pool release];
}

- (void)loadDataDidFinish:(PictureStatus *)returnedStatus
{
    self.pictureStatus = returnedStatus;
    [loadingIndicator stopAnimating];
    PicDetailView *detailView = [[PicDetailView alloc]initWithPictureStatus:self.pictureStatus];
    self.view = detailView;
    //set target-actions
    [detailView.usernameButton addTarget:self action:@selector(usernameButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [detailView.boardNameButton addTarget:self action:@selector(boardNameButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [detailView.viaButton addTarget:self action:@selector(viaButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [detailView.repinButton addTarget:self action:@selector(repinButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [detailView release];
    
}

#pragma mark - IBActions
- (void)usernameButtonOnClick:(id)sender
{
    NSLog(@"usernameButtonOnClick");
    UserDetailViewController *userDetailViewController = [[UserDetailViewController alloc]initWithUser:pictureStatus.owner];
    [self.navigationController pushViewController:userDetailViewController animated:YES];
    [userDetailViewController release];
}
- (void)boardNameButtonOnClick:(id)sender
{
    NSLog(@"boardNameButtonOnClick"); 
#warning not implement yet
}
- (void)viaButtonOnClick:(id)sender
{
    NSLog(@"viaButtonOnClick");
    UserDetailViewController *userDetailViewController = [[UserDetailViewController alloc]initWithUser:pictureStatus.via];
    [self.navigationController pushViewController:userDetailViewController animated:YES];
    [userDetailViewController release];
}
- (void)repinButtonOnClick:(id)sender
{
    NSLog(@"repinButtonOnClick");
    #warning not implement yet
}

@end
