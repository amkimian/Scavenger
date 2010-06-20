    //
//  LocationListViewController.m
//  POC-Location
//
//  Created by Alan Moore on 6/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationListViewController.h"
#import "LocationObject.h"

@implementation LocationListViewController
@synthesize managedObjectContext;
@synthesize fetchedResultsController;
@synthesize popOver;
@synthesize locManager;
@synthesize currentLocation;
@synthesize locateButton;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

-(void) locationManager:(CLLocationManager *)manager didFailWithError: (NSError *) error
{
	NSLog(@"Location failed:%@", [error description]);
	scanningForLocation = NO;
	[self.locManager stopUpdatingLocation];
	self.locateButton.title = @"Locate";
}

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation: (CLLocation *) newLocation fromLocation: (CLLocation *) oldLocation
{
	NSLog(@"New location");
	self.currentLocation = newLocation;
	MKCoordinateRegion region = MKCoordinateRegionMake(newLocation.coordinate,
													   MKCoordinateSpanMake(0.01f, 0.01f));
	[mapView setRegion:region animated:YES];
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title = @"AM - Test Location Editing";
	scanningForLocation = NO;
	self.locManager = [[CLLocationManager alloc] init];
	self.locManager.delegate = self;
	self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.locManager.distanceFilter = 5.0f;
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																			   target:self
																			   action:@selector(insertNewObject)];
	
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
	
	// Also setup the toolbar items (we do it this way programattically...)
	
	UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(chooseMapType:)];
	self.locateButton = [[UIBarButtonItem alloc] initWithTitle:@"Locate"  style:UIBarButtonItemStyleBordered target:self action:@selector(centerOnLocation:)];
	UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																					target:nil
																					action:nil];
	
	NSArray *array = [[NSArray alloc] initWithObjects:flexibleButton,mapButton,self.locateButton, nil];	
	self.toolbarItems = array;
	
	[mapButton release];
	[flexibleButton release];
	[array release];
	
	// Now need to fetch the games and put out the annotations...
	NSError *error;
	
	if (![[self fetchedResultsController] performFetch: &error])
	{
		NSLog(@"Could not load data: %@", [error description ]);
	}
	
    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(IBAction) centerOnLocation: (id) sender
{
	// Depending on whether we are toggling this button on or off, 
	// start monitoring location or stop monitoring location
	
	// When the location comes in, if we are monitoring, center the map on that location with a region size of 0.01f (as a default)
	// And then stop monitoring location (after a certain amount of time or when there is an error)
	if (scanningForLocation == YES)
	{
		[self.locManager stopUpdatingLocation];
		scanningForLocation = NO;
		self.locateButton.title = @"Locate";
	}
	else
	{
		scanningForLocation = YES;
		[self.locManager startUpdatingLocation];
		self.locateButton.title = @"Stop";
	}
}

-(IBAction) chooseMapType: (id) sender
{
	MapTypePopupController *mapTypeController = [[MapTypePopupController alloc] initWithNibName:nil bundle:nil];
	mapTypeController.delegate = self;
	mapTypeController.mapType = mapView.mapType;
	
	self.popOver = [[UIPopoverController alloc] initWithContentViewController:mapTypeController];
	[self.popOver setPopoverContentSize:mapTypeController.view.bounds.size];
	[self.popOver presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void) changeMapType: (MKMapType) mapType from:(MapTypePopupController *) sender
{
	mapView.mapType = mapType;
	[self.popOver dismissPopoverAnimated:YES];
	self.popOver = nil;
}

-(void) insertNewObject
{
	GetTextPopupController *controller = [[GetTextPopupController alloc] initWithNibName:nil bundle:nil];
	controller.delegate = self;
	self.popOver = [[UIPopoverController alloc] initWithContentViewController:controller];
	[self.popOver setPopoverContentSize:controller.view.bounds.size];
	[self.popOver presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void) textChangedFrom: (GetTextPopupController *) sender
{
	// Create a game, with a location (of type map) centered on the current view of the map
	// Popup an edit control to get the text for the name of the game, then insert and add the annotation to the screen
	// To edit this new game a user will select the annotation and click edit (or do we simply push the edit control directly here?)
	
	NSLog(@"Add new location");
	
	NSEntityDescription *edesc = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:managedObjectContext];
	LocationObject *location = [[LocationObject alloc] initWithEntity:edesc insertIntoManagedObjectContext:managedObjectContext];
	location.name = sender.textField.text;
	// And add a location of type "Center", centered on the current map position with size the range of the mapView
	
	[self.popOver dismissPopoverAnimated:YES];
	self.popOver = nil;
	// Need to add first point for this
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
								   @"Location" inManagedObjectContext:managedObjectContext];
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
	 fetchRequest managedObjectContext:managedObjectContext
										  sectionNameKeyPath:nil cacheName:@"Root"];
	
	aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	[aFetchedResultsController release]; // release temporary controller
	[fetchRequest release]; // release fetchRequest NSFetcheRequest
	[sortDescriptor release]; // release sortDescriptor NSSortDescriptor
	[sortDescriptors release]; // release sortDescriptor NSArray
	
	return fetchedResultsController;
}  

/**
 * When we click on a location, not done as yet
 */

-(void) didSelectItem: (NSUInteger) item from:(MenuPopupController *) sender
{
	[self.popOver dismissPopoverAnimated:YES];
	self.popOver = nil;			
}

@end
