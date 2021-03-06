//
//  GameRunObject+Extensions.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/22/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameRunObject.h"
#import "HardwareObject.h"

typedef enum
{
	NOTSTARTED = 0,
	PAUSED = 1,
	SEEKING_RESUME,
	SEEKING_START,
	SEEKING_LOCATION,
	SEEKING_END,
	FINISHED
} GameStateEnum;

@interface GameRunObject(Extensions)
-(GameStateEnum) fromGameState;
-(void) updateGameState: (GameStateEnum) state;

-(BOOL) isRunning;
-(float) currentScore;
-(HardwareObject *) getHardwareWithName: (NSString *) name;
-(void) addHardwareWithName: (NSString *) name active: (BOOL) active andPowerUsage: (float) powerUsage andMaxLevel:(float) maxLevel andHudCode: (NSString *) hud;

-(LocationObject *) findNextRallyPoint;

-(BOOL) ensureLocationIsActive: (LocationObject *) loc;
-(BOOL) ensureLocationIsInactive: (LocationObject *) loc;

@end
