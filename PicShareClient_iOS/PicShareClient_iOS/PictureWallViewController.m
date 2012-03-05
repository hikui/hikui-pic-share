//
//  PictureWallViewController.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-1.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "PictureWallViewController.h"

@interface PictureWallViewController (Private)
// for private methods
@end

@implementation PictureWallViewController
@synthesize scrollView = _scrollView;

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
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
    _scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    UILabel *label = [[UILabel alloc]init];
    [label setText:@"hello world"];
    [label setFrame:CGRectMake(10, 330, 300, 100)];
    [label setBackgroundColor:[UIColor redColor]];
    [_scrollView addSubview:label];
    [_scrollView setContentSize:CGSizeMake(1000, 1000)];
    self.view = _scrollView;
    [label release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    [_scrollView release];
    [super dealloc];
}
@end
