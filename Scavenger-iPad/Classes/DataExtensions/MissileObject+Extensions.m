//
//  MissileObject+Extensions.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/26/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "MissileObject+Extensions.h"
#import "LocationObject+Extensions.h"
#import "CGPointUtils.h"

@implementation MissileObject(Extensions)
#define MISSILE_SIZE 20
#define MISSILE_VELOCITY 0.00005
/*
 * Draw the missile in the game
 */

+(UIImage *) getMissileImageAtAngle: (float) angle
{
	UIGraphicsBeginImageContext(CGSizeMake(20.0, 20.0));
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGPoint leftFin[] =
	{
		CGPointMake(6.0,2.0),
		CGPointMake(6.0,6.0),
		CGPointMake(8.0,8.0),
		CGPointMake(8.0,4.0),
		CGPointMake(6.0,2.0)
	};
	
	CGPoint rightFin[] =
	{
		CGPointMake(14.0,2.0),
		CGPointMake(14.0,6.0),
		CGPointMake(12.0,8.0),
		CGPointMake(12.0,8.0),
		CGPointMake(14.0,2.0)
	};
	
	CGPoint mainBody[] =
	{
		CGPointMake(8.0,4.0),
		CGPointMake(8.0,14.0),
		CGPointMake(10.0,18.0),
		CGPointMake(12.0,14.0),
		CGPointMake(12.0,4.0),
		CGPointMake(8.0,4.0)
	};
	
	CGContextSetLineWidth(context, 1);
	CGContextAddLines(context, leftFin, sizeof(leftFin)/sizeof(leftFin[0]));
    CGContextStrokePath(context);
	CGContextAddLines(context, rightFin, sizeof(rightFin)/sizeof(rightFin[0]));
    CGContextStrokePath(context);
	CGContextAddLines(context, mainBody, sizeof(mainBody)/sizeof(mainBody[0]));
    CGContextStrokePath(context);
	
	UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIGraphicsBeginImageContext(CGSizeMake(20.0, 20.0));
	context = UIGraphicsGetCurrentContext();
	CGAffineTransform transform = CGAffineTransformIdentity;
	transform = CGAffineTransformTranslate(transform, MISSILE_SIZE/2, MISSILE_SIZE/2);
	transform = CGAffineTransformRotate(transform, angle);
	transform = CGAffineTransformScale(transform, 1.0, -1.0);
	
	CGContextConcatCTM(context, transform);
	
	// Draw the image into the context
	CGContextDrawImage(context, CGRectMake(-MISSILE_SIZE/2, -MISSILE_SIZE/2, MISSILE_SIZE, MISSILE_SIZE), theImage.CGImage);
	
	// Get an image from the context
	UIImage *ret = [UIImage imageWithCGImage: CGBitmapContextCreateImage(context)];
	UIGraphicsEndImageContext();
	return ret;
}

-(void) drawMissile:(MKMapView *)mapView andView:(UIView *) view
{
	//CGContextRef context = UIGraphicsGetCurrentContext();
	CLLocationCoordinate2D coord;
	coord.latitude = [self.currentLatitude floatValue];
	coord.longitude = [self.currentLongitude floatValue];
	MKCoordinateRegion cr = MKCoordinateRegionMakeWithDistance(coord, MISSILE_SIZE, MISSILE_SIZE);
	CGRect dRect = [mapView convertRegion:cr toRectToView:view];
	dRect.size.height = dRect.size.width;
	// What is the angle? - it is a measure of the direction between the start and end
	
	// Convert these to real coordinates
	CLLocationCoordinate2D startCoord;
	startCoord.latitude = [self.currentLatitude floatValue];
	startCoord.longitude = [self.currentLongitude floatValue];
	CLLocationCoordinate2D endCoord;
	endCoord.latitude = [self.targetLatitude floatValue];
	endCoord.longitude = [self.targetLongitude floatValue];
	
	CGPoint start;
	start = [mapView convertCoordinate:startCoord toPointToView:view];
	CGPoint end = [mapView convertCoordinate:endCoord toPointToView:view];
	float angle = angleBetweenPoints(start,end);
	UIImage *theImage = [MissileObject getMissileImageAtAngle: angle];
	[theImage drawInRect:dRect];
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
	
	if (fabs(xDistance) < fabs(xDelta))
	{
		xDelta = xDistance;
	}
	if (fabs(yDistance) < fabs(yDelta))
	{
		yDelta = yDistance;
	}
	
	self.currentLatitude = [NSNumber numberWithFloat: [self.currentLatitude floatValue] + xDelta];
	self.currentLongitude = [NSNumber numberWithFloat: [self.currentLongitude floatValue] + yDelta];
}


@end
