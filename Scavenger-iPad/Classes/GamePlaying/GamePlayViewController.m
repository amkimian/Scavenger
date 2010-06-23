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

@implementation GamePlayViewController
@synthesize gameRun;
@synthesize overlayView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	// Start off by zooming in on the location of the game
	LocationObject *centerLocation = [gameRun.game getLocationOfType:LTYPE_CENTER];
	if (centerLocation)
	{
		CLLocationCoordinate2D coordinate;
		coordinate.latitude = [centerLocation.firstPoint.latitude floatValue];
		coordinate.longitude = [centerLocation.firstPoint.longitude floatValue];
		
		MKCoordinateRegion region = MKCoordinateRegionMake(coordinate,
														   MKCoordinateSpanMake(0.01f, 0.01f));
		[mapView setRegion:region animated:YES];
	}	
	overlayView = [[GamePlayOverlayView alloc] initWithFrame:mapView.frame];
	[overlayView setAutoresizingMask:( UIViewAutoresizingFlexibleWidth |
									  UIViewAutoresizingFlexibleHeight )];
	[mapView setAutoresizesSubviews:YES];
	[mapView addSubview:overlayView];
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
