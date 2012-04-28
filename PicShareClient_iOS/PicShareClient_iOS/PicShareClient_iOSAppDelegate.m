//
//  PicShareClient_iOSAppDelegate.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-2-24.
//  Copyright 2012年 Shanghai University. All rights reserved.
//

#import "PicShareClient_iOSAppDelegate.h"
#import "PicShareEngine.h"
#import "Common.h"

@implementation PicShareClient_iOSAppDelegate

@synthesize window = _window;
@synthesize tabBarController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //set timer to refresh unread messages count
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(handleTimer:) userInfo:@"refresh messages count" repeats:YES];
    [timer fire];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *userId = [userDefault objectForKey:@"userid"];
    if (userId == nil) {
        [userDefault setObject:@"user1" forKey:@"username"];
        [userDefault setObject:@"user1" forKey:@"password"];
        [userDefault setObject:[NSNumber numberWithInt:1] forKey:@"userid"];
        [userDefault synchronize];
    }else{
        PicShareEngine *engine = [PicShareEngine sharedEngine];
        engine.userId = [userDefault integerForKey:@"userid"];
        engine.password = [userDefault stringForKey:@"password"];
        engine.username = [userDefault stringForKey:@"username"];
    }
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"application did receive memory warning");
    //[[AsyncImageDownloader sharedAsyncImageDownloader]cleanThumbnailCache];
    Common *common = [Common sharedCommon];
    [common receiveMemoryWarning];
}

- (void)dealloc
{
    [_window release];
    [tabBarController release];
    [super dealloc];
}

- (void) handleTimer: (NSTimer *) timer
{
    NSLog(@"timer fired");
    PicShareEngine *engine = [PicShareEngine sharedEngine];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSInteger count = [engine getUnreadMessagesCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self.tabBarController.tabBar.items objectAtIndex:3]setBadgeValue:[NSString stringWithFormat:@"%d",count]];
        });
    });
    
}

- (void) didReceiveUnreadMessageCount:(ASIHTTPRequest *)request
{
    
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
