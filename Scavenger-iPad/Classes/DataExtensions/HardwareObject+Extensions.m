//
//  HardwareObject+Extensions.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/22/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "HardwareObject+Extensions.h"


@implementation HardwareObject(Extensions)

// Assumes that this hardware object has name "Radar"

-(float) getRadarRange
{
	if ([self.active boolValue] && [self.hasPower boolValue])
	{
		float ret = 480.0;
		ret /= 100;
		ret *= 100 - [self.damage intValue];
		return ret;
	}
	else
	{
		return 15.0f;
	}
}

-(UIColor *) getStatusColor
{
	// The damage is 0 - 100 where 100 is destroyed
	
	if ([self.active boolValue] == NO)
	{
		return [UIColor grayColor];
	}
	if ([self.hasPower boolValue] == NO)
	{
		return [UIColor darkGrayColor];
	}
	int d = [self.damage intValue];
	if (d < 50)
	{
		return [UIColor greenColor];
	}
	if (d < 75)
	{
		return [UIColor yellowColor];
	}
	if (d < 99)
	{
		return [UIColor redColor];
	}
	return [UIColor blackColor];
}

@end
