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
#import "ChooseListPopupController.h"
#import "MenuPopupController.h"
#import "EditLocationController.h"
#import "RouteListController.h"

@interface GameEditViewController : UIViewController<LocationOverlayViewDelegate,MapTypeChangedDelegate,ChooseListDidChooseDelegate,MenuPopupDelegate,EditLocationEndDelegate,
RouteListDoneDelegate, MKReverseGeocoderDelegate> {
	IBOutlet MKMapView *mapView;
	GameObject *game;
	LocationOverlayView *overlayView;
	UIPopoverController *popOver;
	CGRect savedRect;
	MKReverseGeocoder *geocoder;
}

@property(nonatomic, retain) GameObject *game;
@property(nonatomic, retain) LocationOverlayView *overlayView;
@property(nonatomic, retain) UIPopoverController *popOver;
@property(nonatomic, retain) MKReverseGeocoder *geocoder;

-(void) locationSelected: (LocationObject *) loc;
-(void) locationSelectedAgain: (LocationObject *) loc atPoint: (CGPoint) p;

-(void) insertNewLocation;
-(void) chooseMapType: (id) sender;
-(void) chooseDetails: (id) sender;
-(void) showRoute: (id) sender;

-(void) showIt;

-(void) didSelectItem: (NSUInteger) item from:(MenuPopupController *) sender;

-(void) editLocationDidFinishEditing:(EditLocationController *) controller;
-(void) alternateReverse: (CLLocationCoordinate2D) coordinate;

@end
