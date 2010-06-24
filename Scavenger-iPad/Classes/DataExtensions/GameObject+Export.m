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
-(NSDictionary *)getAsExportDictionary
{
	NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
	// name, routes, locations
	[ret setObject:self.name forKey:@"Name"];
	// Store locations
	NSMutableArray *locs = [[NSMutableArray alloc] init];
	for(LocationObject *l in self.locations)
	{
		[locs addObject:[l getAsExportDictionary]];
	}
	[ret setObject:locs forKey:@"Locations"];
	return ret;
}
@end
