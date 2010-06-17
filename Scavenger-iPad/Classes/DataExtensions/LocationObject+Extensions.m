//
//  LocationObject+Extensions.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "LocationObject+Extensions.h"


@implementation LocationObject(Extensions)
-(UIColor *) locationDisplayColor
{
	// Color is based on type
	LocationType lType = [self.locationType intValue];
	switch(lType)
	{
		case LTYPE_START:
			return [UIColor greenColor];
			break;
		case LTYPE_END:
			return [UIColor redColor];
			break;
		case LTYPE_CENTER:
			return [UIColor clearColor];
			break;
		case LTYPE_HAZARD_SHIELD:
		case LTYPE_HAZARD_LIFE:
		case LTYPE_HAZARD_RADAR:
		case LTYPE_HAZARD_FIND_HAZARD:
		case LTYPE_HAZARD_FIND_HAZARD_TYPE:
		case LTYPE_HAZARD_FIND_RALLY:
		case LTYPE_HAZARD_FIND_RALLY_TYPE:
		case LTYPE_HAZARD_SCORE:
		case LTYPE_HAZARD_LOC_PING:
		case LTYPE_HAZARD_FIX:
			return [UIColor orangeColor];
		case LTYPE_RALLY_CHARGE:
		case LTYPE_RALLY_SCORE:
		case LTYPE_RALLY_FIX:
		default:
			return [UIColor blueColor];
	}	
}
@end
