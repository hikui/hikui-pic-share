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
#import "ViewController3.h"
#import "ViewController4.h"

@interface PicShareClient_iOSAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>
{
    ViewController1 *vc1;
    ViewController2 *vc2;
    ViewController3 *vc3;
    ViewController4 *vc4;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) CustomTabBarController *tabBarController;

@end
