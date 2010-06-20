    //
//  SingleLocationEditor.m
//  POC-Location
//
//  Created by Alan Moore on 6/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SingleLocationEditor.h"
#import "LocationPointObject.h"

@implementation SingleLocationEditor
@synthesize location;

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
	self.title = location.name;
	// Zoom map onto location point
	LocationPointObject *firstPoint = location.firstPoint;
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = [firstPoint.latitude floatValue];
	coordinate.longitude = [firstPoint.longitude floatValue];
	
	MKCoordinateRegion region = MKCoordinateRegionMake(coordinate,
													   MKCoordinateSpanMake(0.01f, 0.01f));
	[mapView setRegion:region animated:YES];
    
	overlayView = [[SingleLocationView alloc] initWithFrame: mapView.frame];
//	overlayView.delegate = self;
	[mapView addSubview:overlayView];
	
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


@end
