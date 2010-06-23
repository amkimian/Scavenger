//
//  GameRunObject+Extensions.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/22/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "GameRunObject+Extensions.h"


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

-(void) addHardwareWithName: (NSString *) name andPowerUsage: (int) powerUsage
{
	// Create hardware and add it to this gameRun object
	NSEntityDescription *edesc = [NSEntityDescription entityForName:@"Hardware" inManagedObjectContext:[self managedObjectContext]];
	HardwareObject *hardware = [[HardwareObject alloc] initWithEntity:edesc insertIntoManagedObjectContext:[self managedObjectContext]];
	hardware.name = name;
	hardware.active = [NSNumber numberWithBool: YES];
	hardware.damage = [NSNumber numberWithInt: 0];
	hardware.powerUse = [NSNumber numberWithInt: powerUsage];
	[self addHardwareObject:hardware];	
}

@end
