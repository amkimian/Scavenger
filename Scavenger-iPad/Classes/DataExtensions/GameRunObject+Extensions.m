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

-(void) addHardwareWithName: (NSString *) name andPowerUsage: (int) powerUsage  andHudCode: (NSString *) hud;

{
	// Create hardware and add it to this gameRun object
	NSEntityDescription *edesc = [NSEntityDescription entityForName:@"Hardware" inManagedObjectContext:[self managedObjectContext]];
	HardwareObject *hardware = [[HardwareObject alloc] initWithEntity:edesc insertIntoManagedObjectContext:[self managedObjectContext]];
	hardware.name = name;
	hardware.active = [NSNumber numberWithBool: YES];
	hardware.damage = [NSNumber numberWithInt: 0];
	hardware.powerUse = [NSNumber numberWithInt: powerUsage];
	hardware.hasPower = [NSNumber numberWithBool: YES];
	hardware.hudCode = hud;
	[self addHardwareObject:hardware];	
}

-(LocationObject *) findNextRallyPoint
{
	// If we have a routeObject, use that by traversing down the route for the first non-visited object
	// otherwise just loop through the locations looking for locations of type LTYPE_RALLY_* that are not visited
	// and return the first one found
	
	for(LocationObject *l in self.game.locations)
	{
		switch ([l.locationType intValue])
		{
			case LTYPE_RALLY_SCORE:
			case LTYPE_RALLY_FIX:
			case LTYPE_RALLY_CHARGE:
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
	alo.maxAmount = loc.score;
	alo.amountRate = loc.scoreInterval;
	alo.currentAmount = [NSNumber numberWithInt: 0];
	alo.targetModifies = loc.locationType;
	alo.location = loc;
	alo.gameRun = self;
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
