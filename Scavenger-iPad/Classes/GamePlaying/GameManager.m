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
#import "LocationPointObject.h"

@implementation GameManager
@synthesize gameRun;


/**
 * This is called whenever we reload a game
 *
 * It works out what state the game was in before and updates the state
 * so as to get it in a place to resume
 */

-(void) setupGameFromLoad
{
	// 1. Do we have a playerLocation? If we have we have been playing a game and we should resume that game
	
	LocationObject *playerLocation = [gameRun.game getLocationOfType:LTYPE_PLAYER];
	if ( playerLocation != nil)
	{
		NSLog(@"Setting up to resume from pause");
		CLLocationCoordinate2D coord;
		coord.latitude = [playerLocation.firstPoint.latitude floatValue];
		coord.longitude = [playerLocation.firstPoint.longitude floatValue];
		gameRun.seekingLocation = [gameRun.game addLocationOfType:LTYPE_RESUME at:coord];

		// And also remove the LTYPE_PLAYER
		
		[gameRun.game removeLocationObject: playerLocation];
		
		// and set state
		
		[gameRun updateGameState: SEEKING_RESUME];
	}
	else
	{		
		NSLog(@"Setting up to start new game");
		// OK, no player location. We need to start the game
		[self startNewGame];
	}
	
	// Now setup initial visibility
	for(LocationObject *loc in gameRun.game.locations)
	{
		if (loc == gameRun.seekingLocation)
		{
			loc.visible = [NSNumber numberWithBool:YES];
		}
		else
		{
			loc.visible = [NSNumber numberWithBool:NO];
		}		
	}
}

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
	
	gameRun.seekingLocation = [gameRun.game getLocationOfType:LTYPE_START];
	
	// Setup Route?
	
}
 
/**
 * Do one tick of the game
 */

-(void) gameTimer: (NSTimer *) timer
{
	
}

@end
