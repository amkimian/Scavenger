//
//  GameObject_Extensions.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "GameObject+Extensions.h"
#import "LocationObject+Extensions.h"
#import "GameRouteObject.h"
#import "LocationOrderObject.h"

@implementation GameObject(Extensions)
-(LocationObject *) addLocationOfType: (LocationType) type
{
	// Create new LocationObject, setup its type, and add it to the locations set
	// Some types can only have one type, so if they are already in the locations set, return
	// that one
	
	NSMutableSet *locations = [self mutableSetValueForKey: @"locations"];
	int iType = (int) type;
	if (iType <= (int) LTYPE_CENTER)
	{
		for(LocationObject *loc in [locations allObjects])
		{
			if ([loc.locationType intValue] == (int) type)
			{
				return loc;
			}
		}
	}
	// Otherwise create a new one and add it
	NSEntityDescription *edesc = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:[self managedObjectContext]];
	LocationObject *loc = [[LocationObject alloc] initWithEntity:edesc insertIntoManagedObjectContext:[self managedObjectContext]];
	loc.locationType = [NSNumber numberWithInt:(int) type];
	[locations addObject:loc];
	
	// If this is a LTYPE_RALLY_SCORE, add it to the Default GameRouteObject
	if (type == LTYPE_RALLY_CHARGE || type == LTYPE_RALLY_FIX || type == LTYPE_RALLY_SCORE)
	{
		[self addLocationToDefaultRoute:loc];
	}
	return loc;
}

-(void) removeLocationObject: (LocationObject *) loc
{
    NSMutableSet *l = [self mutableSetValueForKey:@"locations"];
	[l removeObject:loc];
	// If this is a LTYPE_RALLY_SCORE, remove it from the Default GameRouteObject
	// ??? Hmm - will this automatically disappear?
}

-(LocationObject *) getLocationOfType: (LocationType) type
{
	NSMutableSet *locations = [self mutableSetValueForKey: @"locations"];
	int iType = (int) type;
	if (iType <= (int) LTYPE_CENTER)
	{
		for(LocationObject *loc in [locations allObjects])
		{
			if ([loc.locationType intValue] == (int) type)
			{
				return loc;
			}
		}
	}
	return nil;
}

-(NSString *) title
{
	return self.name;
}

-(CLLocationCoordinate2D) coordinate
{
	LocationObject *centerPoint = [self getLocationOfType: LTYPE_CENTER];
	CLLocationCoordinate2D ret;
	ret.latitude = [centerPoint.latitude floatValue];
	ret.longitude = [centerPoint.longitude floatValue];
	return ret;
}

/**
 * This is a new location that needs to be added to the special
 * "default" route
 */

-(void) addLocationToDefaultRoute: (LocationObject *) loc
{
	GameRouteObject *mainRoute = nil;
	
	for(GameRouteObject *gRoute in self.gameRoutes)
	{
		if ([gRoute.name isEqualToString: @"Default"])
		{
			mainRoute = gRoute;
			break;
		}
	}
	if (mainRoute == nil)
	{
		NSEntityDescription *edesc = [NSEntityDescription entityForName:@"GameRoute" inManagedObjectContext:[self managedObjectContext]];
		mainRoute = [[GameRouteObject alloc] initWithEntity:edesc insertIntoManagedObjectContext:[self managedObjectContext]];
		mainRoute.name = @"Default";
		[self addGameRoutesObject:mainRoute];
	}
	
	// Now add this location to that route
	NSEntityDescription *edesc = [NSEntityDescription entityForName:@"LocationOrder" inManagedObjectContext:[self managedObjectContext]];
	LocationOrderObject *lo = [[LocationOrderObject alloc] initWithEntity:edesc insertIntoManagedObjectContext:[self managedObjectContext]];
	lo.location = loc;
	lo.position = [NSNumber numberWithInt: [mainRoute.locations count]];
	[mainRoute addLocationsObject:lo];	
}

@end
