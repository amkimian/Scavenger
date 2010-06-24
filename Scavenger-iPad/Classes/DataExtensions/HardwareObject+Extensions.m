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

-(float) getPercentage
{
	return 100 * [self.level floatValue] / [self.maxLevel floatValue];	
}

-(float) getRadarRange
{
	if ([self.active boolValue] && [self.hasPower boolValue])
	{
		return 4.8 * [self getPercentage];
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
	float p = [self getPercentage];
	if (p > 50)
	{
		return [UIColor greenColor];
	}
	if (p > 25)
	{
		return [UIColor yellowColor];
	}
	if (p > 0)
	{
		return [UIColor redColor];
	}
	return [UIColor blackColor];
}

-(void) updateLevelBy: (float) amount
{
	float current = [self.level floatValue];
	current += amount;
	if (current > [self.maxLevel floatValue])		
	{
		current = [self.maxLevel floatValue];
	}
	self.level = [NSNumber numberWithFloat: current];
}

@end
