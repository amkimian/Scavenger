//
//  GamePlayOverlayView.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/22/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GameRunObject+Extensions.h"

/**
 * This overlay view draws the radar screen and appropriate locations
 * depending on the game state
 */

@interface GamePlayOverlayView : UIView {
	GameRunObject *gameRun;
	// Associated map view for this overlay
	IBOutlet MKMapView *mapView;
}

-(void) drawRadarOverlay: (CGRect) rect;

@property(nonatomic, retain) GameRunObject *gameRun;
@end
