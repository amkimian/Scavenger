//
//  GameListViewController.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapTypePopupController.h"
#import "GameObject+Extensions.h"
#import "GetTextPopupController.h"
#import "GameActionPopupController.h"

/**
 * This view controller handles the first view that gets shown from application
 * start. The main view is of a map view (with ancilliary controls for that)
 *
 * There's also an add button for creating a new game.
 * Games (that have a start location) are shown on the map as annotations
 */

@interface GameListViewController : UIViewController<MapTypeChangedDelegate, 
								CLLocationManagerDelegate, 
								NSFetchedResultsControllerDelegate, 
								GetTextPopupDelegate,
								MKMapViewDelegate,
								GameActionDelegate> {
	NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *fetchedResultsController;
	UIPopoverController *popOver;
	UIBarButtonItem *locateButton;
	
	IBOutlet MKMapView* mapView;
	BOOL scanningForLocation;
	CLLocationManager *locManager;
	CLLocation *currentLocation;
	
	
}

-(void) insertNewObject;
-(void) addAllAnnotations;

-(IBAction) centerOnLocation: (id) sender;
-(IBAction) chooseMapType: (id) sender;

-(void) changeMapType: (MKMapType) mapType from:(MapTypePopupController *) sender;
-(void) textChangedFrom: (GetTextPopupController *) sender;
-(void) selectedAction: (GameActionType) actionType from: (GameActionPopupController *) sender;

- (NSFetchedResultsController *)fetchedResultsController;

-(void) addGameAnnotation: (GameObject *) game;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) UIPopoverController *popOver;

@property (nonatomic, retain) CLLocationManager *locManager;
@property (nonatomic, retain) CLLocation *currentLocation;

@property (nonatomic, retain) UIBarButtonItem *locateButton;

@end
