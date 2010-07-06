//
//  GameRunObject+Extensions.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/22/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "GameRunObject+Extensions.h"
#import "LocationObject+Extensions.h"
#import "GameObject+Extensions.h"
#import "ActiveLocationObject.h"
#import "LocationOrderObject.h"
#import "GameRouteObject.h"

@implementation GameRunObject(Extensions)
-(GameStateEnum) fromGameState
{
	return (GameStateEnum) [self.state intValue];
}

-(void) updateGameState: (GameStateEnum) state
{
	self.state = [NSNumber numberWithInt: (int) state];
}

-(HardwareObject *) getHardwareWithName: (NSString *) name
{
	for(HardwareObject *h in self.hardware)
	{
		if ([h.name isEqualToString:name])
		{
			return h;
		}
	}
	
	return nil;	
}

-(BOOL) isRunning
{
	switch([self.state intValue])
	{
		case NOTSTARTED:
		case PAUSED:
		case SEEKING_RESUME:
		case SEEKING_START:
		case FINISHED:
			return NO;
	}
	return YES;
}

-(void) addHardwareWithName: (NSString *) name active: (BOOL) a andPowerUsage: (float) powerUsage andMaxLevel:(float) maxLevel andHudCode: (NSString *) hud;

{
	// Create hardware and add it to this gameRun object
	NSEntityDescription *edesc = [NSEntityDescription entityForName:@"Hardware" inManagedObjectContext:[self managedObjectContext]];
	HardwareObject *hardware = [[HardwareObject alloc] initWithEntity:edesc insertIntoManagedObjectContext:[self managedObjectContext]];
	hardware.name = name;
	hardware.active = [NSNumber numberWithBool: a];
	hardware.maxLevel = [NSNumber numberWithFloat: maxLevel];
	hardware.level = hardware.maxLevel;
	hardware.hasPower = [NSNumber numberWithBool: YES];
	hardware.hudCode = hud;
	hardware.powerUse = [NSNumber numberWithFloat:powerUsage];
	[self addHardwareObject:hardware];	
}

-(float) currentScore
{
	float score = [self.score floatValue];
	score += [self.bonus floatValue];
	
	for(HardwareObject *ho in self.hardware)
	{
		score += [ho.powerUse floatValue];
	}
	return score;
	
}

-(LocationObject *) findNextRallyPoint
{
	// If we have a routeObject, use that by traversing down the route for the first non-visited object
	// otherwise just loop through the locations looking for locations of type LTYPE_RALLY_* that are not visited
	// and return the first one found
	
	if (self.gameRoute)
	{
		int maxPosition = -1;
		for(LocationOrderObject *lo in self.gameRoute.locations)
		{
			if (lo.location.visitedInGame)
			{
				if (maxPosition < [lo.position intValue])
				{
					maxPosition = [lo.position intValue];
				}
				continue;
			}
		}
		maxPosition++;
		// Now find maxPosition
		for(LocationOrderObject *lo in self.gameRoute.locations)
		{
			if ([lo.position intValue] == maxPosition)
			{
				return lo.location;
			}
		}
	}
		
	for(LocationObject *l in self.game.locations)
	{
		switch ([l.locationType intValue])
		{
			case LTYPE_RALLY_SCORE:
				if (l.visitedInGame == nil)
				{
					return l;
				}
				break;
		}
	}
	// Return nil if nothing suitable
	return nil;
}

-(BOOL) ensureLocationIsActive: (LocationObject *) loc
{
	// Return YES if we have a state change (wasn't already active)
	for(ActiveLocationObject *alo in self.activeLocations)
	{
		if (alo.location == loc)
		{
			if ([alo.active boolValue] == NO)
			{
				alo.active = [NSNumber numberWithBool:YES];
				return YES;
			}
			return NO;
		}
	}
	// Create one
	NSEntityDescription *edesc = [NSEntityDescription entityForName:@"ActiveLocation" inManagedObjectContext:[self managedObjectContext]];
	ActiveLocationObject *alo = [[ActiveLocationObject alloc] initWithEntity:edesc insertIntoManagedObjectContext:[self managedObjectContext]];
	alo.active = [NSNumber numberWithBool: YES];
	alo.maxAmount = loc.maxLevel;
	alo.amountRate = loc.level;
	alo.currentAmount = [NSNumber numberWithInt: 0];
	alo.targetModifies = loc.locationType;
	alo.location = loc;
	alo.gameRun = self;
	[alo release];
	return YES;
}

-(BOOL) ensureLocationIsInactive: (LocationObject *) loc
{
	// Return YES if we have a state change (was active)
	for(ActiveLocationObject *alo in self.activeLocations)
	{
		if (alo.location == loc)
		{
			if ([alo.active boolValue] == YES)
			{
				alo.active = [NSNumber numberWithBool:NO];
				return YES;
			}
		}
	}
	return NO;
}
@end
