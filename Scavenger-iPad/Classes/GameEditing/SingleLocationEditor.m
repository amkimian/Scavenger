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

-(void) moveMode: (id) sender
{
	overlayView.mode = MODE_MOVE;
	self.title = @"Mode = Move";
}

-(void) deleteMode: (id) sender
{
	overlayView.mode = MODE_DELETE;
	self.title = @"Mode = Delete";
}

-(void) addMode: (id) sender
{
	overlayView.mode = MODE_ADD;
	self.title = @"Mode = Add";
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title = location.name;
	// Zoom map onto location point
	
	UIBarButtonItem *moveButton = [[UIBarButtonItem alloc] initWithTitle:@"Move" style:UIBarButtonItemStyleBordered target:self action:@selector(moveMode:)];
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addMode:)];
	UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete"  style:UIBarButtonItemStyleBordered target:self action:@selector(deleteMode:)];
	UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																					target:nil
																					action:nil];
	
	NSArray *array = [[NSArray alloc] initWithObjects:flexibleButton,moveButton,addButton,deleteButton, nil];	
	self.toolbarItems = array;
	[moveButton release];
	[addButton release];
	[deleteButton release];
	[flexibleButton release];
	
	LocationPointObject *firstPoint = location.firstPoint;
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = [firstPoint.latitude floatValue];
	coordinate.longitude = [firstPoint.longitude floatValue];
	
	MKCoordinateRegion region = MKCoordinateRegionMake(coordinate,
													   MKCoordinateSpanMake(0.01f, 0.01f));
	[mapView setRegion:region animated:YES];
    
	overlayView = [[SingleLocationView alloc] initWithFrame: mapView.frame];
	overlayView.location = self.location;
	overlayView.delegate = self;
	mapView.delegate = overlayView;
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

-(void) selectedLocationPoint: (LocationPointObject *) point
{
	selectedPoint = point;
}

-(void) clickedWithNoSelectionAtPoint: (CGPoint) point
{
	
}


@end
