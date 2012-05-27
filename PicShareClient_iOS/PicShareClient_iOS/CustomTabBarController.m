    //
//  BaseViewController.m
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//
// Copyright (c) 2011 Peter Boctor
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//

#import "CustomTabBarController.h"
#import "UIImageView+Resize.h"
#import "PictureInfoEditViewController.h"


@interface CustomTabBarController ()

- (void)cameraButtonOnTouch:(id)sender;

@end

@implementation CustomTabBarController

@synthesize cameraButton = _cameraButton;

// Create a view controller and setup it's tab bar item with a title and image
-(UIViewController*) viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image
{
  UIViewController* viewController = [[[UIViewController alloc] init] autorelease];
  viewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:title image:image tag:0] autorelease];
  return viewController;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *buttonImg = [UIImage imageNamed:@"capture-button.png"];
    [self addCenterButtonWithImage:buttonImg highlightImage:nil];
    
}


// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(cameraButtonOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];

    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
    button.center = self.tabBar.center;
    else
    {
    CGPoint center = self.tabBar.center;
    center.y = center.y - heightDifference/2.0;
    button.center = center;
    }

    self.cameraButton = button;

    [self.view addSubview:self.cameraButton];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }
    return NO;
}

- (void)cameraButtonOnTouch:(id)sender
{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        //picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        PSFilteredImagePicker *picker = [[PSFilteredImagePicker alloc]init];
        picker.delegate = self;
        [self presentModalViewController:picker animated:YES];
        [picker release];
        
    }else {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
    
    
}

- (void)imagePickerController:(id)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *editedImage = nil;
    editedImage = [UIImageView imageWithImage:originalImage scaledToSizeWithTargetWidth:640];
    PictureInfoEditViewController *pievc = [[PictureInfoEditViewController alloc]initWithNibName:@"PictureInfoEditViewController" bundle:nil];
    pievc.type = CREATE;
    pievc.uploadImage = editedImage;
    [picker pushViewController:pievc animated:YES];
    [pievc release];
    
}

- (void)imagePickerControllerDidCancel:(id) picker
{
    if ([UIApplication sharedApplication].statusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    [(UIViewController *)picker dismissModalViewControllerAnimated:YES];
}

-(void)dealloc
{
    [_cameraButton release];
    [super dealloc];
}

@end
