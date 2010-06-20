//
//  LocationOverlayView.m
//  POC-Location
//
//  Created by Alan Moore on 6/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationOverlayView.h"
#import "LocationObject+Extensions.h"
#import "LocationPointObject.h"

@implementation LocationOverlayView
@synthesize delegate;
@synthesize selectedLocation;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor]; // set the background
		self.hidden = NO;
		self.userInteractionEnabled = YES;
		self.tag = 1001;
		self.selectedLocation = nil;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	NSLog(@"Point inside");
	// Allow selection of locations
	
	LocationObject *o = [self findLocationAtPoint: point];
	if (o)
	{
		NSLog(@"Selected location");
		self.selectedLocation = o;
		[delegate locationSelected:self.selectedLocation atPoint:point];
		return YES;
	}
	return NO;
}

-(LocationObject *) findLocationAtPoint: (CGPoint) p
{
	NSArray *locations = [delegate getLocations].fetchedObjects;
	MKMapView *mapView = (MKMapView *) [self superview];
	for(LocationObject *o in locations)
	{
		CLLocationCoordinate2D coord;
		LocationPointObject *mainPoint = o.firstPoint;
		coord.latitude = [mainPoint.latitude floatValue];
		coord.longitude = [mainPoint.longitude floatValue];
		MKCoordinateRegion r = MKCoordinateRegionMakeWithDistance(coord, 50.0f, 50.0f);
		
		CGRect rect = [mapView convertRegion:r toRectToView:self];
		if (CGRectContainsPoint(rect, p))
		{
			return o;
		}
	}
	return nil;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Draw each location
	if (!self.hidden)
	{
		NSArray *locations = [delegate getLocations].fetchedObjects;
		for(LocationObject *loc in locations)
		{
			[self drawLocation: loc];
		}
	}
}

-(void) drawLocation: (LocationObject *) loc
{
	MKMapView *mapView = (MKMapView *) self.superview;
	
	// How we draw depends on the number of coordinates
	int numberOfPoints = [loc countPoints];
	if (numberOfPoints == 1)
	{
		// Draw a 50 meter circle;
		LocationPointObject *mainPoint = loc.firstPoint;
		CLLocationCoordinate2D coord;
		coord.latitude = [mainPoint.latitude floatValue];
		coord.longitude = [mainPoint.longitude floatValue];
		
		MKCoordinateRegion cr = MKCoordinateRegionMakeWithDistance(coord, 50.0f, 50.0f);
		CGRect dRect = [mapView convertRegion:cr toRectToView:self];
		dRect.size.height = dRect.size.width;
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGColorRef cRef = CGColorCreateCopyWithAlpha([UIColor greenColor].CGColor, 0.5);
		CGContextSetFillColorWithColor(context, cRef);
		CGContextFillEllipseInRect(context, dRect);
	}
	else if (numberOfPoints == 2)
	{
		// Draw a circle, centered on first point, radius to 2nd point
	}
	else
	{
		// Draw a polygon using the points
		
	}
}

- (void)dealloc {
    [super dealloc];
}

// called by the MKMapView when the region is going to change
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:
(BOOL)animated
{
	self.hidden = YES;
	[self setNeedsDisplay];
} // end method mapView:regionWillChangeAnimated:

// called by the MKMapView when the region has finished changing
- (void)mapView:(MKMapView *)mapView
regionDidChangeAnimated:(BOOL)animated
{
	self.hidden = NO;
	// Save the center point for what purpose?
	[self setNeedsDisplay];
} // end method mapview:regionDid



@end
