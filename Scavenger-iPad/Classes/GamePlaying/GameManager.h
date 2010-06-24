//
//  GameManager.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/22/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameRunObject.h"
#import "LocationObject+Extensions.h"
#import "GamePlayViewController.h"
/**
 * Playing a game
 */

@interface GameManager : NSObject {
	GameRunObject *gameRun;
	NSTimer *gameTimer;
	GamePlayViewController *gamePlayController;
}

-(void) startNewGame;
-(void) setupGameFromLoad;
-(void) pause;

-(void) gameTimer: (NSTimer *) timer;

-(void) processAtSoughtLocation;
-(void) powerDrain;
-(void) hazardAction;

@property(nonatomic, retain) GameRunObject *gameRun;
@property(nonatomic, retain) GamePlayViewController *gamePlayController;

@end
