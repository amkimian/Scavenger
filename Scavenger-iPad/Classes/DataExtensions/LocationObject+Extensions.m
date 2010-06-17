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

-(NSString *) locationTypeString
{
	// Color is based on type
	LocationType lType = [self.locationType intValue];
	switch(lType)
	{
		case LTYPE_START:
			return @"Start Location";
		case LTYPE_END:
			return @"Finish Location";
		case LTYPE_CENTER:
			return @"Display center";
		case LTYPE_HAZARD_SHIELD:
			return @"Hazard that attacks shield";
		case LTYPE_HAZARD_LIFE:
			return @"Hazard that attacks life";
		case LTYPE_HAZARD_RADAR:
			return @"Hazard that attacks radar";
		case LTYPE_HAZARD_FIND_HAZARD:
			return @"Degrades ability to find hazards";
		case LTYPE_HAZARD_FIND_HAZARD_TYPE:
			return @"Degrades ability to find out type of hazard";
		case LTYPE_HAZARD_FIND_RALLY:
			return @"Degrades ability to find a bonus";
		case LTYPE_HAZARD_FIND_RALLY_TYPE:
			return @"Degrades ability to find out type of bonus";
		case LTYPE_HAZARD_SCORE:
			return @"Reduces score";
		case LTYPE_HAZARD_LOC_PING:
			return @"Degrades ability to ping location";
		case LTYPE_HAZARD_FIX:
			return @"Degrades ability to fix things";
		case LTYPE_RALLY_CHARGE:
			return @"Recharges";
		case LTYPE_RALLY_SCORE:
			return @"Score";
		case LTYPE_RALLY_FIX:
			return @"Improves the ability to fix";
		default:
			return @"";
	}
}

@end
