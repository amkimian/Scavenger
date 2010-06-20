//
//  LocationObject+Extensions.m
//  POC-Location
//
//  Created by Alan Moore on 6/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationObject+Extensions.h"
#import "LocationPointObject.h"

@implementation LocationObject(Extensions)
-(int) countPoints
{
	int count = 0;
	LocationPointObject *point = self.firstPoint;
	while(point != nil)
	{
		count++;
		point = point.nextPoint;
	}
	return count;
}

// Called when we have a current graphics context

-(void) drawLocation: (MKMapView *) mapView andView:(UIView *) view
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	int nPoints = [self countPoints];
	if (nPoints == 1)
	{
		LocationPointObject *mainPoint = self.firstPoint;
		CLLocationCoordinate2D coord;
		coord.latitude = [mainPoint.latitude floatValue];
		coord.longitude = [mainPoint.longitude floatValue];
		
		MKCoordinateRegion cr = MKCoordinateRegionMakeWithDistance(coord, 50.0f, 50.0f);
		CGRect dRect = [mapView convertRegion:cr toRectToView:view];
		dRect.size.height = dRect.size.width;
		CGColorRef cRef = CGColorCreateCopyWithAlpha([UIColor blueColor].CGColor, 0.2);
		CGContextSetFillColorWithColor(context, cRef);
		CGContextFillEllipseInRect(context, dRect);				
	}
	else if (nPoints <= 3)
	{
		LocationPointObject *mainPoint = self.firstPoint;
		CLLocationCoordinate2D coord;
		coord.latitude = [mainPoint.latitude floatValue];
		coord.longitude = [mainPoint.longitude floatValue];
		CLLocationCoordinate2D coord2;
		coord2.latitude = [mainPoint.nextPoint.latitude floatValue];
		coord2.longitude = [mainPoint.nextPoint.longitude floatValue];
		
		// The radius is the distance between these two points
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
		CLLocation *otherLoc = [[CLLocation alloc] initWithLatitude:coord2.latitude longitude:coord2.longitude];

		float radius = 2 * [loc distanceFromLocation:otherLoc];
		
		MKCoordinateRegion cr = MKCoordinateRegionMakeWithDistance(coord, radius, radius);
		CGRect dRect = [mapView convertRegion:cr toRectToView:view];
		dRect.size.height = dRect.size.width;
		CGColorRef cRef = CGColorCreateCopyWithAlpha([UIColor blueColor].CGColor, 0.2);
		CGContextSetFillColorWithColor(context, cRef);
		CGContextFillEllipseInRect(context, dRect);		
		[loc release];
		[otherLoc release];
		
	}
	else
	{
		// Fill a polygon made up of curves from the points
		CGMutablePathRef path = [self getPathRef:mapView andView:view];
		CGColorRef cRef = CGColorCreateCopyWithAlpha([UIColor orangeColor].CGColor, 0.2);
		CGContextSetFillColorWithColor(context, cRef);
		CGContextAddPath(context, path);
		CGContextFillPath(context);
	}	
}

-(CGMutablePathRef) getPathRef: (MKMapView *) mapView andView: (UIView *) view
{
	CGMutablePathRef path = CGPathCreateMutable();
	LocationPointObject *point = self.firstPoint;
	CLLocationCoordinate2D coord;
	coord.latitude = [point.latitude floatValue];
	coord.longitude = [point.longitude floatValue];		
	CGPoint firstPoint = [mapView convertCoordinate:coord toPointToView:mapView];
	CGPoint controlPoint;
	CGPoint endPoint;
	
	CGPathMoveToPoint(path, nil, firstPoint.x, firstPoint.y);
	point = point.nextPoint;
	BOOL ready = NO;
	while(point)
	{
		coord.latitude = [point.latitude floatValue];
		coord.longitude = [point.longitude floatValue];		
		CGPoint thisPoint = [mapView convertCoordinate:coord toPointToView:mapView];
		if (ready == NO)
		{
			controlPoint = thisPoint;
			ready = YES;
		}
		else
		{
			endPoint = thisPoint;				
			CGPathAddQuadCurveToPoint(path, nil, controlPoint.x, controlPoint.y, endPoint.x, endPoint.y);
			controlPoint = endPoint;
			ready = NO;
		}
		point = point.nextPoint;			
	}
	// And now back to the start
	
	CGPathAddQuadCurveToPoint(path, nil, controlPoint.x, controlPoint.y, firstPoint.x, firstPoint.y);
	CGPathCloseSubpath(path);
	return path;
}

// Is this point in this location region?

-(BOOL) pointInLocation: (CGPoint) p inMap: (MKMapView *) mapView andView: (UIView *) view
{
	int nPoints = [self countPoints];
	if (nPoints == 1)
	{
		CLLocationCoordinate2D coord;
		coord.latitude = [self.firstPoint.latitude floatValue];
		coord.longitude = [self.firstPoint.longitude floatValue];
		MKCoordinateRegion r = MKCoordinateRegionMakeWithDistance(coord, 10.0f, 10.0f);
		
		CGRect rect = [mapView convertRegion:r toRectToView:view];
		if (CGRectContainsPoint(rect, p))
		{
			return YES;
		}		
	}
	else if (nPoints <= 3)
	{
		LocationPointObject *mainPoint = self.firstPoint;
		CLLocationCoordinate2D coord;
		coord.latitude = [mainPoint.latitude floatValue];
		coord.longitude = [mainPoint.longitude floatValue];
		CLLocationCoordinate2D coord2;
		coord2.latitude = [mainPoint.nextPoint.latitude floatValue];
		coord2.longitude = [mainPoint.nextPoint.longitude floatValue];
		
		// The radius is the distance between these two points
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
		CLLocation *otherLoc = [[CLLocation alloc] initWithLatitude:coord2.latitude longitude:coord2.longitude];
		
		float radius = 2 * [loc distanceFromLocation:otherLoc];
		
		MKCoordinateRegion cr = MKCoordinateRegionMakeWithDistance(coord, radius, radius);
		CGRect dRect = [mapView convertRegion:cr toRectToView:view];
		dRect.size.height = dRect.size.width;
		if (CGRectContainsPoint(dRect, p))
		{
			return YES;
		}
	}
	else
	{
		CGMutablePathRef pRef = [self getPathRef: mapView andView:view];
		if (CGPathContainsPoint(pRef, nil, p, true))
		{
			return YES;
		}
	}
	return NO;
}

@end
