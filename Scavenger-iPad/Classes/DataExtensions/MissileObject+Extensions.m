//
//  MissileObject+Extensions.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/26/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "MissileObject+Extensions.h"
#import "LocationObject+Extensions.h"

@implementation MissileObject(Extensions)
#define MISSILE_SIZE 10
#define MISSILE_VELOCITY 0.00005
/*
 * Draw the missile in the game
 */
-(void) drawMissile:(MKMapView *)mapView andView:(UIView *) view
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CLLocationCoordinate2D coord;
	coord.latitude = [self.currentLatitude floatValue];
	coord.longitude = [self.currentLongitude floatValue];
	MKCoordinateRegion cr = MKCoordinateRegionMakeWithDistance(coord, MISSILE_SIZE, MISSILE_SIZE);
	CGRect dRect = [mapView convertRegion:cr toRectToView:view];
	dRect.size.height = dRect.size.width;
	CGColorRef cRef = CGColorCreateCopyWithAlpha([UIColor redColor].CGColor, 0.8);
	CGContextSetFillColorWithColor(context, cRef);
	CGContextFillEllipseInRect(context, dRect);					
}

-(BOOL) checkHit: (LocationObject *) other inMap:(MKMapView *) mapView andView: (UIView *) view
{
	CLLocationCoordinate2D coord;
	coord.latitude = [self.currentLatitude floatValue];
	coord.longitude = [self.currentLongitude floatValue];
	return [other coordinateInLocation:coord 
								 inMap:mapView 
							   andView:view];
}

-(BOOL) finished
{
	// Are we at the targetLat and long?
	return (([self.targetLatitude floatValue] == [self.currentLatitude floatValue]) && 
			([self.targetLongitude floatValue] == [self.currentLongitude floatValue]));
}

-(void) move
{
	// Travel towards the target with a predefined velocity
	
	// (x1, y1) -> (x2, y2)
	// (probably store this once as it doesn't change?)
	
	float xDistance = [self.targetLatitude floatValue] - [self.currentLatitude floatValue];
	float xDistanceSquared = xDistance * xDistance;
	float yDistance = [self.targetLongitude floatValue] - [self.currentLongitude floatValue];
	float yDistanceSquared = yDistance * yDistance;
	float vectorDistance = sqrt(xDistanceSquared + yDistanceSquared);
	// What's our velocity? Why not 0.0001 for now
	float xDelta = MISSILE_VELOCITY * xDistance / vectorDistance;
	float yDelta = MISSILE_VELOCITY * yDistance / vectorDistance;
	
	if (xDistance < xDelta)
	{
		xDelta = xDistance;
	}
	if (yDistance < yDelta)
	{
		yDelta = yDistance;
	}
	
	self.currentLatitude = [NSNumber numberWithFloat: [self.currentLatitude floatValue] + xDelta];
	self.currentLongitude = [NSNumber numberWithFloat: [self.currentLongitude floatValue] + yDelta];
}


@end
