//
//  PSFilteredImagePicker.m
//  PSFilteredCamera
//
//  Created by 和光 缪 on 12-5-21.
//  Copyright (c) 2012年 东方财富网. All rights reserved.
//

#import "PSFilteredImagePicker.h"

@interface PSFilteredImagePicker ()

@end

@implementation PSFilteredImagePicker

@synthesize delegate,core;

- (void)dealloc
{
    [core release];
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
    core = [[PSCaptureCore alloc]initWithNibName:@"PSCaptureCore" bundle:nil];
    core.delegate = self;
    [self pushViewController:core animated:NO];
    [self setNavigationBarHidden:YES animated:UIStatusBarAnimationFade];
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

#pragma mark - capture delegate
-(void)imageDidCapture:(UIImage *)image
{
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:image,UIImagePickerControllerOriginalImage, nil];
    [self.delegate imagePickerController:self didFinishPickingMediaWithInfo:dict];
    [dict release];
}

-(void)captureCanceled
{
    [self.delegate imagePickerControllerDidCancel:self];
}

@end
