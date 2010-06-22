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

@end
