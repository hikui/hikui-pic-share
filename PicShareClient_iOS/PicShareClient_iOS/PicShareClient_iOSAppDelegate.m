//
//  PicShareClient_iOSAppDelegate.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-2-24.
//  Copyright 2012年 Shanghai University. All rights reserved.
//

#import "PicShareClient_iOSAppDelegate.h"
#import "AsyncImageDownloader.h"
#import "PicShareEngine.h"

@implementation PicShareClient_iOSAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    _tabBarController = [[CustomTabBarController alloc]init];
    
    _pictureWallViewController = [[PictureWallViewController alloc]init];
    [_pictureWallViewController.tabBarItem setTitle:@"主页"];
    [_pictureWallViewController.tabBarItem setImage:[UIImage imageNamed:@"house.png"]];
    
    _categoriesViewController = [[CategoriesViewController alloc]initWithNibName:@"CategoriesViewController" bundle:nil];
    UINavigationController *nCategoriesViewController = [[[UINavigationController alloc]initWithRootViewController:_categoriesViewController]autorelease];
    [nCategoriesViewController.tabBarItem setTitle:@"探索"];
    [nCategoriesViewController.tabBarItem setImage:[UIImage imageNamed:@"glass.png"]];
    [_categoriesViewController release];
    
    vc3 = [[ViewController3 alloc]init];
    [vc3.tabBarItem setTitle:@"消息"];
    [vc3.tabBarItem setImage:[UIImage imageNamed:@"mail.png"]];
    

    _userProfileViewController = [[UserDetailViewController alloc]initwithuserId:1];
    UINavigationController *nUserProfileViewController = [[[UINavigationController alloc]initWithRootViewController:_userProfileViewController]autorelease];
    [_userProfileViewController release];
    
    [nUserProfileViewController.tabBarItem setTitle:@"我的"];
    [nUserProfileViewController.tabBarItem setImage:[UIImage imageNamed:@"man"]];
    
    UIViewController *placehoder = [[UIViewController alloc]init];
    [placehoder setTitle:@""];
    [placehoder.tabBarItem setEnabled:false];
    
    [_tabBarController setViewControllers:[NSArray arrayWithObjects:_pictureWallViewController,nCategoriesViewController,placehoder,vc3,nUserProfileViewController, nil]];
    self.window.rootViewController = _tabBarController;
    [self.window makeKeyAndVisible];
    [placehoder release];
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
    [[AsyncImageDownloader sharedAsyncImageDownloader]cleanThumbnailCache];
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [vc3 release];
    [vc4 release];
    [_pictureWallViewController release];
    [super dealloc];
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
