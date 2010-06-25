//
//  LocationObject+Extensions.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "LocationObject.h"

typedef enum
{
	LTYPE_START = 0,
	LTYPE_PLAYER,
	LTYPE_END,
	LTYPE_END_SINGLE_INSTANCE,
	LTYPE_HAZARD_RADAR,
	LTYPE_HAZARD_FIND_HAZARD,
	LTYPE_HAZARD_FIND_RALLY,
	LTYPE_HAZARD_LOC_PING,
	LTYPE_HAZARD_FIX,
	LTYPE_RALLY_CHARGE,
	LTYPE_RALLY_SCORE,
	LTYPE_RALLY_FIX
} LocationType;

@interface LocationObject(Extensions)
-(UIColor *) locationDisplayColor;
-(NSString *) locationTypeString;
-(NSString *) locationShortTypeString;
-(BOOL) isHazard;

-(void) setupForGame;
-(void) performDrift;
-(int) countPoints;
-(void) drawLocation: (MKMapView *) mapView andView:(UIView *) view andAlpha:(float) alpha inGame:(BOOL) inGame;
-(CGMutablePathRef) getPathRef: (MKMapView *) mapView andView: (UIView *) view inGame:(BOOL) inGame;
-(BOOL) pointInLocation: (CGPoint) p inMap: (MKMapView *) mapView andView: (UIView *) view inGame:(BOOL) inGame;
-(BOOL) coordinateInLocation: (CLLocationCoordinate2D) coord inMap: (MKMapView *) mapView andView: (UIView *) view;
-(void) moveWithRelativeFrom: (CLLocationCoordinate2D) movingCoord to:(CLLocationCoordinate2D) coord;

-(void) drawDetails: (MKMapView *) mapView andView:(UIView *) view;

@end


