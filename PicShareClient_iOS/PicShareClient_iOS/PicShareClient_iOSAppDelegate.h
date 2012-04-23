//
//  PicShareClient_iOSAppDelegate.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-2-24.
//  Copyright 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarController.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import "PictureWallViewController.h"
#import "CategoriesViewController.h"
#import "UserDetailViewController.h"
#import "TimelineViewController.h"
#import "ASIHTTPRequest.h"

@interface PicShareClient_iOSAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CustomTabBarController *tabBarController;

- (void) handleTimer: (NSTimer *) timer;
- (void) didReceiveUnreadMessageCount:(ASIHTTPRequest *)request;

@end
