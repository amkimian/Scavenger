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
#import "MenuPopupController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

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
								MenuPopupDelegate,
								UINavigationControllerDelegate,
								MFMailComposeViewControllerDelegate,
								UISplitViewControllerDelegate> {
	NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *fetchedResultsController;
	UIPopoverController *popOver;
	UIBarButtonItem *locateButton;
	
	IBOutlet MKMapView* mapView;
	BOOL scanningForLocation;
	GameObject *currentGame;	
}

-(void) insertNewObject;
-(void) addAllAnnotations;

-(IBAction) chooseMapType: (id) sender;

-(void) changeMapType: (MKMapType) mapType from:(MapTypePopupController *) sender;
-(void) textChangedFrom: (GetTextPopupController *) sender;

-(IBAction) goOnline: (id) sender;
-(void) finishedOnline;

-(void) didSelectItem: (NSUInteger) item from:(MenuPopupController *) sender;
-(void) reloadData;
-(void) locationChangeNotification: (NSNotification *) n;

- (NSFetchedResultsController *)fetchedResultsController;

-(void) addGameAnnotation: (GameObject *) game;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) UIPopoverController *popOver;
@property (nonatomic, retain) GameObject *currentGame;


@property (nonatomic, retain) UIBarButtonItem *locateButton;

@end
