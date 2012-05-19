//
//  PictureDescriptionComposerViewController.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-25.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "SingleTextInputViewController.h"

@interface SingleTextInputViewController ()

- (void)doneButtonOnTouch;
- (void)cancelButtonOnTouch;

@end

@implementation SingleTextInputViewController
@synthesize descriptionTextView,delegate,descriptionTextFromParent,presentType,tag;

- (void)dealloc
{
    [descriptionTextFromParent release];
    [descriptionTextView release];
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
    [self.descriptionTextView becomeFirstResponder];
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

    if (presentType == MODAL) {
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }else if(presentType == NAVIGATION){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)doneButtonOnTouch
{
    [self.descriptionTextView resignFirstResponder];
    NSString *text = self.descriptionTextView.text;
    [self.delegate SingleTextInputViewController:self textDidCompose:text];
    if (presentType == MODAL) {
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }else if(presentType == NAVIGATION){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

@end
