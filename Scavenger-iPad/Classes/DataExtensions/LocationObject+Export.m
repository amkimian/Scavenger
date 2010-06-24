//
//  LocationObject+Export.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/24/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "LocationObject+Export.h"
#import "LocationPointObject+Export.h"

@implementation LocationObject(Export)
-(NSDictionary *)getAsExportDictionary
{
	NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
	[ret setObject:self.level forKey:@"level"];
	[ret setObject:self.locationType forKey:@"locationType"];
	[ret setObject:self.name forKey:@"name"];
	[ret setObject:self.maxLevel forKey:@"maxLevel"];
	// And also the locationPoint objects
	// Start with the first and put them in an array - we can recreate the linked list back on import
	NSMutableArray *locs = [[NSMutableArray alloc] init];
	LocationPointObject *p = self.firstPoint;
	while(p)
	{
		[locs addObject:[p getAsExportDictionary]];
	}
	[ret setObject:locs forKey:@"locationPoints"];
	return ret;	
}
@end
