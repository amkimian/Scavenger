//
//  AppDelegate_iPhone.m
//  CamFlow
//
//  Created by Alan Moore on 7/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "TopLevelMenu_iPhone.h"
#import "FolderListTableViewController_iPhone.h"
#import "DeviceListTableViewController.h"
#import "ASIS3Request.h"
#import "TopLevelTabBarController.h"
#import "CameraFolderTableViewController.h"
#import "DeviceListViewController.h"
#import "Three20/Three20.h"

@implementation AppDelegate_iPhone


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch.

	[ASIS3Request setSharedSecretAccessKey:@"o3Nw5NnnamrywCy7m6gIEBEQiKZrnROP/cxuvvLy"];
	[ASIS3Request setSharedAccessKey:@"0289QDXAHCXX0JH9GXR2"];	

	NSManagedObjectContext *ctx = self.managedObjectContext;

	[self checkForDefaultFolder];
	
	
	// Now use Three20
	TTNavigator *navigator = [TTNavigator navigator];
	navigator.window = window;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	TTURLMap *map = navigator.URLMap;
	
	[map from:@"*" toViewController:[TTWebController class]];
	[map from:@"cf://tabBar" toViewController:[TopLevelTabBarController class]];
	[map from:@"cf://camera" toSharedViewController:[CameraFolderTableViewController class]];
	[map from:@"cf://viewer" toSharedViewController:[DeviceListViewController class]];
	
	if (![navigator restoreViewControllers])
	{
		[navigator openURLAction:[TTURLAction actionWithURLPath:@"cf://tabBar"]];
	}
	
	/*
	
	
	// Use this to setup the context
	// use a tab controller
	
	FolderListTableViewController_iPhone *camController = [[FolderListTableViewController_iPhone alloc] initWithStyle:UITableViewStyleGrouped andType:FolderType_CamMode];
	DeviceListTableViewController *viewController = [[DeviceListTableViewController alloc] initWithStyle:UITableViewStylePlain];

	UINavigationController *camNav = [[UINavigationController alloc] initWithRootViewController:camController];
	camNav.toolbarHidden = NO;
	UINavigationController *playNav = [[UINavigationController alloc] initWithRootViewController:viewController];
	playNav.toolbarHidden = NO;
	NSArray *controllers = [[NSArray alloc ]initWithObjects: camNav, playNav, nil];
	
	UITabBarController *tc = [[UITabBarController alloc] init];
	tc.viewControllers = controllers;
	tc.customizableViewControllers = controllers;
	tc.delegate = self;
	
	[window addSubview:tc.view];
	 */
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 Superclass implementation saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	[super applicationWillTerminate:application];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    [super applicationDidReceiveMemoryWarning:application];
}


- (void)dealloc {
	
	[super dealloc];
}


@end

