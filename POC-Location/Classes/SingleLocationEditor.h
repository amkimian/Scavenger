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

@interface SingleLocationEditor : UIViewController {
	IBOutlet MKMapView* mapView;
	SingleLocationView *overlayView;
	LocationObject *location;
}

@property(nonatomic, retain) LocationObject *location;
@end
