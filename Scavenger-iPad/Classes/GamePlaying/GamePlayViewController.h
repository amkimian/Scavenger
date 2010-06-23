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

@interface GamePlayViewController : UIViewController {
	GameRunObject *gameRun;
	GamePlayOverlayView *overlayView;
	IBOutlet MKMapView *mapView;
}

@property(nonatomic, retain) GameRunObject *gameRun;
@property(nonatomic, readonly) GamePlayOverlayView *overlayView;
@end
