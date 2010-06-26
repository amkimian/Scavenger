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

/**
 * This will be changed to be a bit flag with macros to test
 *
 * Fields are
 *
 *    7 6 5 4 3 2 1 0
 *				A A A
 *          T T
 *    ? ? ?
 *
 * A = affects
 * T = type
 */

#define AFFECTS_NOTHING 0x000
#define AFFECTS_LIFE	0x001
#define AFFECTS_RADAR	0x010
#define AFFECTS_RALLY	0x011
#define AFFECTS_HAZARD	0x100
#define AFFECTS_FIX		0x101
#define AFFECTS_PING	0x110
#define AFFECTS_SCORE	0x111

#define LOCTYPE_HAZARD		0x100000
#define LOCTYPE_AREA		0x101000
#define LOCTYPE_TOWER		0x110000

#define LOCTYPE_NORMAL		0x000000
#define LOCTYPE_START		0x001000
#define LOCTYPE_END			0x010000
#define LOCTYPE_PLAYER		0x011000

#define IS_SINGLE(x)		((x & 0x100000) == 0) 
#define IS_HAZARD(x)		(LTYPE_HAZARD & x)
#define IS_NORMAL(x)		(!IS_HAZARD(x))
#define IS_TOWER(x)			(LTYPE_TOWER & x)
#define IS_AREA(x)			(LTYPE_AREA & x)

#define LTYPE_AFFECTS(x)	(x & 0x111)

// Now the actual location types

#define LTYPE_START					(LOCTYPE_START | AFFECTS_NOTHING)
#define LTYPE_END					(LOCTYPE_END | AFFECTS_NOTHING)
#define LTYPE_PLAYER				(LOCTYPE_PLAYER | AFFECTS_NOTHING)
#define LTYPE_HAZARD_RADAR			(LOCTYPE_AREA | AFFECTS_RADAR)
#define LTYPE_HAZARD_FIND_HAZARD	(LOCTYPE_AREA | AFFECTS_HAZARD)
#define LTYPE_HAZARD_FIND_RALLY		(LOCTYPE_AREA | AFFECTS_RALLY)
#define LTYPE_HAZARD_LOC_PING		(LOCTYPE_AREA | AFFECTS_PING)
#define LTYPE_HAZARD_FIX			(LOCTYPE_AREA | AFFECTS_FIX)

#define LTYPE_RALLY_SCORE			(LOCTYPE_NORMAL | AFFECTS_SCORE)

#define LTYPE_TOWER_SCORE			(LOCTYPE_TOWER | AFFECTS_SCORE)

#define LocationType int

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


