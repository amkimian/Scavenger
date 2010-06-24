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
#import "ActiveLocationObject.h"

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
	gameRun.playerName = @"Player";
	
	// Reset all of the hardware
	
	for(HardwareObject *h in gameRun.hardware)
	{
		h.level = h.maxLevel;
		//h.active = [NSNumber numberWithBool: YES];
	}
	
	for(LocationObject *l in gameRun.game.locations)
	{
		l.visitedInGame = nil;
	}
	
	gameRun.visitedLocation = nil;
	gameRun.seekingLocation = [gameRun.game getLocationOfType:LTYPE_START];
	
	// Setup Route?
	
}
 
-(void) processAtSoughtLocation
{
	// We are at the location we are currently seeking.
	// Do what is necessary for the next steps
	
	if ([gameRun.state intValue] == SEEKING_START)
	{
		// Turn on all hazards
		for(LocationObject *l in gameRun.game.locations)
		{
			if ([l isHazard])
			{
				l.visible = [NSNumber numberWithBool: YES];
			}
		}		
	}
	else if ([gameRun.state intValue] == SEEKING_LOCATION)
	{
		// Add on points total
		float value = [gameRun.score floatValue];
		float changeValue = [gameRun.seekingLocation.level floatValue];
		value+=changeValue;
		gameRun.score = [NSNumber numberWithFloat: value];		
	}
	else
	{
		// Must be end?
		[gameRun updateGameState:FINISHED];
		[self.gamePlayController showGameOver];
		// Present nice points dialog
	}
	
	gameRun.seekingLocation.visible = [NSNumber numberWithBool: NO];
	[gameRun addVisitedLocationObject: gameRun.seekingLocation];
	// This call uses visitedLocation to ensure no dupes
	if ([gameRun fromGameState] != FINISHED)
	{
		gameRun.seekingLocation = [gameRun findNextRallyPoint];
		if (gameRun.seekingLocation == nil)
		{
			[gameRun updateGameState:SEEKING_END];
			gameRun.seekingLocation = [gameRun.game getLocationOfType:LTYPE_END];
		}
		else 
		{
			[gameRun updateGameState:SEEKING_LOCATION];
		}	
	}
	// Make the seekingLocation visible
	gameRun.seekingLocation.visible = [NSNumber numberWithBool: YES];
	// Refresh overlayView
	[self.gamePlayController.overlayView setNeedsDisplay];
}

/**
 * Do one tick of the game
 */

-(void) gameTimer: (NSTimer *) timer
{
	// This is a game tick, what do we do here?
	NSLog(@"Game tick");
	// Depends on game state
	switch([gameRun.state intValue])
	{
		case NOTSTARTED:
		case PAUSED:
			break;
		case FINISHED:			
			NSLog(@"PRESENT FINISH DIALOG");
			[gameTimer invalidate];
			gameTimer = nil;
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
				[self processAtSoughtLocation];
			}
			break;
	}
	
	// Check for entry or exit from hazards
	
	for(LocationObject *l in gameRun.game.locations)
	{
		if ([l.visible boolValue])
		{
			if ([l isHazard])
			{
				if ([l coordinateInLocation:self.gamePlayController.currentLocation.coordinate
					inMap:self.gamePlayController.mapView
					andView:self.gamePlayController.overlayView])
				{
					[gameRun ensureLocationIsActive: l];
				}
				else
				{
					[gameRun ensureLocationIsInactive: l];
				}
			}			
		}		
	}
		
	// Handle power drainage and hazard actions
	
	// Power drainage
	// For all active Hardware, take off their power drain value from the power Hardware type
	
	[self powerDrain];
	
	// Hazard actions
	// For all hazards in ActiveLocations
	// apply the drain to the target depending on the hazard type (affects shield first, then
	// if shield is out of action, affects actual target by increasing damage
	// If damage is 100, it's broke.
	
	[self hazardAction];
	
	// Handle shield recharge
	
	HardwareObject *shield = [gameRun getHardwareWithName:@"Shield"];
	[shield updateLevelBy: 1.0f];
	
	[gamePlayController.overlayView refreshHud];
	
	// Then handle the FIX hardware type, if it is active, transfer power from power to damaged items
		
	HardwareObject *fixer = [gameRun getHardwareWithName:@"Fix"];
	if ([fixer.active boolValue] && [fixer.hasPower boolValue])
	{
		for(HardwareObject *ho in gameRun.hardware)
		{
			[ho updateLevelBy:1.0f];
		}		
	}
	
	// Check for PING mode
	
	HardwareObject *ping = [gameRun getHardwareWithName:@"Ping"];
	if ([ping.active boolValue] && [ping.hasPower boolValue])
	{
		NSLog(@"Is in ping mode");
		if (!self.gamePlayController.overlayView.isInPingMode)
		{
			// Change views to pingMode
			self.gamePlayController.overlayView.isInPingMode = YES;
		}		
		// Work out the radius for the view
		float radius;
		float latDelta = [gameRun.seekingLocation.firstPoint.latitude floatValue] - self.gamePlayController.currentLocation.coordinate.latitude;
		float longDelta = [gameRun.seekingLocation.firstPoint.longitude floatValue] - self.gamePlayController.currentLocation.coordinate.longitude;
		radius = sqrt((latDelta * latDelta) + (longDelta *longDelta));
		self.gamePlayController.mapRadius = radius*2;
		[self.gamePlayController resetMapView];
	}
	else
	{
		if (self.gamePlayController.overlayView.isInPingMode)
		{
			NSLog(@"No longer in ping mode");
			// Change views from pingMode
			// This one is easy - move the mapView back to normal
			self.gamePlayController.mapRadius = 0.005f;
			self.gamePlayController.overlayView.isInPingMode = NO;
			[self.gamePlayController resetMapView];
		}
	}
	
	// Make sure the gameScore is correct
	float scoreValue = [gameRun.score floatValue];
	if (gamePlayController.overlayView.scoreView.scoreValue != scoreValue)
	{
		gamePlayController.overlayView.scoreView.scoreValue = scoreValue;

	}
	
	// Update endGameBonus and update
		scoreValue = [gameRun.bonus floatValue];
		if ([gameRun isRunning])
		{
			float deltaValue = 10;
			scoreValue -= deltaValue;
			if (scoreValue < 0)
			{
				scoreValue = 0.0;
			}
			gameRun.bonus = [NSNumber numberWithFloat: scoreValue];
		}
	gamePlayController.overlayView.scoreView.bonusValue = scoreValue;
	[gamePlayController.overlayView.scoreView setNeedsDisplay];	
	
	// Check for simulation
	
	if (gamePlayController.overlayView.hasDesiredLocation)
	{
		[gamePlayController simulateMoveTo: gamePlayController.overlayView.desiredLocation];		
	}
	
	[gamePlayController tick];
}

-(void) hazardAction
{
	for(ActiveLocationObject *alo in gameRun.activeLocations)
	{
		if ([alo.active boolValue])
		{
			float changeValue = [alo.amountRate floatValue];
			HardwareObject *shieldHardware = [gameRun getHardwareWithName:@"Shield"];
			if ([shieldHardware.level floatValue] > 0.1)
			{
				NSLog(@"Shield damage");
				float currentLevel = [shieldHardware.level floatValue];
				float newLevel = currentLevel - changeValue;
				if (newLevel < 0.1)
				{
					newLevel = 0.0;
					changeValue -= currentLevel;
				}
				else
				{
					changeValue = 0.0;
				}
				shieldHardware.level = [NSNumber numberWithFloat: newLevel];
			}
			if (changeValue > 0.0)
			{
				// Still more to go
				HardwareObject *whichHardware = nil;
				switch([alo.targetModifies intValue])
				{
					case LTYPE_HAZARD_FIND_HAZARD:
						whichHardware = [gameRun getHardwareWithName:@"Hazard"];
						break;
					case LTYPE_HAZARD_RADAR:
						whichHardware = [gameRun getHardwareWithName:@"Radar"];
						break;
					case LTYPE_HAZARD_LOC_PING:
						whichHardware = [gameRun getHardwareWithName:@"Ping"];
						break;
					case LTYPE_HAZARD_FIND_RALLY:
						whichHardware = [gameRun getHardwareWithName:@"Bonus"];
						break;
				}
				if (whichHardware)
				{
					float currentLevel = [whichHardware.level floatValue];
					currentLevel -= changeValue;
					if (currentLevel < 0)
					{
						currentLevel = 0;
					}
					whichHardware.level = [NSNumber numberWithFloat: currentLevel];					
				}
			}
		}		
	}
}


-(void) powerDrain
{
	HardwareObject *power = [gameRun getHardwareWithName:@"Power"];
	BOOL powerExhausted = NO;
	for(HardwareObject *ho in gameRun.hardware)
	{
		if ([ho.active boolValue] && [ho.hasPower boolValue])
		{
			double existingPower = [power.level floatValue];
			double newPower = existingPower - [ho.powerUse floatValue];
			if (newPower < 0.0)
			{
				newPower = 0.0;
				powerExhausted = YES;
			}
			NSLog(@"Power change %f -> %f", existingPower, newPower);
			power.level = [NSNumber numberWithFloat: newPower];
		}
	}							   
	if (powerExhausted)
	{
		// Do something
		
	}
}

@end
