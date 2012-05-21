//
//  PSViewController.m
//  PSFilteredCamera
//
//  Created by 和光 缪 on 12-5-21.
//  Copyright (c) 2012年 东方财富网. All rights reserved.
//

#import "PSCaptureCore.h"

@interface PSCaptureCore ()

- (void) initFiltersChain;

@end

@implementation PSCaptureCore
@synthesize scrollView,gpuImgView,filter,stillCamera,delegate,previewView,captureButton,confirmButton,cancelButton,abortButton;

- (void)dealloc
{
    [scrollView release];
    [gpuImgView release];
    [filter release];
    [stillCamera release];
    [previewView release];
    [captureButton release];
    [confirmButton release];
    [cancelButton release];
    [abortButton release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    stillCamera = [[GPUImageStillCamera alloc] init];
//    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
//    filter = [[GPUImageSketchFilter alloc] init];
//    [(GPUImageSketchFilter *)filter setTexelHeight:(1.0 / 1024.0)];
//    [(GPUImageSketchFilter *)filter setTexelWidth:(1.0 / 768.0)];
//    [filter prepareForImageCapture];
//    [stillCamera addTarget:filter];
//    [filter addTarget:self.gpuImgView];
//    [stillCamera startCameraCapture];
    [self initFiltersChain];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
}

- (void) initFiltersChain
{
    if (stillCamera==nil) {
        stillCamera = [[GPUImageStillCamera alloc] init];
        stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    }
    self.filter = [[[GPUImageBrightnessFilter alloc]init]autorelease];
    [stillCamera stopCameraCapture];
    [filter addTarget:gpuImgView];
    [filter prepareForImageCapture];
    [stillCamera removeAllTargets];
    [stillCamera addTarget:filter];
    
    [stillCamera startCameraCapture];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scrollView = nil;
    self.gpuImgView = nil;
    self.previewView = nil;
    self.captureButton = nil;
    self.confirmButton = nil;
    self.cancelButton = nil;
    self.abortButton = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.stillCamera stopCameraCapture];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)captureButtonOnTouch:(id)sender
{
    [self.captureButton setEnabled:NO];
    //[self.stillCamera stopCameraCapture];
    [self.stillCamera capturePhotoAsImageProcessedUpToFilter:self.filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        if (!error) {
            runOnMainQueueWithoutDeadlocking(^{
                [self.captureButton setHidden:YES];
                [self.stillCamera stopCameraCapture];
                [self.previewView setHidden:NO];
                self.previewView.image = processedImage;
                [self.confirmButton setHidden:NO];
                [self.cancelButton setHidden:NO];
                [self.abortButton setHidden:YES];
            });
        }else {
            
        }
    }];
    
}
-(IBAction)filterTypeButtonOnTouch:(id)sender
{
    //[stillCamera stopCameraCapture];
    UIButton *button = (UIButton *)sender;
    int tag = button.tag;
    switch (tag) {
        case 200:
            self.filter = [[[GPUImageBrightnessFilter alloc]init]autorelease];
            break;
        case 201:
            self.filter = [[[GPUImageSepiaFilter alloc]init]autorelease];
            break;
        case 202:
            self.filter = [[[GPUImageSketchFilter alloc]init]autorelease];
            [(GPUImageSketchFilter *)filter setTexelHeight:(1.0 / 1024.0)];
            [(GPUImageSketchFilter *)filter setTexelWidth:(1.0 / 768.0)];
            break;
        default:
            self.filter = [[[GPUImageBrightnessFilter alloc]init]autorelease];
            break;
    }
    
    [self.filter addTarget:gpuImgView];
    [self.filter prepareForImageCapture];
    [self.stillCamera removeAllTargets];
    [self.stillCamera addTarget:filter];
    //[self.stillCamera startCameraCapture];
}

-(void)confirmButtonOnTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(imageDidCapture:)]) {
        [self.delegate imageDidCapture:self.previewView.image];
    }
}

-(void)cancelButtonOnTouch:(id)sender
{
    [self.captureButton setHidden:NO];
    [self.captureButton setEnabled:YES];
    [self.confirmButton setHidden:YES];
    [self.cancelButton setHidden:YES];
    [self.previewView setHidden:YES];
    [self.abortButton setHidden:NO];
    [self initFiltersChain];
}

- (void)abortButtonOnTouch:(id)sender
{
    [self.delegate captureCanceled];
}


@end
