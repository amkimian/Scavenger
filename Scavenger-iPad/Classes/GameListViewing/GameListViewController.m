    //
//  GameListViewController.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "GameListViewController.h"
#import "MapTypePopupController.h"

@implementation GameListViewController
@synthesize managedObjectContext;
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
	// Fetch the games and create the annotations...
	self.title = @"Scavenger Games";
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
    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

#pragma -
#pragma buttonActions

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
	// Create a game, with a location (of type map) centered on the current view of the map
	// Popup an edit control to get the text for the name of the game, then insert and add the annotation to the screen
	// To edit this new game a user will select the annotation and click edit (or do we simply push the edit control directly here?)
	
	
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


@end
