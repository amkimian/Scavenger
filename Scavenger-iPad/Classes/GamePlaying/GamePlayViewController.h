//
//  GamePlayViewController.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/22/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameRunObject+Extensions.h"
#import "GamePlayOverlayView.h"
#import "ExpandableViewController.h"

@class GameManager;

@interface GamePlayViewController : UIViewController<CLLocationManagerDelegate> {
	GameRunObject *gameRun;
	GamePlayOverlayView *overlayView;
	GameManager *manager;
	IBOutlet ExpandableViewController *scoreController;
	IBOutlet MKMapView *mapView;
	CLLocationManager *locManager;
	CLLocation *currentLocation;
	CLLocationCoordinate2D destination;
	BOOL simulating;
	BOOL moving;
	float mapRadius;
}

-(void) simulateMoveTo: (CLLocationCoordinate2D) destination;
-(void) tick;
-(void) resetMapView;

@property(nonatomic, retain) GameRunObject *gameRun;
@property(nonatomic, readonly) GamePlayOverlayView *overlayView;
@property(nonatomic, retain)  GameManager *manager;
@property(nonatomic, retain) CLLocationManager *locManager;
@property(nonatomic, retain) CLLocation *currentLocation;
@property(nonatomic, retain) MKMapView *mapView;
@property(nonatomic) float mapRadius;
@end
