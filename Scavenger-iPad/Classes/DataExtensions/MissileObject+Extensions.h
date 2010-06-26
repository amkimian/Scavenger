//
//  MissileObject+Extensions.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/26/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MissileObject.h"
#import "LocationObject.h"

@interface MissileObject(Extensions)
-(void) drawMissile:(MKMapView *)mapView andView:(UIView *) view;		
-(BOOL) checkHit: (LocationObject *) other inMap:(MKMapView *) mapView andView: (UIView *) view;
-(BOOL) finished;
-(void) move;

@end
