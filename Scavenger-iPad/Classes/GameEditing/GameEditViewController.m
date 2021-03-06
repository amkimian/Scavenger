    //
//  GameEditViewController.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/17/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "GameEditViewController.h"
#import "ChooseListPopupController.h"
#import "LocationListView.h"
#import "MenuPopupController.h"
#import "RouteListController.h"
#import "LocationPointObject.h"
#import "SingleLocationEditor.h"
#import "PlaceMarkObject.h"

#define ADDLOCTYPEHEIGHT 600

@implementation GameEditViewController

#pragma mark -
#pragma mark Properties

@synthesize game;
@synthesize overlayView;
@synthesize popOver;
@synthesize locationTools;


#pragma mark -
#pragma mark API

-(void) insertNewLocation
{
	ChooseListPopupController *controller = [[ChooseListPopupController alloc] initWithStyle: UITableViewStyleGrouped] ;
	controller.delegate = self;
	CGRect bounds = controller.view.bounds;
	bounds.size.height = ADDLOCTYPEHEIGHT;
	controller.view.bounds = bounds;
	self.popOver = [[UIPopoverController alloc] initWithContentViewController:controller];
	[controller release];
	[self.popOver setPopoverContentSize:controller.view.bounds.size];
	[self.popOver presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny
										 animated:YES];

}

#pragma mark -
#pragma mark Choose Delegate

-(void) didChoose: (LocationType) type from: (ChooseListPopupController *) sender
{
	// Create new location
	
	[[game newLocationOfType:type at:mapView.centerCoordinate] release];
	
	[self.popOver dismissPopoverAnimated:YES];
	self.popOver = nil;
	[self.overlayView setNeedsDisplay];
}

#pragma mark -
#pragma mark API

-(void) chooseMapType: (id) sender
{
	MapTypePopupController *mapTypeController = [[MapTypePopupController alloc] initWithNibName:nil bundle:nil];
	mapTypeController.delegate = self;
	mapTypeController.mapType = mapView.mapType;
	
	self.popOver = [[UIPopoverController alloc] initWithContentViewController:mapTypeController];
	[mapTypeController release];
	[self.popOver setPopoverContentSize:mapTypeController.view.bounds.size];
	[self.popOver presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];	
}

-(void) chooseDetails: (id) sender
{
	LocationListView *controller = [[LocationListView alloc] initWithStyle:UITableViewStylePlain];
	controller.game = self.game;
	
	self.popOver = [[UIPopoverController alloc] initWithContentViewController:controller];
	//[self.popOver setPopoverContentSize:mapTypeController.view.bounds.size];
	[self.popOver presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];	
	[controller release];
	
}


-(void) showRoute: (id) sender
{
	// Show the Route edit dialog
	// Route Name List -> Route Edit (order/delete/add)
	RouteListController *controller = [[RouteListController alloc] initWithStyle: UITableViewStylePlain];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
	[nav setToolbarHidden:NO];
	//nav.modalTransitionStyle = UIModalTransitionStylePartialCurl;
	nav.modalPresentationStyle = UIModalPresentationFormSheet;
	controller.delegate = self;
	controller.game = game;
	[self presentModalViewController:nav animated:YES];	
	[controller release];
}

#pragma mark -
#pragma mark MapType Controller Delegate

-(void) changeMapType: (MKMapType) mapType from:(MapTypePopupController *) sender
{
	mapView.mapType = mapType;
	[self.popOver dismissPopoverAnimated:YES];
	self.popOver = nil;
}

#pragma mark -
#pragma mark ?? Delegate

-(void) didEndRouteList: (RouteListController *) sender
{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark View Lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	// Frame is the whole screen minus the toolbar and nav bar
	overlayView = [[LocationOverlayView alloc] initWithFrame:mapView.frame];
	overlayView.game = self.game;
	overlayView.delegate = self;
	overlayView.playMode = NO;
	[overlayView setAutoresizingMask:( UIViewAutoresizingFlexibleWidth |
                                     UIViewAutoresizingFlexibleHeight )];
	[mapView setAutoresizesSubviews:YES];
	[mapView addSubview:overlayView];
	mapView.delegate = overlayView;

	// Setup toolbar buttons
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																			   target:self
																			   action:@selector(insertNewLocation)];
	
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
	
	// Also setup the toolbar items (we do it this way programattically...)
	
	UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(chooseMapType:)];
	UIBarButtonItem *detailsButton = [[UIBarButtonItem alloc] initWithTitle:@"Details"  style:UIBarButtonItemStyleBordered target:self action:@selector(chooseDetails:)];
	UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																					target:nil
																					action:nil];
	
	UIBarButtonItem *routeButton = [[UIBarButtonItem alloc] initWithTitle:@"Route"  style:UIBarButtonItemStyleBordered target:self action:@selector(showRoute:)];
	
	NSArray *array = [[NSArray alloc] initWithObjects:detailsButton,routeButton,flexibleButton,mapButton, nil];	
	self.toolbarItems = array;
	
	[mapButton release];
	[flexibleButton release];
	[detailsButton release];
	[routeButton release];
	[array release];
	
	// Look for the CENTER location type and scale the mapView to that
	
	LocationObject *centerLocation = [game getLocationOfType:LTYPE_START];
	if (centerLocation)
	{
		CLLocationCoordinate2D coordinate;
		coordinate.latitude = [centerLocation.firstPoint.latitude floatValue];
		coordinate.longitude = [centerLocation.firstPoint.longitude floatValue];
		
		MKCoordinateRegion region = MKCoordinateRegionMake(coordinate,
													   MKCoordinateSpanMake(0.01f, 0.01f));
		[mapView setRegion:region animated:YES];
		// If the Game doesn't have a PlaceMark object attached, start a ReverseGeoCoder to get one
		
		if (game.placeMark == nil)
		{
			self.locationTools = [[LocationTools alloc] init];
			self.locationTools.coordinate = coordinate;
			[self.locationTools resolveGeocode];
		}	
	}
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


#pragma mark -
#pragma mark Reverse Geocode delegate

- (void) locationFound
{
	NSLog(@"Found location placemark");
	// Add a placemark
	NSEntityDescription *edesc = [NSEntityDescription entityForName:@"PlaceMark" inManagedObjectContext:[game managedObjectContext]];
	PlaceMarkObject *placeMark = [[PlaceMarkObject alloc] initWithEntity:edesc insertIntoManagedObjectContext:[game managedObjectContext]];
	
	placeMark.administrativeArea = self.locationTools.administrativeArea;
	placeMark.country = self.locationTools.country;
	placeMark.locality = self.locationTools.locality;
	placeMark.postalCode = self.locationTools.postalCode;
	game.placeMark = placeMark;
}

#pragma mark -
#pragma mark Location Edit Delegate

-(void) editLocationDidFinishEditing:(EditLocationController *) controller
{
	// Dismiss modal dialog for the location editing...
	[self dismissModalViewControllerAnimated:YES];
	overlayView.selectedLocation = nil;
	[overlayView setNeedsDisplay];
}

#pragma mark -
#pragma mark Menu Popup Delegate

-(void) didSelectItem: (NSUInteger) item from:(MenuPopupController *) sender
{
	// We selected a menu item (this will curently be from Location click)
	switch(item)
	{
		case 0:
			// Edit Details
		{
			EditLocationController *controller = [[EditLocationController alloc] initWithStyle: UITableViewStyleGrouped];
			UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
			//nav.modalTransitionStyle = UIModalTransitionStylePartialCurl;
			nav.modalPresentationStyle = UIModalPresentationFormSheet;
			controller.delegate = self;
			controller.location = overlayView.selectedLocation;
			[self presentModalViewController:nav animated:YES];
			[controller release];
		}
			 break;
		case 1:
			// Edit shape
		{
			SingleLocationEditor *controller = [[SingleLocationEditor alloc] initWithNibName:nil bundle:nil];
			controller.location = overlayView.selectedLocation;
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		}
			break;
		case 2:
			// Delete
			[game removeLocationObject:overlayView.selectedLocation];
			overlayView.selectedLocation = nil;
			[overlayView setNeedsDisplay];
			break;
	}	
	[self.popOver dismissPopoverAnimated:YES];
	self.popOver = nil;
}


-(void) locationSelected: (LocationObject *) loc
{
	// What do we do when location is selected?
}

#pragma mark -
#pragma mark Internal

-(void) showIt
{
	[self.popOver presentPopoverFromRect:savedRect inView:overlayView permittedArrowDirections:UIPopoverArrowDirectionAny
								animated:YES];
}

-(void) locationSelectedAgain: (LocationObject *) loc atPoint: (CGPoint) p
{
	// A location has been selected, and clicked again. Show a popup menu for actions
	MenuPopupController *controller = [[MenuPopupController alloc] initWithStyle: UITableViewStylePlain];
	controller.delegate = self;
	controller.menuStrings = [NSArray arrayWithObjects:@"Edit Details",@"Edit Shape",@"Delete",nil];
	self.popOver = [[UIPopoverController alloc] initWithContentViewController:controller];
	[self.popOver setPopoverContentSize:controller.view.bounds.size];
	savedRect.origin = p;
	savedRect.size.height = 10;
	savedRect.size.width = 10;
	
	[self performSelector:@selector(showIt) withObject:nil afterDelay:0.1];
	[controller release];
}


@end
