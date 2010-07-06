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
-(NSDictionary *)getCopyAsExportDictionary
{
	NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
	[ret setObject:self.level forKey:@"level"];
	[ret setObject:self.locationType forKey:@"locationType"];
	if (self.name == nil)
	{
		self.name = @"Name";
	}
	[ret setObject:self.name forKey:@"name"];
	[ret setObject:self.maxLevel forKey:@"maxLevel"];
	// And also the locationPoint objects
	// Start with the first and put them in an array - we can recreate the linked list back on import
	NSMutableArray *locs = [[NSMutableArray alloc] init];
	LocationPointObject *p = self.firstPoint;
	while(p)
	{
		NSDictionary *lp = [p getCopyAsExportDictionary];
		[locs addObject:lp];
		[lp release];
		p = p.nextPoint;
	}
	[ret setObject:locs forKey:@"locationPoints"];
	[locs release];
	return ret;	
}

+(LocationObject *) newFromExportDictionary: (NSDictionary *) dict inManagedObjectContext: (NSManagedObjectContext *) context
{
	NSEntityDescription *edesc = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:context];
	LocationObject *location = [[LocationObject alloc] initWithEntity:edesc insertIntoManagedObjectContext:context];
	location.name = [dict valueForKey: @"name"];
	location.level = [dict valueForKey: @"level"];
	location.locationType = [dict valueForKey: @"locationType"];
	location.maxLevel = [dict valueForKey: @"maxLevel"];
	NSArray *locPoints = [dict valueForKey:@"locationPoints"];
	LocationPointObject *p = nil;
	for(NSDictionary *pointDict in locPoints)
	{
		LocationPointObject *locPoint = [LocationPointObject newFromExportDictionary: pointDict inManagedObjectContext:context];
		if (p == nil)
		{
			location.firstPoint = locPoint;
		}
		else
		{
			p.nextPoint = locPoint;
		}
		p = locPoint;
	}
	return location;
}
@end
