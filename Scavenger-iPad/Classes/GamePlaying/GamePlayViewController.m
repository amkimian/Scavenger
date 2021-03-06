    //
//  GamePlayViewController.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/22/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "GamePlayViewController.h"
#import "GameObject+Extensions.h"
#import "LocationObject+Extensions.h"
#import "LocationPointObject.h"
#import "GameManager.h"
#import "GameScoreTableViewController.h"

@implementation GamePlayViewController

#pragma mark -
#pragma mark Properties

@synthesize gameRun;
@synthesize overlayView;
@synthesize manager;
@synthesize locManager;
@synthesize currentLocation;
@synthesize mapView;
@synthesize mapRadius;


#pragma mark -
#pragma mark Setup

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		manager = [[GameManager alloc] init];
		manager.gamePlayController = self;
		moving = NO;
		simulating = NO;
		mapRadius = 0.005f;
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	manager.gameRun = self.gameRun;
	// Start off by zooming in on the location of the game
	LocationObject *centerLocation = [gameRun.game getLocationOfType:LTYPE_START];
	if (centerLocation)
	{
		CLLocationCoordinate2D coordinate;
		coordinate.latitude = [centerLocation.firstPoint.latitude floatValue];
		coordinate.longitude = [centerLocation.firstPoint.longitude floatValue];
		
		MKCoordinateRegion region = MKCoordinateRegionMake(coordinate,
														   MKCoordinateSpanMake(mapRadius, mapRadius));
		[mapView setRegion:region animated:YES];
	}	
	overlayView = [[GamePlayOverlayView alloc] initWithFrame:mapView.frame];
	[overlayView setAutoresizingMask:( UIViewAutoresizingFlexibleWidth |
									  UIViewAutoresizingFlexibleHeight )];
	[mapView setAutoresizesSubviews:YES];
	[mapView addSubview:overlayView];
	mapView.delegate = overlayView;
	[manager setupGameFromLoad];
	overlayView.gameRun = self.gameRun;
	[overlayView setNeedsDisplay];
	
	self.locManager = [[CLLocationManager alloc] init];
	self.locManager.delegate = self;
	self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.locManager.distanceFilter = 5.0f;
	[self.locManager startUpdatingLocation];
	
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
	NSLog(@"View unloading");
	[self.manager pause];
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSLog(@"Pausing manager/game");
	[self.manager pause];	
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark General View Management


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

#pragma mark -
#pragma mark Controller

-(void) showGameOver
{
	GameScoreTableViewController *tv = [[GameScoreTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	tv.gameRun = self.gameRun;
	UIView *v = overlayView.hudView;
	UIPopoverController *popOver = [[UIPopoverController alloc] initWithContentViewController:tv];
	[popOver presentPopoverFromRect:v.bounds inView:v permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	[tv release];
	[popOver release];
}


-(void) resetMapView
{
	// This is how you would handle compass heading...
	// [mapView setTransform:CGAffineTransformMakeRotation(-1 * currentHeading.magneticHeading * 3.14159 / 180)];
	// with also the transform for the GamePlayOverlayView
	
	MKCoordinateRegion region = MKCoordinateRegionMake(self.currentLocation.coordinate,
													   MKCoordinateSpanMake(mapRadius, mapRadius));
	[mapView setRegion:region animated:YES];
	[overlayView setNeedsDisplay];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

-(void) locationManager:(CLLocationManager *)manager didFailWithError: (NSError *) error
{
}

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation: (CLLocation *) newLocation fromLocation: (CLLocation *) oldLocation
{
	NSLog(@"New location");
	self.currentLocation = newLocation;
	[self resetMapView];
}

#pragma mark -
#pragma mark Simulation

-(void) simulateMoveTo: (CLLocationCoordinate2D) dest
{
	destination = dest;
	moving = YES;
	if (simulating == NO)
	{
		simulating = YES;
		[self.locManager stopUpdatingLocation];
	}	
}

-(void) tick
{
	if (simulating && moving)
	{
		float latDelta = self.currentLocation.coordinate.latitude - destination.latitude;
		float longDelta = self.currentLocation.coordinate.longitude - destination.longitude;
		
		CLLocationCoordinate2D coord = self.currentLocation.coordinate;
		if (latDelta < 0.001)
		{
			coord.latitude = destination.latitude;
		}
		else
		{
			coord.latitude -= latDelta / 10;
		}
		if (longDelta < 0.001)
		{
			coord.longitude = destination.longitude;
		}
		else
		{
			coord.longitude -= longDelta / 10;
		}	
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
		[self locationManager:nil didUpdateToLocation:loc fromLocation:nil];
		}	
}


@end
