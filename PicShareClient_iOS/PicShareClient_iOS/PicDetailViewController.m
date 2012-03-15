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
    // e.g. self.myOutlet = nil;
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
    PictureStatus * returnedStatus = [engine getPictureStatus:1];
    [self performSelectorOnMainThread:@selector(loadDataDidFinish:) withObject:returnedStatus waitUntilDone:YES];
    [pool release];
}

- (void)loadDataDidFinish:(PictureStatus *)returnedStatus
{
    self.pictureStatus = returnedStatus;
    [loadingIndicator stopAnimating];
    PicDetailView *detailView = [[PicDetailView alloc]initWithPictureStatus:self.pictureStatus];
    self.view = detailView;
    [detailView release];
    
}

@end
