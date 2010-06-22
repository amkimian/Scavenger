//
//  LocationOverlayView.m
//  MDSTH
//
//  Created by Alan Moore on 6/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CLLocation.h>
#import "LocationOverlayView.h"
#import "LocationObject.h"
#import "PlayerLocationObject.h"
#import "LocationPointObject.h"

@implementation LocationOverlayView
@synthesize game;
@synthesize hidden;
@synthesize selectedLocation;
@synthesize delegate;
@synthesize playMode;


// initialize the view

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor]; // set the background
		
		self.hidden = NO;
		self.userInteractionEnabled = YES;
		self.tag = 1001;
		self.selectedLocation = nil;
		playMode = NO;
		releasedAfterSelection = NO;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDataChanged:) name:@"locationDataChanged" object:nil];
    }
    return self;
}

-(void) locationDataChanged: (NSNotification *) notification
{
	[self setNeedsDisplay];
}

/*
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	NSLog(@"Hello from subview hittest");
	return nil;
}
*/

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	NSLog(@"Point inside");
		// Allow selection of locations
		
		LocationObject *o = [self findLocationAtPoint: point];
		if (o)
		{
			NSLog(@"Selected location");
			if (o == self.selectedLocation && releasedAfterSelection)
			{
					// Tell the delegate that a second hit has been made, so maybe pop up something
				NSLog(@"Selected existing location");
				[delegate locationSelectedAgain:self.selectedLocation atPoint: point];
			}
			else
			{
				self.selectedLocation = o;
				releasedAfterSelection = NO;
				[self setNeedsDisplay];
				[delegate locationSelected:self.selectedLocation];
			}
			return YES;
		}
	return NO;
}
	 
-(NSMutableSet *) getLocations
{
	return [game mutableSetValueForKey: @"locations"];
}

-(LocationObject *) findLocationAtPoint: (CGPoint) p
{
	NSArray *locations = [[self getLocations] allObjects];
	MKMapView *mapView = (MKMapView *) [self superview];
	for(LocationObject *o in locations)
	{
		if ([o pointInLocation:p inMap:mapView andView:self])
		{
			return o;
		}
	}
	return nil;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// Is the touch in one of the locations? If so, make it the active touch location
	// if not, pass through the touch
	NSLog(@"Touch began");
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView: self];
	MKMapView *mapView = (MKMapView *) [self superview];
	// Convert to lat and long
	movingCoord = [mapView convertPoint:p toCoordinateFromView: self];
	
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	// If we have a current location move it
	// If not, pass through the touch
	NSLog(@"Touch moved");	
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView: self];
	MKMapView *mapView = (MKMapView *) [self superview];
	// Convert to lat and long
	CLLocationCoordinate2D coord = [mapView convertPoint:p toCoordinateFromView: self];
	if (self.selectedLocation)
	{
		[self.selectedLocation moveWithRelativeFrom: movingCoord to:coord];
		movingCoord = coord;
		[self setNeedsDisplay];
	}
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"Touch ended");
	releasedAfterSelection = YES;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

	
	if (!self.hidden)
	{
		for(LocationObject *loc in game.locations)
		{
			// Eventually color from location Type and state
			[self drawLocation: loc withColor: [loc locationDisplayColor] ];
		}
	}
}

-(void) drawLocation: (LocationObject *) loc withColor: (UIColor *)color
{
		// get the view point for the given map coordinate
		if (playMode == YES && [loc.visible boolValue] == NO)
			return;
	
		MKMapView *mapView = (MKMapView *) self.superview;
	[loc drawLocation:mapView andView:self andAlpha:0.5];
}

- (void)dealloc {
    [super dealloc];
}


// called by the MKMapView when the region is going to change
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:
(BOOL)animated
{
	self.hidden = YES; // hide the view during the transition
	[self setNeedsDisplay];
} // end method mapView:regionWillChangeAnimated:

// called by the MKMapView when the region has finished changing
- (void)mapView:(MKMapView *)mapView
regionDidChangeAnimated:(BOOL)animated
{
	self.hidden = NO; // unhide the view
	// Update the center location
	//LocationObject *centerLocation = [game addLocationOfType:LTYPE_CENTER at:mapView.centerCoordinate];
	//centerLocation.firstPoint.longitude = [NSNumber numberWithFloat: mapView.centerCoordinate.longitude];
	//centerLocation.firstPoint.latitude = [NSNumber numberWithFloat: mapView.centerCoordinate.latitude];	
	[self setNeedsDisplay]; // redraw the view
} // end method mapview:regionDidChangeAnimated:

@end
