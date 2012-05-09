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
#import "PSKeySets.h"

@implementation PicShareClient_iOSAppDelegate

@synthesize window = _window;
@synthesize tabBarController,firstViewController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //set timer to refresh unread messages count
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *userId = [userDefault objectForKey:kUserDefaultsUserId];
    if (YES) {
        [self showFirstRunViewWithAnimate:NO];
    }else{
        [self prepareToMainViewController];
    }
    //self.window.rootViewController = tabBarController;
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
    [firstViewController release];
    [super dealloc];
}

- (void)schedueMessageTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(handleTimer:) userInfo:@"refresh messages count" repeats:YES];
    [timer fire];
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

- (void) prepareToMainViewController
{
    PicShareEngine *engine = [PicShareEngine sharedEngine];
    engine.userId = [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsUserId];
    engine.password = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsPassword];
    engine.username = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsUsername];
    [self schedueMessageTimer];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_window cache:YES];
    [UIView setAnimationDuration:0.4];
    self.window.rootViewController = tabBarController;
    [UIView commitAnimations];
}

- (void) didReceiveUnreadMessageCount:(ASIHTTPRequest *)request
{
    
}

#pragma mark - first load
- (void) showFirstRunViewWithAnimate:(BOOL)animated
{
    if (!firstViewController) {
        firstViewController = [[FirstRunViewController alloc]initWithNibName:@"FirstRunViewController" bundle:nil];
        firstViewController.view.frame = [UIScreen mainScreen].applicationFrame;
    }
    if(animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_window cache:YES];
		[UIView setAnimationDuration:0.4];
	}
	[[_window subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[_window addSubview:firstViewController.view];
	if(animated)
		[UIView commitAnimations];
}

- (void) logout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kUserDefaultsUserId];
    [defaults removeObjectForKey:kUserDefaultsUsername];
    [defaults removeObjectForKey:kUserDefaultsPassword];
    PicShareEngine *engine = [PicShareEngine sharedEngine];
    engine.userId = -1;
    engine.password = nil;
    engine.username = nil;
    [self showFirstRunViewWithAnimate:YES];
}

@end
