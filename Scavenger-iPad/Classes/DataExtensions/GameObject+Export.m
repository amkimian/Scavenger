//
//  GameObject+Export.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/24/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "GameObject+Export.h"
#import "LocationObject+Export.h"

@implementation GameObject(Export)
-(NSDictionary *)getCopyAsExportDictionary
{
	NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
	// name, routes, locations
	[ret setObject:self.name forKey:@"Name"];
	// Store locations
	NSMutableArray *locs = [[NSMutableArray alloc] init];
	for(LocationObject *l in self.locations)
	{
		NSDictionary *locDict = [l getCopyAsExportDictionary];
		[locs addObject:locDict];
		[locDict release];
	}
	[ret setObject:locs forKey:@"Locations"];
	[locs release];
	return ret;
}
@end
