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
/**
 * Playing a game
 */

@interface GameManager : NSObject {
	GameRunObject *gameRun;
	NSTimer *gameTimer;
}

-(void) startNewGame;
-(void) setupGameFromLoad;

-(void) gameTimer: (NSTimer *) timer;

@property(nonatomic, retain) GameRunObject *gameRun;

@end
