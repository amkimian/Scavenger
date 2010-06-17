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
#import "MapTypePopupController.h"

@interface GameEditViewController : UIViewController<LocationOverlayViewDelegate,MapTypeChangedDelegate> {
	IBOutlet MKMapView *mapView;
	GameObject *game;
	LocationOverlayView *overlayView;
	UIPopoverController *popOver;
}

@property(nonatomic, retain) GameObject *game;
@property(nonatomic, retain) LocationOverlayView *overlayView;
@property(nonatomic, retain) UIPopoverController *popOver;

-(void) locationSelected: (LocationObject *) loc;
-(void) insertNewLocation;
-(void) chooseMapType: (id) sender;
-(void) chooseDetails: (id) sender;
-(void) showRoute: (id) sender;
@end
