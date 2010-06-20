//
//  SingleLocationEditor.h
//  POC-Location
//
//  Created by Alan Moore on 6/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationObject+Extensions.h"
#import "SingleLocationView.h"


@interface SingleLocationEditor : UIViewController<SingleLocationViewDelegate> {
	IBOutlet MKMapView* mapView;

	SingleLocationView *overlayView;
	LocationObject *location;
	LocationPointObject *selectedPoint;
}

-(void) selectedLocationPoint: (LocationPointObject *) point;
-(void) clickedWithNoSelectionAtPoint: (CGPoint) point;

-(void) deleteMode:(id) sender;
-(void) addMode: (id) sender;
-(void) moveMode: (id) sender;

@property(nonatomic, retain) LocationObject *location;


@end
