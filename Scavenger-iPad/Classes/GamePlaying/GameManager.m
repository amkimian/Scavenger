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
#import "LocationObject+Extensions.h"
#import "HardwareObject.h"
#import "LocationPointObject.h"

@implementation GameManager
@synthesize gameRun;
@synthesize gamePlayController;

-(void) pause
{
	[gameTimer invalidate];
	gameTimer = nil;
}

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
	
	gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(gameTimer:) userInfo:nil repeats:YES];
}

/**
 * Initialize a new game - not started yet (the player needs to move to the start location)
 */

-(void) startNewGame
{
	// Reset the gameRun object to correct initial values
	gameRun.paused = [NSNumber numberWithBool: NO];
	[gameRun updateGameState:SEEKING_START];
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
	// This is a game tick, what do we do here?
	NSLog(@"Game tick");
	int state = [gameRun.state intValue];
	// Depends on game state
	switch([gameRun.state intValue])
	{
		case NOTSTARTED:
		case PAUSED:
		case FINISHED:			
			// Do nothing
			break;
		case SEEKING_LOCATION:
		case SEEKING_END:
			// Update game state with any active power, hazards, etc.
			
			// And follow through
		case SEEKING_RESUME:
		case SEEKING_START:
			// Are we at the seeking location yet?
			// If we are, do the next state
			if ([gameRun.seekingLocation 
				 coordinateInLocation:self.gamePlayController.currentLocation.coordinate 
				 inMap:self.gamePlayController.mapView 
				 andView:self.gamePlayController.overlayView])
			{
				NSLog(@"At seeking location");
				// Call method to handle this behaviour - usually involves state changes
				// or the determination of the next location, and hiding existing locations				
			}
			break;
	}
	
	// Check for entry or exit from hazards
	
	// Handle power drainage and hazard actions
	
	// Check for simulation
	
	if (gamePlayController.overlayView.hasDesiredLocation)
	{
		[gamePlayController simulateMoveTo: gamePlayController.overlayView.desiredLocation];		
	}
	
	[gamePlayController tick];
}


@end
