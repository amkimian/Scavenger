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
#import "LocationPointObject.h"
#import "HardwareObject+Extensions.h"
#import "GameRunObject+Extensions.h"

@implementation GameObject(Extensions)

-(BOOL) canResume
{
	for(LocationObject *l in self.locations)
	{
		if ([l.locationType intValue] == LTYPE_PLAYER)
		{
			return YES;
		}
	}
	return NO;
}

-(LocationObject *) newLocationOfType: (LocationType) type at:(CLLocationCoordinate2D) coord;
{
	// Create new LocationObject, setup its type, and add it to the locations set
	// Some types can only have one type, so if they are already in the locations set, return
	// that one
	
	NSMutableSet *locations = [self mutableSetValueForKey: @"locations"];
	int iType = (int) type;
	if (IS_SINGLE(iType))
	{
		for(LocationObject *loc in [locations allObjects])
		{
			if ([loc.locationType intValue] == (int) type)
			{
				NSLog(@"Updating existing entity");
				loc.firstPoint.latitude = [NSNumber numberWithFloat: coord.latitude];
				loc.firstPoint.gameLatitude = loc.firstPoint.latitude;
				loc.firstPoint.longitude = [NSNumber numberWithFloat: coord.longitude];
				loc.firstPoint.gameLongitude = loc.firstPoint.longitude;
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
	if (type == LTYPE_RALLY_SCORE)
	{
		[self addLocationToDefaultRoute:loc];
		// And add some default points
		loc.maxLevel = [NSNumber numberWithFloat:1000.0];
		loc.level = [NSNumber numberWithFloat:100.0];
	}
	else
	{
		// Different defaults
		loc.maxLevel = [NSNumber numberWithFloat:100.0];
		loc.level = [NSNumber numberWithFloat:10.0];		
	}
	
	// Update the location of the first point (adding it in this case)
	
	NSEntityDescription *edesc2 = [NSEntityDescription entityForName:@"LocationPoint" inManagedObjectContext:[self managedObjectContext]];
	LocationPointObject *lPoint = [[LocationPointObject alloc] initWithEntity:edesc2 insertIntoManagedObjectContext:[self managedObjectContext]];
	lPoint.latitude = [NSNumber numberWithFloat: coord.latitude];
	lPoint.longitude = [NSNumber numberWithFloat: coord.longitude];
	loc.firstPoint = lPoint;
	
	return loc;
}

-(void) removeLocationOfType: (LocationType) type
{
	for(LocationObject *l in self.locations)
	{
		if ([l.locationType intValue] == type)
		{
			[self removeLocationObject: l];
			return;
		}
	}
}

-(void) removeLocationObject: (LocationObject *) loc
{
    NSMutableSet *l = [self mutableSetValueForKey:@"locations"];
	[l removeObject:loc];
	// If this is a LTYPE_RALLY_SCORE, remove it from the Default GameRouteObject
	// ??? Hmm - will this automatically disappear?
}

/**
  * Returns first location of this type
  */

-(LocationObject *) getLocationOfType: (LocationType) type
{
	NSMutableSet *locations = [self mutableSetValueForKey: @"locations"];
		for(LocationObject *loc in [locations allObjects])
		{
			if ([loc.locationType intValue] == (int) type)
			{
				return loc;
			}
		}
	return nil;
}

-(NSString *) title
{
	return self.name;
}

/**
 * This is the annotation protocol implementation
 */

-(CLLocationCoordinate2D) coordinate
{
	LocationObject *centerPoint = [self getLocationOfType: LTYPE_START];
	CLLocationCoordinate2D ret;
	ret.latitude = [centerPoint.firstPoint.latitude floatValue];
	ret.longitude = [centerPoint.firstPoint.longitude floatValue];
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
	[lo release];
}



/*
 * Create a new gameRun for this game (maybe deleting the old one)
 */

-(GameRunObject *) createGameRun
{
	// Wipe out existing gameRun
	self.gameRun = nil;
	// Create a new one
	NSEntityDescription *edesc = [NSEntityDescription entityForName:@"GameRun" inManagedObjectContext:[self managedObjectContext]];
	GameRunObject *gameRun = [[GameRunObject alloc] initWithEntity:edesc insertIntoManagedObjectContext:[self managedObjectContext]];
	self.gameRun = gameRun;
	
	// Now set it all up (including Hardware etc.)
	
	[gameRun updateGameState:NOTSTARTED];
	[gameRun addHardwareWithName:@"Radar" active:YES andPowerUsage:10.0 andMaxLevel:100.0 andHudCode:@"RDR"];
	[gameRun addHardwareWithName:@"Hazard" active:YES andPowerUsage:10.0 andMaxLevel:100.0 andHudCode:@"HZD"];
	[gameRun addHardwareWithName:@"Bonus" active:YES andPowerUsage:10.0 andMaxLevel: 100.0 andHudCode:@"WPR"];
	[gameRun addHardwareWithName:@"Shield" active:YES andPowerUsage:10.0 andMaxLevel: 100.0 andHudCode:@"SHD"];
	[gameRun addHardwareWithName:@"Power" active:YES andPowerUsage:0.0 andMaxLevel: 10000.0 andHudCode:@"PWR"];
	[gameRun addHardwareWithName:@"Ping" active:NO andPowerUsage:50.0 andMaxLevel: 100.0 andHudCode:@"PNG"];
	[gameRun addHardwareWithName:@"Fix" active:NO andPowerUsage:50.0 andMaxLevel: 100.0 andHudCode:@"FIX"];
	
	// Also setup the route
	gameRun.gameRoute = [self.gameRoutes anyObject];
	
	// Setup the initial score and bonus from the start and end location types
	LocationObject *startObject = [self getLocationOfType:LTYPE_START];
	gameRun.score = startObject.maxLevel;
	LocationObject *endObject = [self getLocationOfType:LTYPE_END];
	gameRun.bonus = endObject.maxLevel;
	return gameRun;
}

@end
