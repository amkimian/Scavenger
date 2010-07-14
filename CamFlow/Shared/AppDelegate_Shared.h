//
//  AppDelegate_Shared.h
//  CamFlow
//
//  Created by Alan Moore on 7/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define APPDELEGATE (AppDelegate_Shared *) [UIApplication sharedApplication].delegate

@interface AppDelegate_Shared : NSObject <UIApplicationDelegate, NSFetchedResultsControllerDelegate> {
    
    UIWindow *window;
	NSFetchedResultsController *fetchedResultsController;
    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

- (NSFetchedResultsController *)fetchedResultsController;
-(void) reloadData;
-(void) checkForDefaultFolder;
-(NSArray *) getMyFolders;


@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (NSString *)applicationDocumentsDirectory;

@end

