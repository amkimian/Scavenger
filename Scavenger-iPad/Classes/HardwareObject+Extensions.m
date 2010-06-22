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
	float ret = 480.0;
	ret /= 100;
	ret *= [self.damage intValue];
	return ret;
}

@end
