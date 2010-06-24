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
#import "GameStatusHUDView.h"
#import "ScoreView.h"
/**
 * This overlay view draws the radar screen and appropriate locations
 * depending on the game state
 */

@interface GamePlayOverlayView : UIView {
	GameRunObject *gameRun;
	GameStatusHUDView *hudView;
	ScoreView *scoreView;
	BOOL hasDesiredLocation;
	BOOL isInPingMode;
	
	// In simulated mode
	CLLocationCoordinate2D desiredLocation;
}

-(void) drawRadarOverlay: (CGRect) rect;
-(void) refreshHud;

@property(nonatomic, retain) GameRunObject *gameRun;
@property(nonatomic, retain) GameStatusHUDView *hudView;
@property(nonatomic, retain) ScoreView *scoreView;
@property(nonatomic, readonly) CLLocationCoordinate2D desiredLocation;
@property(nonatomic, readonly) BOOL hasDesiredLocation;
@property(nonatomic) BOOL isInPingMode;
@end
