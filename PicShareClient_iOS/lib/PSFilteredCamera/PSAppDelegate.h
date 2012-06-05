//
//  PSAppDelegate.h
//  PSFilteredCamera
//
//  Created by 和光 缪 on 12-5-21.
//  Copyright (c) 2012年 东方财富网. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSFilteredImagePicker;

@interface PSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PSFilteredImagePicker *picker;

@end
