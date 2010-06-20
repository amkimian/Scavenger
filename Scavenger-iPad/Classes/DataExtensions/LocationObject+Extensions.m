//
//  LocationObject+Extensions.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "LocationObject+Extensions.h"
#import "LocationPointObject.h"

@implementation LocationObject(Extensions)
-(UIColor *) locationDisplayColor
{
	// Color is based on type
	LocationType lType = [self.locationType intValue];
	switch(lType)
	{
		case LTYPE_START:
			return [UIColor greenColor];
			break;
		case LTYPE_END:
			return [UIColor redColor];
			break;
		case LTYPE_CENTER:
			return [UIColor clearColor];
			break;
		case LTYPE_HAZARD_SHIELD:
		case LTYPE_HAZARD_LIFE:
		case LTYPE_HAZARD_RADAR:
		case LTYPE_HAZARD_FIND_HAZARD:
		case LTYPE_HAZARD_FIND_HAZARD_TYPE:
		case LTYPE_HAZARD_FIND_RALLY:
		case LTYPE_HAZARD_FIND_RALLY_TYPE:
		case LTYPE_HAZARD_SCORE:
		case LTYPE_HAZARD_LOC_PING:
		case LTYPE_HAZARD_FIX:
			return [UIColor orangeColor];
		case LTYPE_RALLY_CHARGE:
		case LTYPE_RALLY_SCORE:
		case LTYPE_RALLY_FIX:
		default:
			return [UIColor blueColor];
	}	
}

-(NSString *) locationTypeString
{
	// Color is based on type
	LocationType lType = [self.locationType intValue];
	switch(lType)
	{
		case LTYPE_START:
			return @"Start Location";
		case LTYPE_END:
			return @"Finish Location";
		case LTYPE_CENTER:
			return @"Display center";
		case LTYPE_HAZARD_SHIELD:
			return @"Hazard that attacks shield";
		case LTYPE_HAZARD_LIFE:
			return @"Hazard that attacks life";
		case LTYPE_HAZARD_RADAR:
			return @"Hazard that attacks radar";
		case LTYPE_HAZARD_FIND_HAZARD:
			return @"Degrades ability to find hazards";
		case LTYPE_HAZARD_FIND_HAZARD_TYPE:
			return @"Degrades ability to find out type of hazard";
		case LTYPE_HAZARD_FIND_RALLY:
			return @"Degrades ability to find a bonus";
		case LTYPE_HAZARD_FIND_RALLY_TYPE:
			return @"Degrades ability to find out type of bonus";
		case LTYPE_HAZARD_SCORE:
			return @"Reduces score";
		case LTYPE_HAZARD_LOC_PING:
			return @"Degrades ability to ping location";
		case LTYPE_HAZARD_FIX:
			return @"Degrades ability to fix things";
		case LTYPE_RALLY_CHARGE:
			return @"Recharges";
		case LTYPE_RALLY_SCORE:
			return @"Score";
		case LTYPE_RALLY_FIX:
			return @"Improves the ability to fix";
		default:
			return @"";
	}
}

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
