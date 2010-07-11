//
//  MapTypePopupController.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "MapTypePopupController.h"


@implementation MapTypePopupController
@synthesize delegate;
@synthesize mapType;

-(void) updateMapType
{
	int whichSegment = 0;
	switch(mapType)
	{
		case MKMapTypeStandard:
			whichSegment = 0;
			break;
		case MKMapTypeHybrid:
			whichSegment = 1;
			break;
		case MKMapTypeSatellite:
			whichSegment = 2;
			break;
	}
	segmentControl.selectedSegmentIndex = whichSegment;
}

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
	[self updateMapType];
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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

-(IBAction) selectionChanged: (id) sender
{
	switch(segmentControl.selectedSegmentIndex)
	{
		case 0:
		default:
			mapType = MKMapTypeStandard;
			break;
		case 1:
			mapType = MKMapTypeHybrid;
			break;
		case 2:
			mapType = MKMapTypeSatellite;
			break;
	}
	
	[delegate changeMapType:mapType from:self];
}

- (void)dealloc {
    [super dealloc];
}


@end
