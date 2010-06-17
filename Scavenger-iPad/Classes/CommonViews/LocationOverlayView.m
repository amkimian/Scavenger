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
    }
    return self;
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
			self.selectedLocation = o;
			[self setNeedsDisplay];
			if (delegate)
			{
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
		CLLocationCoordinate2D coord;
		coord.latitude = [o.latitude floatValue];
		coord.longitude = [o.longitude floatValue];
		MKCoordinateRegion r = MKCoordinateRegionMakeWithDistance(coord, [o.size floatValue], [o.size floatValue]);
		
		CGRect rect = [mapView convertRegion:r toRectToView:self];
		if (CGRectContainsPoint(rect, p))
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
		self.selectedLocation.latitude = [NSNumber numberWithFloat: coord.latitude];
		self.selectedLocation.longitude = [NSNumber numberWithFloat: coord.longitude];
		[self setNeedsDisplay];
	}
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"Touch ended");
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

	
	if (!self.hidden)
	{
		NSLog(@"Drawing locations");
		for(LocationObject *loc in game.locations)
		{
			// Eventually color from location Type and state
			NSLog(@"Drawing location");
			[self drawLocation: loc withColor: [UIColor greenColor]];
		}
	}
}

-(void) drawLocation: (LocationObject *) loc withColor: (UIColor *)color
{
		// get the view point for the given map coordinate
		if (playMode == YES && [loc.visible boolValue] == NO)
			return;
	
	NSLog(@"Really drawing location");
		MKMapView *mapView = (MKMapView *) self.superview;
		CLLocationCoordinate2D coord;
		coord.latitude = [loc.latitude floatValue];
		coord.longitude = [loc.longitude floatValue];
		
		MKCoordinateRegion cr = MKCoordinateRegionMakeWithDistance(coord, [loc.size floatValue],[loc.size floatValue]);
		CGRect dRect = [mapView convertRegion:cr toRectToView:self];
		dRect.size.height = dRect.size.width;
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGColorRef cRef = CGColorCreateCopyWithAlpha(color.CGColor, 0.5);
		
		CGContextSetFillColorWithColor(context, cRef);
		//	CGContextSetRGBFillColor(context, 0, 127,0,0.5);
		CGContextFillEllipseInRect(context, dRect);
	CGColorRelease(cRef);
		if (loc == self.selectedLocation)
		{
			CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
			CGContextStrokeEllipseInRect(context, dRect);
		}	
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
	[self setNeedsDisplay]; // redraw the view
} // end method mapview:regionDidChangeAnimated:

@end
