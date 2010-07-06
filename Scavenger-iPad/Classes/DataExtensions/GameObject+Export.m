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

+(GameObject *) newFromExportDictionary: (NSDictionary *) dict inManagedObjectContext: (NSManagedObjectContext *) context
{
	// Create a new GameObject in the given context, and set it up based on the dictionary
	// Do the reverse of the above
	
	NSEntityDescription *edesc = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:context];
	GameObject *game = [[GameObject alloc] initWithEntity:edesc insertIntoManagedObjectContext:context];
	
	game.name = [dict objectForKey: @"Name"];
	NSArray *locs = (NSArray *) [dict objectForKey:@"Locations"]; 
	for(NSDictionary *locDict in locs)
	{
		LocationObject *loc = [LocationObject newFromExportDictionary:locDict inManagedObjectContext: context];
		[game addLocationsObject:loc];
		[loc release];
	}
	return game;
}

@end
