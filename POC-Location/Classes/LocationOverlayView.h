//
//  LocationOverlayView.h
//  POC-Location
//
//  Created by Alan Moore on 6/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationObject.h"

@protocol LocationOverlayViewDelegate;

@interface LocationOverlayView : UIView<MKMapViewDelegate> {
	id<LocationOverlayViewDelegate> delegate;
	LocationObject *selectedLocation;
	BOOL hidden;
}

@property(nonatomic, retain) id<LocationOverlayViewDelegate> delegate;
@property(nonatomic, retain) LocationObject *selectedLocation;

-(void) drawLocation: (LocationObject *) loc;
-(LocationObject *) findLocationAtPoint: (CGPoint) p;
@end

@protocol LocationOverlayViewDelegate
-(void) locationSelected: (LocationObject *) loc atPoint:(CGPoint) p;
-(NSFetchedResultsController *) getLocations;
@end
