//
//  GameObject_Extensions.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "GameObject.h"
#import "LocationObject+Extensions.h"

@interface GameObject(Extensions) <MKAnnotation>
-(LocationObject *) addLocationOfType: (LocationType) type;
-(LocationObject *) getLocationOfType: (LocationType) type;

-(void) removeLocationObject: (LocationObject *) loc;
-(void) addLocationToDefaultRoute: (LocationObject *) loc;
@end

