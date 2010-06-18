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


@implementation GameEditViewController
@synthesize game;
@synthesize overlayView;
@synthesize popOver;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

-(void) insertNewLocation
{
	ChooseListPopupController *controller = [[ChooseListPopupController alloc] initWithStyle: UITableViewStyleGrouped] ;
	controller.delegate = self;
	self.popOver = [[UIPopoverController alloc] initWithContentViewController:controller];
	[self.popOver setPopoverContentSize:controller.view.bounds.size];
	[self.popOver presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny
										 animated:YES];
}

-(void) didChoose: (LocationType) type from: (ChooseListPopupController *) sender
{
	// Create new location
	
	LocationObject *loc = [game addLocationOfType:type];
	loc.longitude = [NSNumber numberWithFloat: mapView.centerCoordinate.longitude];
	loc.latitude = [NSNumber numberWithFloat: mapView.centerCoordinate.latitude];
	loc.size = [NSNumber numberWithFloat: 50.0f]; // FOR NOW	
	
	[self.popOver dismissPopoverAnimated:YES];
	self.popOver = nil;
	[self.overlayView setNeedsDisplay];
}

-(void) chooseMapType: (id) sender
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
}

-(void) didEndRouteList: (RouteListController *) sender
{
	[self dismissModalViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	overlayView = [[LocationOverlayView alloc] initWithFrame:mapView.frame];
	overlayView.game = self.game;
	overlayView.delegate = self;
	overlayView.playMode = NO;
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
	
	LocationObject *centerLocation = [game getLocationOfType:LTYPE_CENTER];
	if (centerLocation)
	{
		CLLocationCoordinate2D coordinate;
		coordinate.latitude = [centerLocation.latitude floatValue];
		coordinate.longitude = [centerLocation.longitude floatValue];
		
		MKCoordinateRegion region = MKCoordinateRegionMake(coordinate,
													   MKCoordinateSpanMake(0.01f, 0.01f));
		[mapView setRegion:region animated:YES];
	}
}

-(void) editLocationDidFinishEditing:(EditLocationController *) controller
{
	// Dismiss modal dialog for the location editing...
	[self dismissModalViewControllerAnimated:YES];
	overlayView.selectedLocation = nil;
	[overlayView setNeedsDisplay];
}

-(void) didSelectItem: (NSUInteger) item from:(MenuPopupController *) sender
{
	// We selected a menu item (this will curently be from Location click)
	switch(item)
	{
		case 0:
			// Edit
		{
			EditLocationController *controller = [[EditLocationController alloc] initWithStyle: UITableViewStyleGrouped];
			UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
			//nav.modalTransitionStyle = UIModalTransitionStylePartialCurl;
			nav.modalPresentationStyle = UIModalPresentationFormSheet;
			controller.delegate = self;
			controller.location = overlayView.selectedLocation;
			[self presentModalViewController:nav animated:YES];
		}
			 break;
		case 1:
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
	controller.menuStrings = [NSArray arrayWithObjects:@"Edit",@"Delete",nil];
	self.popOver = [[UIPopoverController alloc] initWithContentViewController:controller];
	[self.popOver setPopoverContentSize:controller.view.bounds.size];
	savedRect.origin = p;
	savedRect.size.height = 10;
	savedRect.size.width = 10;
	
	[self performSelector:@selector(showIt) withObject:nil afterDelay:0.1];
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


@end
