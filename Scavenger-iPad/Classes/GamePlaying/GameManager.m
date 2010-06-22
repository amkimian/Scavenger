//
//  GameManager.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/22/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "GameManager.h"
#import "GameRunObject+Extensions.h"
#import "GameObject+Extensions.h"
#import "HardwareObject.h"

@implementation GameManager
@synthesize gameRun;

/**
 * Initialize a new game - not started yet (the player needs to move to the start location)
 */

-(void) startNewGame
{
	// Reset the gameRun object to correct initial values
	gameRun.paused = [NSNumber numberWithBool: NO];
	[gameRun updateGameState:NOTSTARTED];
	gameRun.life = [NSNumber numberWithInt: 10000];
	gameRun.power = [NSNumber numberWithInt: 10000];
	gameRun.playerName = @"Player";
	gameRun.shield = [NSNumber numberWithInt: 10000];
	gameRun.score = [NSNumber numberWithInt: 0];
	
	// Reset all of the hardware
	
	for(HardwareObject *h in gameRun.hardware)
	{
		h.damage = [NSNumber numberWithInt: 0];
		h.active = [NSNumber numberWithBool: YES];
	}
	
	
	// Setup Route?
	
}

/**
 * Resume the game after a pause (the player needs to move to the resume point)
 */

-(void) resumeGame
{
	// Update state
	[gameRun updateGameState: SEEKING_RESUME];
	gameRun.seekingLocation = [gameRun.game getLocationOfType:LTYPE_RESUME]; 
}

/**
 * Activate game - player is in position for the game to be "active"
 */

-(void) activateGame
{
	[gameRun updateGameState: SEEKING_LOCATION];
	// Setup first location from Route?	
}
 

/**
 * Do one tick of the game
 */

-(void) gameTimer: (NSTimer *) timer
{
	
}

@end
