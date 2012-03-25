//
//  PictureDescriptionComposerViewController.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-25.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "PictureDescriptionComposerViewController.h"

@interface PictureDescriptionComposerViewController ()

- (void)doneButtonOnTouch;
- (void)cancelButtonOnTouch;

@end

@implementation PictureDescriptionComposerViewController
@synthesize descriptionTextView,delegate,descriptionTextFromParent;

- (void)dealloc
{
    [descriptionTextFromParent release];
    [descriptionTextView release];
    [delegate release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonOnTouch)]autorelease];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonOnTouch)]autorelease];
    }
    return self;
}

-(id)initWithText:(NSString *)text
{
    self = [super init];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonOnTouch)]autorelease];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonOnTouch)]autorelease];
        self.descriptionTextFromParent = text;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.descriptionTextView.text = descriptionTextFromParent;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.descriptionTextView = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)cancelButtonOnTouch
{

    [self.navigationController dismissModalViewControllerAnimated:YES];
}
- (void)doneButtonOnTouch
{
    [self.descriptionTextView resignFirstResponder];
    NSString *text = self.descriptionTextView.text;
    [self.delegate descriptionDidCompose:text];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

@end
