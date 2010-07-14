//
//  AppDelegate_Shared.m
//  CamFlow
//
//  Created by Alan Moore on 7/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AppDelegate_Shared.h"
#import "PairedDeviceObject.h"
#import "CamFolderObject.h"

@implementation AppDelegate_Shared

@synthesize window;
@synthesize fetchedResultsController;

#pragma mark -
#pragma mark Application lifecycle

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    
    NSError *error = nil;
    if (managedObjectContext_ != nil) {
        if ([managedObjectContext_ hasChanges] && ![managedObjectContext_ save:&error]) {
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
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
		NSLog(@"Coordinator");
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
	NSLog(@"Managed object model");
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"CamFlow" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    NSLog(@"Persistent store coordinator");
	
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"CamFlow.sqlite"]];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}

-(void) reloadData
{
	NSError *error;
	
	if (![[self fetchedResultsController] performFetch: &error])
	{
		NSLog(@"Could not load data: %@", [error description ]);
	}	
}

-(void) checkForDefaultFolder
{
	[self reloadData];
	if ([fetchedResultsController.fetchedObjects count] == 0)
	{
		NSEntityDescription *edesc = [NSEntityDescription entityForName:@"PairedDevice" inManagedObjectContext:managedObjectContext_];
		PairedDeviceObject *pd = [[PairedDeviceObject alloc] initWithEntity:edesc insertIntoManagedObjectContext:managedObjectContext_];
		pd.isMe = [NSNumber numberWithBool:YES];
		pd.deviceId = [UIDevice currentDevice].uniqueIdentifier;
		pd.name = @"Me";
		
		NSEntityDescription *edesc1 = [NSEntityDescription entityForName:@"CamFolder" inManagedObjectContext:managedObjectContext_];
		CamFolderObject *fo = [[CamFolderObject alloc] initWithEntity:edesc1 insertIntoManagedObjectContext:managedObjectContext_];
		fo.folderName = @"Default";
		fo.maxImages = [NSNumber numberWithInt: 200];
		fo.takeInterval = [NSNumber numberWithFloat:60];
		fo.takeUnits = [NSNumber numberWithInt:1];
		
		[pd addFoldersObject:fo];
		
		[self reloadData];
	}
}

-(NSArray *) getMyFolders
{
	NSArray *allDevices = [[self fetchedResultsController] fetchedObjects];
	for(PairedDeviceObject *pd in allDevices)
	{
		if ([pd.isMe boolValue] == YES)
		{
			return [pd.folders allObjects];
		}
	}
	return nil;	
}

- (NSFetchedResultsController *)fetchedResultsController
{
	// if a fetched results controller has already been initialized
	if (fetchedResultsController != nil)
		return fetchedResultsController; // return the controller
	
	// create the fetch request for the entity
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	// edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:
								   @"PairedDevice" inManagedObjectContext:managedObjectContext_];
	[fetchRequest setEntity:entity];
	
	// edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor =
	[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors =
	[[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// edit the section name key path and cache name if appropriate
	// nil for section name key path means "no sections"
	NSFetchedResultsController *aFetchedResultsController =
	[[NSFetchedResultsController alloc] initWithFetchRequest:
	 fetchRequest managedObjectContext:managedObjectContext_
										  sectionNameKeyPath:nil cacheName:@"Root"];
	
	aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	[aFetchedResultsController release]; // release temporary controller
	[fetchRequest release]; // release fetchRequest NSFetcheRequest
	[sortDescriptor release]; // release sortDescriptor NSSortDescriptor
	[sortDescriptors release]; // release sortDescriptor NSArray
	
	return fetchedResultsController;
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

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    
    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
    
    [window release];
    [super dealloc];
}


@end

