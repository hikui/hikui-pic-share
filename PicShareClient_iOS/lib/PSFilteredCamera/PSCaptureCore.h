//
//  PSViewController.h
//  PSFilteredCamera
//
//  Created by 和光 缪 on 12-5-21.
//  Copyright (c) 2012年 东方财富网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@protocol PSCaptureDelegate <NSObject>

-(void)imageDidCapture:(UIImage *)image;
-(void)captureCanceled;

@end

@interface PSCaptureCore : UIViewController

@property (nonatomic,retain) IBOutlet GPUImageView *gpuImgView;
@property (nonatomic,retain) GPUImageStillCamera *stillCamera;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic,retain) IBOutlet UIImageView *previewView;
@property (nonatomic,retain) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic,assign) id<PSCaptureDelegate> delegate;
@property (nonatomic,retain) IBOutlet UIButton *captureButton;
@property (nonatomic,retain) IBOutlet UIButton *confirmButton;
@property (nonatomic,retain) IBOutlet UIButton *cancelButton;
@property (nonatomic,retain) IBOutlet UIButton *abortButton;

-(IBAction)captureButtonOnTouch:(id)sender;
-(IBAction)filterTypeButtonOnTouch:(id)sender;
-(IBAction)confirmButtonOnTouch:(id)sender;
-(IBAction)cancelButtonOnTouch:(id)sender;
-(IBAction)abortButtonOnTouch:(id)sender;

@end
