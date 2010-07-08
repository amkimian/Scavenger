//
//  Scavenger_iPadAppDelegate.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GameListViewController.h"
#import "AWSScavenger.h"

@interface Scavenger_iPadAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate,AWSDataChangedDelegate> {

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

    UIWindow *window;
	GameListViewController *rootViewController;
	CLLocationManager *locManager;
	CLLocation *currentLocation;
	AWSScavenger *awsScavenger;	
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) GameListViewController *rootViewController;

@property (nonatomic, retain) CLLocationManager *locManager;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) AWSScavenger *awsScavenger;

- (NSString *)applicationDocumentsDirectory;

@end

