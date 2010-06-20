//
//  SingleLocationView.m
//  POC-Location
//
//  Created by Alan Moore on 6/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SingleLocationView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CLLocation.h>
#import "LocationPointObject.h"

@implementation SingleLocationView
@synthesize location;
@synthesize delegate;
@synthesize selectedLocationPoint;
@synthesize mode;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor]; // set the background
		self.hidden = NO;
		self.userInteractionEnabled = YES;
		self.tag = 1001;
		self.mode = MODE_MOVE;
    }
    return self;
}

-(LocationPointObject *) findLocationAtPoint: (CGPoint) p
{
	LocationPointObject *o = location.firstPoint;
	MKMapView *mapView = (MKMapView *) [self superview];
	while(o)
	{
		CLLocationCoordinate2D coord;
		coord.latitude = [o.latitude floatValue];
		coord.longitude = [o.longitude floatValue];
		MKCoordinateRegion r = MKCoordinateRegionMakeWithDistance(coord, 20.0f, 20.0f);
		
		CGRect rect = [mapView convertRegion:r toRectToView:self];
		if (CGRectContainsPoint(rect, p))
		{
			return o;
		}
		o = o.nextPoint;
	}
	return nil;
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	// If we have a current location move it
	// If not, pass through the touch
	NSLog(@"Touch moved");	
	if (mode == MODE_MOVE)
	{
		UITouch *touch = [touches anyObject];
		CGPoint p = [touch locationInView: self];
		MKMapView *mapView = (MKMapView *) [self superview];
		// Convert to lat and long
		CLLocationCoordinate2D coord = [mapView convertPoint:p toCoordinateFromView: self];
		if (self.selectedLocationPoint)
		{
			self.selectedLocationPoint.latitude = [NSNumber numberWithFloat: coord.latitude];
			self.selectedLocationPoint.longitude = [NSNumber numberWithFloat: coord.longitude];
			[self setNeedsDisplay];
		}
	}
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"Touch ended");
	self.selectedLocationPoint = nil;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	NSLog(@"Point inside");

	// If the click is in an activeLocation, select that
	// Otherwise potentially *add* an active location at that point
	
	LocationPointObject *p = [self findLocationAtPoint: point];
	if (p)
	{
		NSLog(@"Selected location point");
		if (mode == MODE_MOVE)
		{
			self.selectedLocationPoint = p;
			[delegate selectedLocationPoint:p];
			return YES;	
		} else if (mode == MODE_DELETE)
		{
			LocationPointObject *previous = p.previousPoint;
			LocationPointObject *next = p.nextPoint;
			
			if (next != nil)
			{
				if (previous == nil)
				{
					location.firstPoint = next;
				}
				else
				{
					previous.nextPoint = next;
				}
			}
			else
			{
				if (previous)
				{
					previous.nextPoint = nil;
				}
			}
			
			// And delete this one
			[[location managedObjectContext] deleteObject:p];
			[self setNeedsDisplay];
			return YES;
		}
	}
	else
	{
		//self.selectedLocationPoint = nil;
		if (mode == MODE_ADD)
		{
			// Add a new one
			NSEntityDescription *edesc = [NSEntityDescription entityForName:@"LocationPoint" inManagedObjectContext:[location managedObjectContext]];
			LocationPointObject *lPoint = [[LocationPointObject alloc] initWithEntity:edesc insertIntoManagedObjectContext:[location managedObjectContext]];
			// Add to end
			LocationPointObject *tail = location.firstPoint;
			while(tail.nextPoint)
			{
				tail = tail.nextPoint;
			}
			tail.nextPoint = lPoint;
			// Convert point to latitude and longitude
		
			MKMapView *mapView = (MKMapView *) self.superview;
		
			CLLocationCoordinate2D coord = [mapView convertPoint:point toCoordinateFromView:self];
			lPoint.latitude = [NSNumber numberWithFloat: coord.latitude];
			lPoint.longitude = [NSNumber numberWithFloat: coord.longitude];
		
			[self setNeedsDisplay];
			return YES;
		}
	}
	
	return NO;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	// We draw a point for each LocationPointObject, with lines between them
	// We also draw (in a low alpha) how the location would appear on the map...
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	MKMapView *mapView = (MKMapView *) self.superview;
	BOOL done = NO;
	LocationPointObject *point = location.firstPoint;
	CGPoint previousPoint;
	CGPoint firstPoint;
	BOOL isFirst = YES;
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
	CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 1.0);
	while(!done)
	{
		// Find out the local coords for this point
		CLLocationCoordinate2D coord;
		coord.latitude = [point.latitude floatValue];
		coord.longitude = [point.longitude floatValue];
		
		CGPoint centerPoint = [mapView convertCoordinate:coord toPointToView:mapView];

		// Now draw circle for the actual point, and line from the previous point
		
		CGRect rect;
		rect.origin.x = centerPoint.x - 10.0;
		rect.origin.y = centerPoint.y - 10.0;
		rect.size.width = 20.0;
		rect.size.height = 20.0;
		CGContextFillEllipseInRect(context, rect);
		
		if (!isFirst)
		{
			// Draw a line from the last point to this point
			NSLog(@"Draw line");
			CGContextMoveToPoint(context, previousPoint.x, previousPoint.y);
			CGContextAddLineToPoint(context, centerPoint.x, centerPoint.y);
			CGContextStrokePath(context);
		}
		else
		{
			isFirst = NO;
			firstPoint = centerPoint;
		}
		previousPoint = centerPoint;
		point = point.nextPoint;
		if (point == nil)
		{
			done = YES;
		}
	}
	CGContextMoveToPoint(context, previousPoint.x, previousPoint.y);
	CGContextAddLineToPoint(context, firstPoint.x, firstPoint.y);
	CGContextStrokePath(context);
	
	// Now draw the location
	[location drawLocation:mapView andView:self];
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
