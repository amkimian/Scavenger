//
//  LocationListViewController.h
//  POC-Location
//
//  Created by Alan Moore on 6/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapTypePopupController.h"
#import "MenuPopupController.h"
#import "GetTextPopupController.h"

@interface LocationListViewController : UIViewController<UINavigationControllerDelegate,MapTypeChangedDelegate, 
CLLocationManagerDelegate, 
NSFetchedResultsControllerDelegate, 
GetTextPopupDelegate,
MKMapViewDelegate,
MenuPopupDelegate> {
	NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *fetchedResultsController;
	UIPopoverController *popOver;
	UIBarButtonItem *locateButton;
	
	IBOutlet MKMapView* mapView;
	BOOL scanningForLocation;
	CLLocationManager *locManager;
	CLLocation *currentLocation;
}

// MapTypeChangeDelegate
-(void) changeMapType: (MKMapType) mapType from:(MapTypePopupController *) sender;

// GetTextPopupDelegate
-(void) textChangedFrom: (GetTextPopupController *) sender;

// MenuPopupDelegate
-(void) didSelectItem: (NSUInteger) item from:(MenuPopupController *) sender;

- (NSFetchedResultsController *)fetchedResultsController;


-(void) insertNewObject;
-(IBAction) centerOnLocation: (id) sender;
-(IBAction) chooseMapType: (id) sender;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) UIPopoverController *popOver;

@property (nonatomic, retain) CLLocationManager *locManager;
@property (nonatomic, retain) CLLocation *currentLocation;

@property (nonatomic, retain) UIBarButtonItem *locateButton;

@end
