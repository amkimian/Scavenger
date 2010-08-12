//
//  MapNotesAppDelegate.h
//  MapNotes
//
//  Created by Alan Moore on 8/11/10.
//  Copyright 2010 Mount Diablo Software All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NoteMapViewController.h"
#import "NoteLocationListViewController.h"

@interface MapNotesAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
 	NoteMapViewController *mapViewController;
	NoteLocationListViewController *locationListController;
   
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) NoteMapViewController *mapViewController;
@property (nonatomic, retain) NoteLocationListViewController *locationListController;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

@end

