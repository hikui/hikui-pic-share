//
//  PSFilteredImagePicker.h
//  PSFilteredCamera
//
//  Created by 和光 缪 on 12-5-21.
//  Copyright (c) 2012年 东方财富网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCaptureCore.h"

@class PSFilteredImagePicker;
@protocol PSFilteredImagePickerDelegate <NSObject>

- (void)imagePickerController:(PSFilteredImagePicker *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(PSFilteredImagePicker *)picker;

@end


@interface PSFilteredImagePicker : UINavigationController<PSCaptureDelegate>

@property (nonatomic,assign) id<PSFilteredImagePickerDelegate,UINavigationControllerDelegate> delegate;
@property (nonatomic,retain) PSCaptureCore *core;

@end

