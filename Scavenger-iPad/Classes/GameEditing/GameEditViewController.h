//
//  GameEditViewController.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/17/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GameObject+Extensions.h"
#import "LocationOverlayView.h"

@interface GameEditViewController : UIViewController<LocationOverlayViewDelegate> {
	IBOutlet MKMapView *mapView;
	GameObject *game;
	LocationOverlayView *overlayView;
}

@property(nonatomic, retain) GameObject *game;
@property(nonatomic, retain) LocationOverlayView *overlayView;

-(void) locationSelected: (LocationObject *) loc;

@end
