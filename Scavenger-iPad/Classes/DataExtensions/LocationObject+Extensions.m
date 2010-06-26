//
//  LocationObject+Extensions.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "LocationObject+Extensions.h"
#import "LocationPointObject.h"

#define SINGLE_SIZE_PLAYER 10.0f
#define SINGLE_SIZE_TOWER 50.0f
#define SINGLE_SIZE_REST 25.0f
#define OVERLAY_ALPHA 0.5f

@implementation LocationObject(Extensions)

-(void) setupForGame
{
	LocationPointObject *p = self.firstPoint;
	while(p)
	{
		p.gameLatitude = p.latitude;
		p.gameLongitude = p.longitude;
		p = p.nextPoint;
	}
}

-(UIColor *) locationDisplayColor
{
	// Color is based on type
	LocationType lType = [self.locationType intValue];
	switch(lType)
	{
		case LTYPE_PLAYER:
			return [UIColor yellowColor];
			break;
		case LTYPE_START:
			return [UIColor greenColor];
			break;
		case LTYPE_END:
			return [UIColor redColor];
			break;
		case LTYPE_HAZARD_RADAR:
		case LTYPE_HAZARD_FIND_HAZARD:
		case LTYPE_HAZARD_FIND_RALLY:
		case LTYPE_HAZARD_LOC_PING:
		case LTYPE_HAZARD_FIX:
			return [UIColor orangeColor];
		case LTYPE_TOWER_SCORE:
			return [UIColor purpleColor];
		case LTYPE_RALLY_SCORE:
		default:
			return [UIColor blueColor];
	}	
}

-(BOOL) isHazard
{
	LocationType lType = [self.locationType intValue];
	return IS_HAZARD(lType) != 0;
}

-(NSString *) locationTypeString
{
	// Color is based on type
	LocationType lType = [self.locationType intValue];
	switch(lType)
	{
		case LTYPE_PLAYER:
			return @"Player position";
		case LTYPE_START:
			return @"Start Location";
		case LTYPE_END:
			return @"Finish Location";
		case LTYPE_HAZARD_RADAR:
			return @"Hazard that attacks radar";
		case LTYPE_HAZARD_FIND_HAZARD:
			return @"Degrades ability to find hazards";
		case LTYPE_HAZARD_FIND_RALLY:
			return @"Degrades ability to find a bonus";
		case LTYPE_HAZARD_LOC_PING:
			return @"Degrades ability to ping location";
		case LTYPE_HAZARD_FIX:
			return @"Degrades ability to fix things";
		case LTYPE_RALLY_SCORE:
			return @"Score";
		case LTYPE_TOWER_SCORE:
			return @"Tower Score";
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

-(void) performDrift
{
	if ([self.drift boolValue])
	{
		float driftRate = [self.driftSpeed floatValue] / 100000;
		LocationPointObject *p = self.firstPoint;
		while(p)
		{
			// Drift this point by anything from +- driftRate in lat and long
			float driftLat = -driftRate + driftRate * 2 * ((float)(random() % 1000)) / 1000;
			float driftLong = -driftRate + driftRate * 2 * ((float)(random() % 1000)) / 1000;
			float currentLat = [p.gameLatitude floatValue];
			currentLat += driftLat;
			p.gameLatitude = [NSNumber numberWithFloat: currentLat];
			float currentLong = [p.gameLongitude floatValue];
			currentLong += driftLong;
			p.gameLongitude = [NSNumber numberWithFloat: currentLong];
			p = p.nextPoint;
		}
	}	
}

-(NSString *) locationShortTypeString
{
	// Color is based on type
	LocationType lType = [self.locationType intValue];
	switch(lType)
	{
		case LTYPE_PLAYER:
			return @"Player";
		case LTYPE_START:
			return @"Start";
		case LTYPE_END:
			return @"Finish";
		case LTYPE_HAZARD_RADAR:
			return @"Radar";
		case LTYPE_HAZARD_FIND_HAZARD:
			return @"Find hazards";
		case LTYPE_HAZARD_FIND_RALLY:
			return @"Find Bonus";
		case LTYPE_HAZARD_LOC_PING:
			return @"Location Ping";
		case LTYPE_HAZARD_FIX:
			return @"Fix";
		case LTYPE_RALLY_SCORE:
			return @"Score";
		case LTYPE_TOWER_SCORE:
			return @"Tower score";
		default:
			return @"";
	}
}


-(void) drawDetails: (MKMapView *) mapView andView:(UIView *) view
{
	// Draw the text at the first location point
	CGContextRef context = UIGraphicsGetCurrentContext();
	LocationPointObject *mainPoint = self.firstPoint;
	CGPoint where;
	
	if ([self countPoints] <= 3)
	{
		CLLocationCoordinate2D coord;
		coord.latitude = [mainPoint.latitude floatValue];
		coord.longitude = [mainPoint.longitude floatValue];
		where = [mapView convertCoordinate:coord toPointToView:view];
	}
	else
	{
		CGPathRef path = [self getPathRef: mapView andView: view inGame:NO];
		CGRect bounds = CGPathGetBoundingBox(path);
		where.x = bounds.origin.x + bounds.size.width / 2;
		where.y = bounds.origin.y + bounds.size.height / 2;
	}
	
	CGColorRef cRef = CGColorCreateCopyWithAlpha([UIColor blueColor].CGColor, OVERLAY_ALPHA);
	CGContextSetFillColorWithColor(context, cRef);
	
	NSString *test = [NSString stringWithFormat: @"%@ - %.2f/%.2f", [self locationShortTypeString],[self.level floatValue], [self.maxLevel floatValue]];
	[test drawAtPoint:where withFont:[UIFont systemFontOfSize:12]];
	
}

-(void) drawLocationAsCircle: (MKMapView *) mapView andView:(UIView *) view andAlpha:(float) alpha inGame:(BOOL) inGame
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	LocationPointObject *mainPoint = self.firstPoint;
	CLLocationCoordinate2D coord;
	if (inGame)
	{
		coord.latitude = [mainPoint.gameLatitude floatValue];
		coord.longitude = [mainPoint.gameLongitude floatValue];
	}
	else
	{
		coord.latitude = [mainPoint.latitude floatValue];
		coord.longitude = [mainPoint.longitude floatValue];
	}
	float size = SINGLE_SIZE_REST;
	if (IS_TOWER([self.locationType intValue]))
	{
		size = SINGLE_SIZE_TOWER;
	}
	else if ([self.locationType intValue] == LTYPE_PLAYER)
	{
		size = SINGLE_SIZE_PLAYER;
	}
			
	MKCoordinateRegion cr = MKCoordinateRegionMakeWithDistance(coord, size, size);
	CGRect dRect = [mapView convertRegion:cr toRectToView:view];
	dRect.size.height = dRect.size.width;
	CGColorRef cRef = CGColorCreateCopyWithAlpha([self locationDisplayColor].CGColor, alpha);
	CGContextSetFillColorWithColor(context, cRef);
	CGContextFillEllipseInRect(context, dRect);				
}

-(void) drawLocationAsCircle2: (MKMapView *) mapView andView:(UIView *) view andAlpha:(float) alpha inGame:(BOOL) inGame
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	LocationPointObject *mainPoint = self.firstPoint;
	CLLocationCoordinate2D coord;
	if (inGame)
	{
		coord.latitude = [mainPoint.gameLatitude floatValue];
		coord.longitude = [mainPoint.gameLongitude floatValue];
	}
	else
	{
		coord.latitude = [mainPoint.latitude floatValue];
		coord.longitude = [mainPoint.longitude floatValue];
	}
	CLLocationCoordinate2D coord2;
	if (inGame)
	{
		coord2.latitude = [mainPoint.nextPoint.gameLatitude floatValue];
		coord2.longitude = [mainPoint.nextPoint.gameLongitude floatValue];
	}
	else
	{
		coord2.latitude = [mainPoint.nextPoint.latitude floatValue];
		coord2.longitude = [mainPoint.nextPoint.longitude floatValue];
	}
	
	// The radius is the distance between these two points
	CLLocation *loc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
	CLLocation *otherLoc = [[CLLocation alloc] initWithLatitude:coord2.latitude longitude:coord2.longitude];
	
	float radius = 2 * [loc distanceFromLocation:otherLoc];
	
	MKCoordinateRegion cr = MKCoordinateRegionMakeWithDistance(coord, radius, radius);
	CGRect dRect = [mapView convertRegion:cr toRectToView:view];
	dRect.size.height = dRect.size.width;
	CGColorRef cRef = CGColorCreateCopyWithAlpha([self locationDisplayColor].CGColor, alpha);
	CGContextSetFillColorWithColor(context, cRef);
	CGContextFillEllipseInRect(context, dRect);		
	[loc release];
	[otherLoc release];
	
}

-(void) drawLocationAsPath: (MKMapView *) mapView andView:(UIView *) view andAlpha:(float) alpha inGame:(BOOL) inGame
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGMutablePathRef path = [self getPathRef:mapView andView:view inGame:inGame];
	CGColorRef cRef = CGColorCreateCopyWithAlpha([self locationDisplayColor].CGColor, alpha);
	CGContextSetFillColorWithColor(context, cRef);
	CGContextAddPath(context, path);
	CGContextFillPath(context);
	
}

// Called when we have a current graphics context

-(void) drawLocation: (MKMapView *) mapView andView:(UIView *) view andAlpha:(float) alpha inGame:(BOOL) inGame
{
	if (!inGame)
	{
		[self drawDetails: mapView andView: view];
	}
	int nPoints = [self countPoints];
	if (IS_TOWER([self.locationType intValue]))
	{
		if ((!inGame) && nPoints > 3)
		{
			[self drawLocationAsPath: mapView andView:view andAlpha:alpha inGame:inGame];
		}
		[self drawLocationAsCircle: mapView andView:view andAlpha:alpha inGame:inGame];
	}
	else
	{			
		if (nPoints == 1)
		{
			[self drawLocationAsCircle: mapView andView:view andAlpha:alpha inGame:inGame];
		}
		else if (nPoints <= 3)
		{
			[self drawLocationAsCircle2: mapView andView:view andAlpha:alpha inGame:inGame];		
		}
		else
		{
			[self drawLocationAsPath: mapView andView:view andAlpha:alpha inGame:inGame];
		}
	}
}

-(CGMutablePathRef) getPathRef: (MKMapView *) mapView andView: (UIView *) view inGame: (BOOL) inGame
{
	CGMutablePathRef path = CGPathCreateMutable();
	LocationPointObject *point = self.firstPoint;
	CLLocationCoordinate2D coord;
	if (inGame)
	{
		coord.latitude = [point.gameLatitude floatValue];
		coord.longitude = [point.gameLongitude floatValue];		
	}
	else
	{
		coord.latitude = [point.latitude floatValue];
		coord.longitude = [point.longitude floatValue];		
	}
	CGPoint firstPoint = [mapView convertCoordinate:coord toPointToView:mapView];
	CGPoint controlPoint;
	CGPoint endPoint;
	
	CGPathMoveToPoint(path, nil, firstPoint.x, firstPoint.y);
	point = point.nextPoint;
	BOOL ready = NO;
	while(point)
	{
		if (inGame)
		{
			coord.latitude = [point.gameLatitude floatValue];
			coord.longitude = [point.gameLongitude floatValue];		
		}
		else
		{
			coord.latitude = [point.latitude floatValue];
			coord.longitude = [point.longitude floatValue];		
		}
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

-(BOOL) coordinateInLocation: (CLLocationCoordinate2D) coord inMap: (MKMapView *) mapView andView: (UIView *) view
{
	CGPoint p = [mapView convertCoordinate:coord toPointToView:view];
	return [self pointInLocation: p inMap: mapView andView:view inGame:NO];
}

// Is this point in this location region?

-(BOOL) pointInLocation: (CGPoint) p inMap: (MKMapView *) mapView andView: (UIView *) view inGame:(BOOL) inGame
{
	int nPoints = [self countPoints];
	if (nPoints == 1)
	{
		CLLocationCoordinate2D coord;
		if (inGame)
		{
			coord.latitude = [self.firstPoint.gameLatitude floatValue];
			coord.longitude = [self.firstPoint.gameLongitude floatValue];
		}
		else
		{
			coord.latitude = [self.firstPoint.latitude floatValue];
			coord.longitude = [self.firstPoint.longitude floatValue];
		}
		
		float size = SINGLE_SIZE_REST;
		if (IS_TOWER([self.locationType intValue]))
		{
			size = SINGLE_SIZE_TOWER;
		}
		else if ([self.locationType intValue] == LTYPE_PLAYER)
		{
			size = SINGLE_SIZE_PLAYER;
		}
		MKCoordinateRegion r = MKCoordinateRegionMakeWithDistance(coord, size, size);
		
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
		CLLocationCoordinate2D coord2;
		if (inGame)
		{
			coord.latitude = [mainPoint.gameLatitude floatValue];
			coord.longitude = [mainPoint.gameLongitude floatValue];
			coord2.latitude = [mainPoint.nextPoint.gameLatitude floatValue];
			coord2.longitude = [mainPoint.nextPoint.gameLongitude floatValue];
		}
		else
		{
			coord.latitude = [mainPoint.latitude floatValue];
			coord.longitude = [mainPoint.longitude floatValue];
			coord2.latitude = [mainPoint.nextPoint.latitude floatValue];
			coord2.longitude = [mainPoint.nextPoint.longitude floatValue];
		}
		
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
		CGMutablePathRef pRef = [self getPathRef: mapView andView:view inGame:inGame];
		if (CGPathContainsPoint(pRef, nil, p, true))
		{
			return YES;
		}
	}
	return NO;
}

-(void) moveWithRelativeFrom: (CLLocationCoordinate2D) movingCoord to:(CLLocationCoordinate2D) coord
{
	LocationPointObject *point = self.firstPoint;
	float latDelta = coord.latitude - movingCoord.latitude;
	float longDelta = coord.longitude - movingCoord.longitude;
	while(point)
	{
		point.latitude = [NSNumber numberWithFloat: [point.latitude floatValue] + latDelta];
		point.longitude = [NSNumber numberWithFloat: [point.longitude floatValue] + longDelta];
		point = point.nextPoint;
	}
}

@end
