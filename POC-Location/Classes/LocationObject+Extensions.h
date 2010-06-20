//
//  LocationObject+Extensions.h
//  POC-Location
//
//  Created by Alan Moore on 6/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationObject.h"
#import <MapKit/MapKit.h>

@interface LocationObject(Extensions)
-(int) countPoints;
-(void) drawLocation: (MKMapView *) mapView andView:(UIView *) view;
-(CGMutablePathRef) getPathRef: (MKMapView *) mapView andView: (UIView *) view;
-(BOOL) pointInLocation: (CGPoint) p inMap: (MKMapView *) mapView andView: (UIView *) view;
@end
