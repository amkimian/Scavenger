//
//  LocationOverlayView.h
//  MDSTH
//
//  Created by Alan Moore on 6/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GameObject+Extensions.h"
#import "LocationObject+Extensions.h"

@protocol LocationOverlayViewDelegate;

@interface LocationOverlayView : UIView <MKMapViewDelegate> {
	id<LocationOverlayViewDelegate> delegate;
	GameObject *game;
	LocationObject *selectedLocation;
	CLLocationCoordinate2D snapBackCoord;
	BOOL hidden;
	BOOL playMode;
}

@property(nonatomic) BOOL playMode;
@property(nonatomic, retain) GameObject *game;
@property(nonatomic) BOOL hidden;
@property(nonatomic, retain) LocationObject *selectedLocation;
@property(nonatomic, retain) id<LocationOverlayViewDelegate> delegate;
-(NSMutableSet *) getLocations;
-(void) drawLocation: (LocationObject *) loc withColor: (UIColor *)color;
-(LocationObject *) findLocationAtPoint: (CGPoint) p;
@end

@protocol LocationOverlayViewDelegate 
-(void) locationSelected: (LocationObject *) loc;
@end
