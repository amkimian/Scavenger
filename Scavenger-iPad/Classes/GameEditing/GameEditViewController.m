    //
//  GameEditViewController.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/17/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "GameEditViewController.h"


@implementation GameEditViewController
@synthesize game;
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
	overlayView = [[LocationOverlayView alloc] initWithFrame:mapView.frame];
	overlayView.game = self.game;
	overlayView.delegate = self;
	overlayView.playMode = NO;
	[mapView addSubview:overlayView];
	mapView.delegate = overlayView;
	
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

-(void) locationSelected: (LocationObject *) loc
{
	// What do we do when location is selected?
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