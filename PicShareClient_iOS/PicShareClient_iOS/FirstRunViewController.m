//
//  FirstRunViewController.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-5-9.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "FirstRunViewController.h"
#import "User.h"
#import "PicShareEngine.h"
#import "PSKeySets.h"
#import "MBProgressHUD.h"

#define loginUsernameTag 200
#define loginPasswordTag 201
#define regUsernameTag 300
#define regPasswordTag 301
#define regPasswordConfirmTag 302
#define regEmailTag 303

@interface FirstRunViewController ()

@end

@implementation FirstRunViewController
@synthesize loginPassword,loginUsername,regEmail,regPassword,regUsername,regPasswordConfirm,regView;

- (void)dealloc
{
    [loginPassword release];
    [loginUsername release];
    [regEmail release];
    [regPassword release];
    [regUsername release];
    [regPasswordConfirm release];
    [regView release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.regView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)regNewButtonPressed:(id)sender
{
    regUsername.text = @"";
	regPassword.text = @"";
    regPasswordConfirm.text = @"";
	regEmail.text = @"";
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
	[self.view addSubview:regView];
	[UIView commitAnimations];
}
- (IBAction)loginButtonPressed:(id)sender
{
    if (![loginUsername.text length] || ![loginPassword.text length]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"必须填写用户名和密码" delegate:nil cancelButtonTitle:@"奴才知罪" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        PicShareEngine *engine = [PicShareEngine sharedEngine];
        User *u = [[User alloc]init];
        u.username = loginUsername.text;
        u.password = loginPassword.text;
        User *returnedU = [engine login:u];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (returnedU) {
                [[NSUserDefaults standardUserDefaults]setObject:u.username forKey:kUserDefaultsUsername];
                [[NSUserDefaults standardUserDefaults]setObject:u.password forKey:kUserDefaultsPassword];
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:returnedU.userId] forKey:kUserDefaultsUserId];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[UIApplication sharedApplication].delegate performSelector:@selector(prepareToMainViewController)];
            }else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"登录失败，请检查用户名和密码" delegate:nil cancelButtonTitle:@"奴才知罪" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            [u release];
        });
        
    });
}
- (IBAction)regButtonPressed:(id)sender
{
    
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
	[regView removeFromSuperview];
	[UIView commitAnimations];
}

#pragma mark - tf delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    int tag = textField.tag;
    if (tag == loginUsernameTag || (tag>=regUsernameTag && tag<regEmailTag)) {
        //next
        UIResponder *nextResponder = [textField.superview viewWithTag:tag+1];
        [nextResponder becomeFirstResponder];
    }else {
        [textField resignFirstResponder];
    }
    return NO;
}

@end
