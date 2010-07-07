//
//  Scavenger_iPadAppDelegate.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "Scavenger_iPadAppDelegate.h"
#import "GameListOnlineViewController.h"

@implementation Scavenger_iPadAppDelegate

@synthesize window;
@synthesize rootViewController;
@synthesize locManager;
@synthesize currentLocation;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch
	
	self.rootViewController = [[GameListViewController alloc] initWithNibName:nil bundle:nil];
	self.rootViewController.managedObjectContext = self.managedObjectContext;
	[self.rootViewController reloadData];

	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: self.rootViewController];
	[nav setToolbarHidden:NO animated:YES];
	nav.navigationBar.barStyle = UIBarStyleBlack;
	nav.toolbar.barStyle = UIBarStyleBlack;
	nav.delegate = self.rootViewController;
	
	UISplitViewController *splitController = [[UISplitViewController alloc] init];
	
	GameListOnlineViewController *masterController = [[GameListOnlineViewController alloc] initWithNibName:nil bundle:nil];
	masterController.rootController = self.rootViewController;
	NSArray *controllers = [NSArray arrayWithObjects:masterController,nav,nil];
	splitController.viewControllers = controllers;
	splitController.delegate = self.rootViewController;

	// [window addSubview:nav.view];
	[window addSubview:splitController.view];
    [window makeKeyAndVisible];
    
	//[nav release];

	self.locManager = [[CLLocationManager alloc] init];
	self.locManager.delegate = self;
	self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.locManager.distanceFilter = 5.0f;
	[self.locManager startUpdatingLocation];
    return YES;
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Scavenger_iPad.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[window release];
	[super dealloc];
}

#pragma mark -
#pragma mark Location Manager delegateAuthenticationLock
-(void) locationManager:(CLLocationManager *)manager didFailWithError: (NSError *) error
{
	NSLog(@"Location failed:%@", [error description]);
}

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation: (CLLocation *) newLocation fromLocation: (CLLocation *) oldLocation
{
	NSLog(@"New location");
	self.currentLocation = newLocation;
	// Notify anyone else who is interested
	[[NSNotificationCenter defaultCenter] postNotificationName:@"locationChanged" object:self];
}

@end

